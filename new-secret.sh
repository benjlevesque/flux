#!/bin/bash
echo "Enter the secret name";
read NAME

echo "Enter the secret value";
read -s VALUE

mkdir -p secrets


SECRET=$(kubectl create secret generic $NAME --dry-run --from-literal=$NAME="$VALUE" -o json)
echo $SECRET | kubeseal --format yaml  > secrets/$NAME.yaml

yq d -i secrets/$NAME.yaml metadata.creationTimestamp 
yq d -i secrets/$NAME.yaml spec.template.metadata.creationTimestamp 
yq d -i secrets/$NAME.yaml status 

#rm secret.yaml