# Testing
A python script to do end-to-end test of latest ingestion pipeline. 
It tests by ingesting a sample surat-itms-live-eta data.

### Pre-requisites
1. Install python3.8+ and  needed  packages

```sh  
    pip install -r requirements.txt 
```

### Configure
Before deploying LIP, configure the databroker if vhost is not already exist.
1. Rename `example-config.json` to `config.json`, and Substitute appropriate values whatever mentioned in config files
```sh
    cp example-config.json config.json
```
2. Keep `createVhost` as false if vhost already exist in above config.json file

```sh 
    "createVhost" : false
```
3. To configure, execute the command
```sh
    pytest test_lip.py -k test_configuration
```
4. If there's a green dot(.), then rmq is successful configured


### Test

1. To test the working of latest ingestion pipeline
```sh 
    pytest test_lip.py -k test_test
```
2. If there's a green dot(.), then test is successful completed

