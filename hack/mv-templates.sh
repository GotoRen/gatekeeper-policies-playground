#!/usr/bin/env bash

policy_path="policies/*"
ignore_dirs=('lib')

dirs=$(find $policy_path -maxdepth 0 -type d)
for dir in $dirs; do
  policy_name="${dir##*/}"
  if [[ ! " ${ignore_dirs[*]} " =~ " ${policy_name} " ]]; then
    mkdir -p gatekeeper/$policy_name/template
    mv policies/$policy_name/template.yaml gatekeeper/$policy_name/template/template.yaml
    cat <<-YAML >gatekeeper/$policy_name/template/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - template.yaml
YAML
  fi
done
