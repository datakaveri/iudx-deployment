import logging
import sys
from fastapi import FastAPI, Request, Header, HTTPException
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from pathlib import Path
from job import job
from multiprocessing import Process
from config import env 
# Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),  
    ]
)
logger = logging.getLogger(__name__)

# Api
app = FastAPI()

# Parse env

class S3Event(BaseModel):
    EventName: str
    Key: str

@app.post("/webhook")
async def execute_route(
    body: S3Event, 
    authorization: str = Header(None)
):
    if authorization is None or authorization != env.auth_token:
        print(authorization)
        print(env.auth_token)
        raise HTTPException(status_code=401, detail="Unauthorized: Missing or invalid Authorization header")
    if not body.EventName in s3_put_event:
        raise HTTPException(status_code=422,detail="Invalid S3 Method")
    if not body.EventName in s3_event_for_operation:
        return {"message":"We don't support this method {}".format(body.EventName)}
    file = Path(body.Key)
    if not file.suffix in valid_file_types:
        raise HTTPException(status_code=422,detail="Invalid Extension")
    p = Process(target=job, args=(body.Key,))
    p.start()
    return {"message": "OK"}

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    logger.error(f"Validation error: {exc}")
    return JSONResponse(
        status_code=400,
        content={"message": "Invalid request body"},
    )

s3_put_event = [
    "s3:ObjectCreated:CompleteMultipartUpload",
    "s3:ObjectCreated:Copy",
    "s3:ObjectCreated:DeleteTagging",
    "s3:ObjectCreated:Post",
    "s3:ObjectCreated:Put",
    "s3:ObjectCreated:PutLegalHold",
    "s3:ObjectCreated:PutRetention",
    "s3:ObjectCreated:PutTagging",
]

s3_event_for_operation = [
    "s3:ObjectCreated:CompleteMultipartUpload",
    "s3:ObjectCreated:Post",
    "s3:ObjectCreated:Put",
]

valid_file_types = [".xlsx", ".csv", ".json"]
