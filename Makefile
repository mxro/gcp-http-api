MAKEFLAGS += -j2

.PHONY: deploy
deploy: deploy-hellov2

.PHONY: deploy-hello
deploy-hello:
	gcloud functions deploy HelloHTTP --runtime=go119 --trigger-http --source=functions/hello --allow-unauthenticated gcloud functions deploy hello-http --gen2 --runtime=go119 --source=functions/hello  --entry-point=hello-http --region=us-central1 --trigger-http --allow-unauthenticated 	