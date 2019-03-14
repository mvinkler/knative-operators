#!/bin/sh

# Script to CI-ify https://github.com/openshift-cloud-functions/knative-operators
#
# Usage:
# 1. Fork https://github.com/openshift-cloud-functions/knative-operators  (e.g. as https://github.com/maschmid/knative-operators )
# 2. Clone your fork
# 3. Run this script
# 4. Review the modifications, make sure there are no missed images
# 5. Commit and Push to your fork

set -x

CI_PROMOTION_NAME=${CI_PROMOTION_NAME:-"knative-v0.3"}
KNATIVE_VERSION=${KNATIVE_VERSION:-"0.3.0"}
KNATIVE_CATALOG_VERSION=${KNATIVE_CATALOG_VERSION:-v${KNATIVE_VERSION}}
CI_IMAGE_URL=${CI_IMAGE_URL:-registry.svc.ci.openshift.org/openshift/$CI_PROMOTION_NAME}

GITHUBUSERCONTENT_URL=${GITHUBUSERCONTENT_URL:-"https://raw.githubusercontent.com/mvinkler/knative-operators/$CI_PROMOTION_NAME/"}

sed -i -r "s|gcr.io/knative-releases/github.com/knative/serving/cmd/([a-zA-Z0-9_-]+)@sha256:[a-z0-9]+|$CI_IMAGE_URL:knative-serving-\1|" olm-catalog/knative-serving.${KNATIVE_CATALOG_VERSION}.clusterserviceversion.yaml
sed -i -r "s|https://raw.githubusercontent.com/openshift-cloud-functions/knative-operators/master/|$GITHUBUSERCONTENT_URL|" olm-catalog/knative-serving.${KNATIVE_CATALOG_VERSION}.clusterserviceversion.yaml

sed -i -r "s|gcr.io/knative-releases/github.com/knative/serving/cmd/([a-zA-Z0-9_-]+)@sha256:[a-z0-9]+|$CI_IMAGE_URL:knative-serving-\1|" etc/hacks/knative-serving-$KNATIVE_VERSION.yaml

sed -i -r "s|gcr.io/knative-releases/github.com/knative/eventing/cmd/([a-zA-Z0-9_-]+)@sha256:[a-z0-9]+|$CI_IMAGE_URL:knative-eventing-\1|" olm-catalog/knative-eventing.${KNATIVE_CATALOG_VERSION}.clusterserviceversion.yaml
sed -i -r "s|https://raw.githubusercontent.com/openshift-cloud-functions/knative-operators/master/|$GITHUBUSERCONTENT_URL|" olm-catalog/knative-eventing.${KNATIVE_CATALOG_VERSION}.clusterserviceversion.yaml

sed -i -r "s|gcr.io/knative-releases/github.com/knative/eventing/cmd/([a-zA-Z0-9_-]+)@sha256:[a-z0-9]+|$CI_IMAGE_URL:knative-eventing-\1|" etc/hacks/knative-eventing-$KNATIVE_VERSION.yaml
sed -i -r "s|gcr.io/knative-releases/github.com/knative/eventing-sources/cmd/([a-zA-Z0-9-]+)@sha256:[a-z0-9]+|$CI_IMAGE_URL:knative-eventing-sources-\1|" etc/hacks/knative-eventing-$KNATIVE_VERSION.yaml
sed -i -r "s|gcr.io/knative-releases/github.com/knative/eventing-sources/cmd/([a-zA-Z0-9]+)_receive_adapter@sha256:[a-z0-9]+|$CI_IMAGE_URL:knative-eventing-sources-\1-receive-adapter|" etc/hacks/knative-eventing-$KNATIVE_VERSION.yaml

sed -i -r "s|gcr.io/knative-releases/github.com/knative/eventing/pkg/controller/eventing/inmemory/controller@sha256:[a-z0-9]+|$CI_IMAGE_URL:knative-eventing-in-memory-channel-controller|" olm-catalog/knative-eventing.${KNATIVE_CATALOG_VERSION}.clusterserviceversion.yaml

sed -i -r "s|gcr.io/knative-releases/github.com/knative/build/cmd/([a-zA-Z0-9_-]+)@sha256:[a-z0-9]+|$CI_IMAGE_URL:knative-build-\1|" olm-catalog/knative-build.${KNATIVE_CATALOG_VERSION}.clusterserviceversion.yaml
sed -i -r "s|https://raw.githubusercontent.com/openshift-cloud-functions/knative-operators/master/|$GITHUBUSERCONTENT_URL|" olm-catalog/knative-build.${KNATIVE_CATALOG_VERSION}.clusterserviceversion.yaml
sed -i -r "s|gcr.io/knative-releases/github.com/knative/build/cmd/([a-zA-Z0-9_-]+)@sha256:[a-z0-9]+|$CI_IMAGE_URL:knative-build-\1|" etc/hacks/knative-build-$KNATIVE_VERSION.yaml


sh etc/scripts/catalog.sh > knative-operators.catalogsource.yaml

