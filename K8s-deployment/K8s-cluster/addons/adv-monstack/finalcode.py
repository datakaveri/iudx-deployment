import re
import requests,json,time
from requests.structures import CaseInsensitiveDict
import prometheus_client as prom
import schedule
from datetime import datetime
import pytz


def token(clientId,clientSecret,data,url):
        url = "https://authvertx.iudx.io/auth/v1/token"

        headers = CaseInsensitiveDict()
        headers["clientId"] = clientId
        headers["clientSecret"] = clientSecret
        headers["Content-Type"] = "application/json"



        resp = requests.post(url, headers=headers, data=json.dumps(data))
        json_object = json.loads(resp.text)
        return (json_object["results"]["accessToken"])

def request(request_method,Api_Token,Api_Url,info,files,name):

        headers = CaseInsensitiveDict()
        headers["token"] = Api_Token
        headers["Conten"] = "application/json"
        if name == "Upload external file link to a File Server" or name == "Delete external file from a File Server":
                headers["externalStorage"] = "true"
        resp = requests.request(request_method,Api_Url, headers=headers, data=info,files=files)
        print(name)
        return (resp)


def AMS(config,status_dict,time_dict,IST):
        archive_file_id = ""
        external_file_id = ''
        for info in config["Info"]:

                if info["Test-Name"] == "Upload sample file to a File Server":
                        auth_token = token(config["clientID"],config["clientSecret"],info["Auth-Request-Body"],info["Auth-Server-Url"])
                        files = [('file',('a.txt',open('/home/ubuntu/a.txt','rb'),'text/plain'))]
                        req = request(info["Request-Method"],str(auth_token),info["Server-Url"],json.loads(info["Request-Body"]),files,info["Test-Name"])

                     
                elif info["Test-Name"] == "Upload archive file to a File Server":
                        auth_token = token(config["clientID"],config["clientSecret"],info["Auth-Request-Body"],info["Auth-Server-Url"])
                        files = [('file',('a.zip',open('/home/ubuntu/a.zip','rb'),'application/zip'))]
                        req = request(info["Request-Method"],str(auth_token),info["Server-Url"],json.loads(info["Request-Body"]),files,info["Test-Name"])
                        archive_file_id = (json.loads(req.text))["fileId"]
                        
                        
        
                elif info["Test-Name"] == "Upload external file link to a File Server":
                        auth_token = token(config["clientID"],config["clientSecret"],info["Auth-Request-Body"],info["Auth-Server-Url"])
                        req = request(info["Request-Method"],str(auth_token),info["Server-Url"],info["Request-Body"],"",info["Test-Name"]) 
                        external_file_id = json.loads(req.text)["fileId"]

                elif info["Test-Name"] == "Download archive file from a File Server":
                        auth_token = token(config["clientID"],config["clientSecret"],info["Auth-Request-Body"],info["Auth-Server-Url"])
                        req = request(info["Request-Method"],str(auth_token),info["Server-Url"]+archive_file_id,info["Request-Body"],"",info["Test-Name"])
 
                elif info["Test-Name"] == "Delete archive file from a File Server":
                        auth_token = token(config["clientID"],config["clientSecret"],info["Auth-Request-Body"],info["Auth-Server-Url"])
                        req = request(info["Request-Method"],str(auth_token),info["Server-Url"]+archive_file_id,info["Request-Body"],"",info["Test-Name"])
                        
                elif info["Test-Name"] == "Delete external file from a File Server":
                        auth_token = token(config["clientID"],config["clientSecret"],info["Auth-Request-Body"],info["Auth-Server-Url"])
                        req = request(info["Request-Method"],str(auth_token),info["Server-Url"]+external_file_id,info["Request-Body"],"",info["Test-Name"])

                elif info["Type"] == "private":
                        auth_token = token(config["clientID"],config["clientSecret"],info["Auth-Request-Body"],info["Auth-Server-Url"],)
                        req = request(info["Request-Method"],str(auth_token),info["Server-Url"],info["Request-Body"],"",info["Test-Name"])            
                else :
                        req = request(info["Request-Method"],"",info["Server-Url"],info["Request-Body"],"",info["Test-Name"])
                status_code = str(req.status_code)
                status_code_metric.labels(info["Server-Name"],info["Server-Url"],info["Test-Name"]).set(status_code)
                RTT = req.elapsed.total_seconds()
                rtt_metric.labels(info["Server-Name"],info["Server-Url"],info["Test-Name"]).set(RTT)
                curr_clock = datetime.now(IST).strftime('%H.%M')
                api_req_time.labels(info["Server-Name"],info["Server-Url"],info["Test-Name"]).set(float(curr_clock))
                   






if __name__ == '__main__':
        prom.start_http_server(8089)

with open("/home/ubuntu/adv-mon-stack-conf.json") as file:
    config = json.load(file)

status_dict = {}
time_dict = {}

status_code_metric = prom.Gauge('http_status_code','http_status_code',["Servername","Url","Name"])
rtt_metric = prom.Gauge('api_rtt','api_rtt',["Servername","Url","Name"])
api_req_time = prom.Gauge('api_req_time','api_req_time',["Servername","Url","Name"])
IST = pytz.timezone('Asia/Kolkata')
#schedule.every().day.at(config["Time"]).do(AMS,config,status_dict,time_dict)
schedule.every(1).seconds.do(AMS,config,status_dict,time_dict,IST)



while True:
                schedule.run_pending()
                time.sleep(1)

