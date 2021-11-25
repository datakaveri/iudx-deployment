
## Making a jks 

1. Obtain PEM from certbot 
`sudo certbot certonly --manual --preferred-challenges dns -d demo.example.com`
2. Concat all pems into one file 
`sudo cat /etc/letsencrypt/life/demo.example.com/*.pem > fullcert.pem`
3. Convert to pkcs format 
` openssl pkcs12 -export -out fullcert.pkcs12 -in fullcert.pem`
4. Make JKS, will prompt for password 
`keytool -v -importkeystore -srckeystore fullcert.pkcs12 -destkeystore keystore.jks -deststoretype JKS`
5. Store JKS in config directory and edit the keyfile name and password entered in previous step
