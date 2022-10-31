# Logs experiments

Example of running both graylog and logstash+kibana in EKS with AWS managed Elasticsearch. 

`cp .env.dist .env` and fill in required variables

Change `backend.tf` file to your s3 bucket

Then simply run `terraform apply`.
