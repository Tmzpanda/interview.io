## S3
object storage/eventual consistency

bucket
lifecycle management/transition/expiration
bucket policy/IAM/JSON
data encryption/versioning/cross-region replica/transfer acceleration

object
Standard/Standard_IA/Glacier


Athena
query and analyze data in S3 using SQL




# AWS
VPC/logically isolated section of AWS cloud/VPN
EC2/instance/server
RDS
S3/object store

EMR/hadoop framework/coupled with EC2
Lambda/event-driven/IAM role/serverless/infrastructure administration/
EC2/security/timeout/dependencies/scalability feature/on-demand/cold start-up latency/
ECS/docker daemon/task definition metadata
Kinesis/Kafka
DynamoDB/document database/HBase/column-based




# AWS

CLI & SDK

IAM
- group & user
- role
- policy

EC2
- security group
- ssh
- ENI
- role

VPC
- CIDR





Route 53
- A Record
- Alias Record


ELB 
- ALB & NLB
- target group



API Gateway
- 

CloudWatch vs Datadog


CloudFront


VM vs Docker vs Container
- ECS




command to deploy website 
```shell

zip
s3/bucket and object public
ec2/http port80
sudo su
yum update
yum install httpd -y
cd /var/www/html
wget https://webserver-tmzpanda.s3.amazonaws.com/website.zip
unzip website.zip
mv website/* .
service httpd start





sudo su
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
curl localhost:80

```


# aws-basics

* **[Kinesis](https://aws.amazon.com/kinesis/?nc=sn&loc=0)**
  - [Log Analytics Solution](https://aws.amazon.com/getting-started/hands-on/build-log-analytics-solution/)
    - Kinesis Agent(installed on EC2) produces Log Files to Kinesis Firehose(connected with S3)
