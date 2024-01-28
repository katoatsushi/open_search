FIRESTORE_DATABASE_ID:=main
GCP_PROJECT_ID:=alpha-398211

# update env 
.PHONY: update-envied
update-envied:
	dart run build_runner build

# Firestore & CloudStorage Security Rules
.PHONY: deploy-rules
deploy-rules:
	cd firestore && firebase deploy --only firestore:${FIRESTORE_DATABASE_ID} --project ${GCP_PROJECT_ID}
