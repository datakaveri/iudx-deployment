import re
import requests,json,time
from requests.structures import CaseInsensitiveDict
import prometheus_client as prom
import schedule
from datetime import datetime
import pytz

# Functions for obtaining an access token for API
def token(clientId,clientSecret,data,url):

        headers = CaseInsensitiveDict()
        headers["clientId"] = clientId
        headers["clientSecret"] = clientSecret
        headers["Content-Type"] = "application/json"
        resp = requests.post(url, headers=headers, data=json.dumps(data))
        json_object = json.loads(resp.text)
        return (json_object["results"]["accessToken"])

# Functions for making requests to an API.
def request(request_method,Api_Token,Api_Url,info,files,name):

        headers = CaseInsensitiveDict()
        headers["token"] = Api_Token
        headers["Content"] = "application/json"
        resp = requests.request(request_method,Api_Url, headers=headers, data=info,files=files)
        return (resp)

# Funtions to performs various API tests based on the provided configuration.
def AMS(config,status_dict,time_dict,IST):
        for info in config["Info"]:
                files=""
                if info["Test-Name"]=="Upload sample file link to a File Server":
                        files=[
                        ('file',('aa.txt',open('src/aa.txt','rb'),'text/plain'))
                        ]

                if info["Type"] == "private":
                        auth_token = token(config["clientID"],config["clientSecret"],info["Auth-Request-Body"],config["Auth-Server-Url"])
                        req = request(info["Request-Method"],str(auth_token),info["Server-Url"],info["Request-Body"],files,info["Test-Name"]) 
                        status_code = str(req.status_code)
                elif info["Type"] == "array_check":
                        req = request(info["Request-Method"],"",info["Server-Url"],info["Request-Body"],files,info["Test-Name"])
                        json_object = json.loads(req.text)

                         # If results array is empty, set status code to 204
                        if req.status_code == 200 and  len(json_object["results"]) == 0:
                                status_code = "204"
                        else:
                                status_code = str(req.status_code)
                                
                else :
                        req = request(info["Request-Method"],"",info["Server-Url"],info["Request-Body"],files,info["Test-Name"])
                        status_code = str(req.status_code)

                status_code_metric.labels(info["Server-Name"],info["Server-Url"],info["Test-Name"]).set(status_code)
                RTT = req.elapsed.total_seconds()
                rtt_metric.labels(info["Server-Name"],info["Server-Url"],info["Test-Name"]).set(RTT)
                curr_clock = datetime.now(IST).strftime('%H.%M')
                api_req_time.labels(info["Server-Name"],info["Server-Url"],info["Test-Name"]).set(float(curr_clock))
                print("Test: ", info["Test-Name"], " completed")






if __name__ == '__main__':
        prom.start_http_server(8089)

#Load APIs configuration from a JSON file named "adv-mon-stack-conf.json".
with open("adv-mon-stack-conf.json") as file:
    config = json.load(file)

#Set up Prometheus metrics using the prometheus_client library
status_dict = {}
time_dict = {}

status_code_metric = prom.Gauge('http_status_code','http_status_code',["Servername","Url","Name"])
rtt_metric = prom.Gauge('api_rtt','api_rtt',["Servername","Url","Name"])
api_req_time = prom.Gauge('api_req_time','api_req_time',["Servername","Url","Name"])
IST = pytz.timezone('Asia/Kolkata')
#Schedule the execution of the "AMS" function based on a specified time interval in the configuration.
schedule.every(config["Time"]).minutes.do(AMS,config,status_dict,time_dict,IST)



while True:
        schedule.run_pending()
        time.sleep(1)

