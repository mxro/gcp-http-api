# gcp-http-api

Example of HTTP API in GCP using Go and Cloud Functions

API Gateway:
https://cloud.google.com/api-gateway/docs/secure-traffic-gcloud

https://cloud.google.com/api-gateway/docs/gateway-serverless-neg

https://cloud.google.com/load-balancing/docs/ssl-certificates/google-managed-certs#gcloud

## Create and Set Project

```
gcloud config set project gcp-http-api
```

## Enable APIs

```
gcloud services enable apigateway.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable servicemanagement.googleapis.com
gcloud services enable servicecontrol.googleapis.com
```

## Deploy Cloud Function

```
gcloud functions deploy hello-http --gen2 --runtime=go119 --source=functions/hello  --entry-point=hello-http --region=us-central1 --trigger-http --allow-unauthenticated 
```

## Create API Gateway

```
gcloud api-gateway apis create gcp-http-api
```

Describe API:

```
gcloud api-gateway apis describe gcp-http-api
```


## Create Certificate

```
gcloud compute ssl-certificates create gcp-http-api \
    --description="GCP HTTP API" \
    --domains=gcp-api.examples.mxro.de \
    --global
```

## List Certificates

```
gcloud compute ssl-certificates list \
   --global
```

## Create Load Balancer

Create IP address

```
gcloud compute addresses create lb-ipv4-1 \
    --ip-version=IPV4 \
    --network-tier=PREMIUM \
    --global
```

Get IP address

```
gcloud compute addresses describe lb-ipv4-1 \
    --format="get(address)" \
    --global

> 34.160.117.203
```

Create health check

```
  gcloud compute health-checks create http http-basic-check \
      --port 80

> health check name: http-basic-check
```

Create URL MAP

```
  gcloud compute url-maps create web-map-http \
      --default-service web-backend-service
  
```

Set SSL certificate

```
gcloud compute target-https-proxies update TARGET_PROXY_NAME \
    --ssl-certificates gcp-http-api \
    --global-ssl-certificates \
    --global
```
