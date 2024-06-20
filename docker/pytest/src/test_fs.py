import re
import requests,json,time
from requests.structures import CaseInsensitiveDict
import pytest

def token(clientId,clientSecret,data,url):
        headers = CaseInsensitiveDict()
        headers["clientId"] = clientId
        headers["clientSecret"] = clientSecret
        headers["Content-Type"] = "application/json"
        resp = requests.post(url, headers=headers, data=json.dumps(data))
        json_object = json.loads(resp.text)
        print("   Done")
        return (json_object["results"]["accessToken"])

def request(request_method,Api_Token,Api_Url,info,files,name):

        headers = CaseInsensitiveDict()
        headers["token"] = Api_Token
        headers["Content"] = "application/json"
        resp = requests.request(request_method,Api_Url, headers=headers, data=info, files=files, verify=False)
        return (resp)



@pytest.mark.parametrize("Server", ["Search Metadata Using Temporal Query", "List Metadata of a Resource","Upload sample file link to a File Server", "Download sample file from a File Server","Delete sample file from a File Server"])
def test_fs(config, Server):
    i=-1
    files=""
    for info in config["Info"]["File Server"]:
        i=i+1
        if info["Test-Name"]== Server:
            #if "Extra-header" in list(info.keys()):
            #    print(present)
            #    extraHeader=info["Extra-header"]
            if info["Test-Name"]=="Upload sample file link to a File Server":
                files=[
                    ('file',('aa.txt',open('aa.txt','rb'),'text/plain'))
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
                                
            else:
                req = request(info["Request-Method"],"",info["Server-Url"],info["Request-Body"],files,info["Test-Name"])
                status_code = str(req.status_code)
            assert status_code == "200"

