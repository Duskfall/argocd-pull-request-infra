.SILENT:
.PHONY: vote

help:
	{ grep --extended-regexp '^[a-zA-Z_-]+:.*#[[:space:]].*$$' $(MAKEFILE_LIST) || true; } \
	| awk 'BEGIN { FS = ":.*#[[:space:]]*" } { printf "\033[1;32m%-28s\033[0m%s\n", $$1, $$2 }'

env-create: # 1) create .env file
	./make.sh env-create

terraform-init: # 2) terraform init (upgrade) + validate
	./make.sh terraform-init

infra-create: # 2) terraform create ecr repo + ssh key
	./make.sh infra-create

kind-argocd-create: # 3) setup kind + argocd
	./make.sh kind-argocd-create

secrets-create: # 3) create namespaces + secrets
	./make.sh secrets-create

templates-create: # 3) create files using templates
	./make.sh templates-create

argocd-open: # 3) open argocd (website)
	./make.sh argocd-open

argocd-login: # 3) argocd login (terminal)
	./make.sh argocd-login

master-app-create: # 4) create master application
	./make.sh master-app-create

master-app-destroy: # 4) destroy master application
	./make.sh master-app-destroy

pull-request-appset-create: # 5) create pull request applicationset
	./make.sh pull-request-appset-create

pull-request-appset-destroy: # 5) destroy pull request applicationset
	./make.sh pull-request-appset-destroy

argocd-finalize-ns: # 6) argocd-finalize-ns
	./make.sh argocd-finalize-ns

secrets-destroy: # 6) terraform destroy secrets
	./make.sh secrets-destroy

kind-argocd-destroy: # 6) terraform destroy kind + argocd
	./make.sh kind-argocd-destroy

infra-destroy: # 6) terraform destroy ecr repo + ssh key
	./make.sh infra-destroy

