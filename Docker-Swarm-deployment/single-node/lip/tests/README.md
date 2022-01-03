# Testing

A python script to do end-to-end test of latest ingestion pipeline. 
It tests by ingesting a sample surat-itms-live-eta data.
## Pre-requisites
1. Install python3.8+ and  needed  packages

```sh  pip install -r requirements.txt 
```

2. Adjust the redis and rabbitmq connection information accordingly in 
python script ```latest-ingestion-pipeline-test.py```.

## Test
1. To test the working of latest ingestion pipeline
```sh python3 latest-ingestion-pipeline-test.py
```
2. The succesful output should be following
```
LIP succsefully completed end to end testing
```

