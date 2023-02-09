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
gcloud services enable compute.googleapis.com
gcloud services enable servicemanagement.googleapis.com
gcloud services enable servicecontrol.googleapis.com
```

## Deploy Cloud Function

```
gcloud functions deploy hello-http --gen2 --runtime=go119 --source=functions/hello  --entry-point=hello-http --region=us-central1 --trigger-http --allow-unauthenticated 
```

Deployed to: https://hello-http-55wgnx34ra-uc.a.run.app

## Create API Gateway

https://cloud.google.com/api-gateway/docs/secure-traffic-gcloud

```
gcloud api-gateway apis create gcp-http-api
```

Describe API:

```
gcloud api-gateway apis describe gcp-http-api
```

Create YAML `openapi-functions.yaml`

```
gcloud api-gateway api-configs create gcp-http-api-config \
  --api=gcp-http-api --openapi-spec=openapi-functions.yaml 
```


Create gateway - gateway defines external URL

```
gcloud api-gateway gateways create gcp-http-api-gateway \
  --api=gcp-http-api --api-config=gcp-http-api-config \
  --location=us-central1
```

Describe gateway

```
gcloud api-gateway gateways describe gcp-http-api-gateway \
  --location=us-central1 
```

Get URL to access function:

```
https://gcp-http-api-gateway-7vbvujrw.uc.gateway.dev/hello
```

To update create a new config and then update gateway:

```
gcloud api-gateway api-configs create gcp-http-api-config-v2 \
  --api=gcp-http-api --openapi-spec=openapi-functions.yaml 

gcloud api-gateway gateways update gcp-http-api-gateway --api=gcp-http-api --api-config=gcp-http-api-config-v2 --location=us-central1 
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

## Create NEG

https://cloud.google.com/api-gateway/docs/gateway-serverless-neg

```
gcloud beta compute network-endpoint-groups create gcp-http-api-neg \
  --region=us-central1 \
  --network-endpoint-type=serverless \
  --serverless-deployment-platform=apigateway.googleapis.com \
  --serverless-deployment-resource=gcp-http-api-gateway
```

## Create Backend Service

```
gcloud compute backend-services create gcp-http-api-backend-service --global
```

Link NEG

```
gcloud compute backend-services add-backend gcp-http-api-backend-service \
  --global \
  --network-endpoint-group=gcp-http-api-neg  \
  --network-endpoint-group-region=us-central1
```

## Create URL Map

```
gcloud compute url-maps create gcp-http-api-map \
  --default-service gcp-http-api-backend-service
```

## Create HTTPs proxy

```
gcloud compute target-https-proxies create gcp-http-api-proxy \
  --ssl-certificates=gcp-http-api \
  --url-map=gcp-http-api-map
```

## Create Forwarding Rule

```
gcloud compute forwarding-rules create gcp-http-api-forwarding \
  --target-https-proxy=gcp-http-api-proxy \
  --global \
  --ports=443
```

Get IP Address

```
gcloud compute forwarding-rules list
```
---

Not verified stuff:

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
