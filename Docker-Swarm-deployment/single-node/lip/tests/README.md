# Testing

A python script to do end-to-end test of latest ingestion pipeline. 
It tests by ingesting a sample surat-itms-live-eta data.
## Pre-existing Vhost 
### Pre-requisites
1. Install python3.8+ and  needed  packages

```sh  
pip install -r lip_requirements.txt 
```

2. Adjust the redis and rabbitmq connection information accordingly in 
python script ```lip.py```.

### Test
1. To test the working of latest ingestion pipeline
```sh 
python3 llip.py
```
2. The succesful output should be following
```
LIP succsefully completed end to end testing
```
## Testing with New Vhost
### Pre-requisites
1. Install python3.8+ and  needed  packages

```sh  
pip install -r test_lip_requirements.txt 
```
2. Adjust the redis and rabbitmq connection information accordingly in 
python script ```lip.py```

3. Configure the rabbitmq for test
```
pytest test_lip.py -k configuration
```
### Test
1. To test the working of latest ingestion pipeline
```sh 
pytest test_lip.py -k test_test
```
