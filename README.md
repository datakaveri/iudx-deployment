![IUDX](./docs/iudx.png)

# iudx-deployment
This repository gives installation and setup scripts to deploy IUDX platform. We provide and support two types of IUDX platform deployment : 
1. [Docker Swarm based deployment](./Docker-Swarm-deployment/single-node/README.md)
2. [K8s based deployment](./K8s-deployment/README.md)

IUDX platform consists of various IUDX built services and open source components. The overview IUDX platform with components is depicted in below figure.
<p align="center">
<img src="./docs/deployment_overview.png">
</p>
IUDX is data exchange platform facilitating seamless discovery, exchange of authorised data. Following is short explanation how various components interact in IUDX platform:

- Through IUDX Catalogue server users discovers different datasets available on the platform.
- A user can register with one or more roles (consumer/provider,data ingester/delegate)  in IUDX AAA and keycloak. The keycloak is used to manage identities of users.
 
- The user can get set/request policies at the AAA server, and get a token. IUDX AAA platform manages the policies, APDs through credentials/Policy Data store(Postgres)

- Through this token, user can publish(input)/consume (output) data from any of the  IUDX access resource servers (resource server, rs-proxy, GIS server, Data ingestion server)
 
- IUDX platform supports following input data flows
  - A data ingester ( delegate ) can pull the data from the downstream source (ICCC) and push it to databroker (Rabbitmq) . Which then is consumed by Logstash, latest ingestion pipeline and is pushed to the Meta Data/Data Store (Elasticsearch) and Latest Data store (Redis).
  - Also a data ingester can directly push data through HTTPS APIs exposed by Data Ingestion Server.

- IUDX platform supports following output data flows
  - Get data through standardised Resource access server APIs - spatial, temporal, complex, file, gis and async queries.
  - Get live streaming data through Rabbitmq using resource server Subscription
  - Get data from non IUDX resource server through resource-server proxy (rs-proxy). This is done through IUDX RS API query translation to non IUDX RS specific queries by set of adapters which reside close to non IUDX RS. The query and response is communicated to adapters and rs-proxy through databroker(Rabbitmq). 

- IUDX platform is monitored through micrometer, prometheus for metrics and promtail, Loki for logs and Grafana for Visualisation 
-  The alerting through SMTP server for emails or Telegram bot for telegram messages.
- All HTTPS API requests are processed through API gateway.
- The Rabbitmq specific communication i.e. streaming of data through AMQPS and HTTPS management interface is through streaming gateway
- Hazlecase with Zookeeper is used as our cluster manager for all Vert.x based API servers.

To know more on IUDX, refer following resources: 
1. [What is IUDX?](https://youtu.be/uWdmHztFrqs) To get overview of IUDX platform and its main motivation
2. [IUDX Architecture Overview for deep drive of IUDX architecture](https://www.youtube.com/watch?v=FeiZz0fJi5w)
3. [IUDX Developer Section](https://iudx.org.in/developers/)


## Features
- Service Mesh Architecture based Vert.x API servers.
- Each microservice is a well-defined module that can be containerized and discovered using service discovery. 
- Docker Swarm deployment enables easy, cost effective deployment of IUDX platform suitable for prototyping and PoC.
- Kubernetes based deployment of IUDX platform gives scalable, highly available system through clustered deployment of each component. Its suitable for production grade deployment.
- Both docker and K8s based deployment is cloud agnostic* and can be deployed on any cloud or on-prem. It 
has been tested currently on AWS and Azure.


\*Note: K8s deployment depends on certain cloud services - Load Balancer, Storage, Object Storage, K8s cluster autoscaling but since this is offered by major clouds. It can be integrated to these cloud providers.
## Contributing
We follow Git Merge based workflow
1. Fork this repo
2. Create a new feature branch in your fork. Multiple features must have a hyphen separated name, or refer to a milestone name as mentioned in Github -> Projects 
3. Commit to your fork and raise a Pull Request with upstream. <br>
A detailed instructions present [here](docs/git-commands.md).
