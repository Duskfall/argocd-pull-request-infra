#!/bin/bash

log() { echo -e "\e[30;47m ${1} \e[0m ${@:2}"; }          # $1 background white
info() { echo -e "\e[48;5;28m ${1} \e[0m ${@:2}"; }       # $1 background green
warn() { echo -e "\e[48;5;202m ${1} \e[0m ${@:2}" >&2; }  # $1 background orange
error() { echo -e "\e[48;5;196m ${1} \e[0m ${@:2}" >&2; } # $1 background red

# the directory containing the script file
export PROJECT_DIR="$(cd "$(dirname "$0")"; pwd)"

#
# variables
#
[[ -f $PROJECT_DIR/.env ]] &&
    source $PROJECT_DIR/.env ||
    warn WARN .env file is missing

#
# overwrite TF variables
#
export TF_VAR_project_dir=$PROJECT_DIR
export TF_VAR_project_name=$PROJECT_NAME
export TF_VAR_app_name=$APP_NAME
export TF_VAR_aws_region=$AWS_REGION
export TF_VAR_ecr_repository_name=$PROJECT_NAME-$APP_NAME
export TF_VAR_github_owner=$GITHUB_OWNER
export TF_VAR_github_token=$GITHUB_TOKEN
export TF_VAR_github_repo_url_infra=$GITHUB_REPO_URL_INFRA
export TF_VAR_github_repo_url_vote=$GITHUB_REPO_URL_VOTE
export TF_VAR_github_repo_name_infra=$GITHUB_REPO_NAME_INFRA
export TF_VAR_github_repo_name_vote=$GITHUB_REPO_NAME_VOTE
export TF_VAR_aws_access_key_id=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_access_key=$AWS_SECRET_ACCESS_KEY

# log $1 in underline then $@ then a newline
under() {
    local arg=$1
    shift
    echo -e "\033[0;4m${arg}\033[0m ${@}"
    echo
}

usage() {
    under usage 'call the Makefile directly: make dev
      or invoke this file directly: ./make.sh dev'
}

env-create() {
    local AWS_PROFILE=default

    # root account id
    AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
        --query 'Account' \
        --profile $AWS_PROFILE \
        --output text)
    log AWS_ACCOUNT_ID $AWS_ACCOUNT_ID

    # setup .env file with default values
    scripts/env-file.sh .env \
        AWS_PROFILE=$AWS_PROFILE \
        AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID \
        PROJECT_NAME=pull-request \
        APP_NAME=vote \
        GITHUB_REPO_NAME_INFRA=argocd-pull-request-infra \
        GITHUB_REPO_NAME_VOTE=argocd-pull-request-vote

    # setup .env file again
    # /!\ use your own values
    scripts/env-file.sh .env \
        AWS_REGION=eu-west-3 \
        GITHUB_OWNER=jeromedecoster \
        GITHUB_REPO_URL_INFRA=git@github.com:jeromedecoster/argocd-pull-request-infra.git \
        GITHUB_REPO_URL_VOTE=git@github.com:jeromedecoster/argocd-pull-request-vote.git \
        GITHUB_TOKEN=
}

# terraform init (upgrade) + validate
terraform-init() {
    CHDIR="$PROJECT_DIR/terraform/infra" scripts/terraform-init.sh
    CHDIR="$PROJECT_DIR/terraform/kind-argocd" scripts/terraform-init.sh
    CHDIR="$PROJECT_DIR/terraform/secrets" scripts/terraform-init.sh
    CHDIR="$PROJECT_DIR/terraform/templates" scripts/terraform-init.sh
}

# terraform create ecr repo + ssh key
infra-create() {
    CHDIR="$PROJECT_DIR/terraform/infra" scripts/terraform-apply.sh
}

# setup kind + argocd
kind-argocd-create() {
    CHDIR="$PROJECT_DIR/terraform/kind-argocd" scripts/terraform-apply.sh
}

# create namespaces + secrets
secrets-create() {
    CHDIR="$PROJECT_DIR/terraform/secrets" scripts/terraform-apply.sh
}

# create files using templates
templates-create() {
    CHDIR="$PROJECT_DIR/terraform/templates" scripts/terraform-apply.sh
}

# open argocd (website)
argocd-open() {
    log ARGOCD_PASSWORD $ARGOCD_PASSWORD
    log KIND_LISTEN_ADDRESS $KIND_LISTEN_ADDRESS
    log KIND_LOCALHOST_PORT $KIND_LOCALHOST_PORT

    # xdg-open https://0.0.0.0:8443
    info OPEN $KIND_LISTEN_ADDRESS:$KIND_LOCALHOST_PORT
    if [[ -n $(which xdg-open) ]]; then
        xdg-open https://$KIND_LISTEN_ADDRESS:$KIND_LOCALHOST_PORT
    elif [[ -n $(which open) ]]; then
        open https://$KIND_LISTEN_ADDRESS:$KIND_LOCALHOST_PORT
    fi

    warn ACCEPT insecure self-signed certificate
    info LOGIN admin
    info PASSWORD $ARGOCD_PASSWORD
}

# argocd login (terminal)
argocd-login() {
    log ARGOCD_PASSWORD $ARGOCD_PASSWORD
    log KIND_LISTEN_ADDRESS $KIND_LISTEN_ADDRESS
    log KIND_LOCALHOST_PORT $KIND_LOCALHOST_PORT

    # must match kind_config.node[role = "control-plane"].extra_port_mappings[container_port = 30080]
    argocd login $KIND_LISTEN_ADDRESS:$KIND_LOCALHOST_PORT \
        --insecure \
        --username=admin \
        --password=$ARGOCD_PASSWORD
}


master-app-create() {
    kubectl apply -f "$PROJECT_DIR/argocd/vote-master.yaml"
}

master-app-destroy() {
    kubectl delete -f "$PROJECT_DIR/argocd/vote-master.yaml"
}

pull-request-appset-create() {
    kubectl apply -f "$PROJECT_DIR/argocd/vote-pull-request.yaml"
}

pull-request-appset-destroy() {
    kubectl apply -f "$PROJECT_DIR/argocd/vote-pull-request.yaml"
}

argocd-finalize-ns() {
    # https://stackoverflow.com/a/53661717/1503073
    TEMP_DIR=$(mktemp --directory /tmp/argocd-XXXX)
    info TEMP_DIR $TEMP_DIR

    kubectl proxy &

    cd  $TEMP_DIR
    # get ns data as JSON, clear .spec.finalizers content, write as JSON file
    kubectl get namespace argocd -o json | jq '.spec = { "finalizers":[] }' > ns.json
    # finalize namespace
    curl -k -H "Content-Type: application/json" -X PUT --data-binary @ns.json 127.0.0.1:8001/api/v1/namespaces/argocd/finalize

    # https://stackoverflow.com/a/61264131/1503073
    # option -f, --full : the pattern is normally only matched against the process name.
    pkill -9 -f "kubectl proxy"
}

infra-destroy() {
    terraform -chdir=$PROJECT_DIR/terraform/infra destroy -auto-approve
}

kind-argocd-destroy() {
    terraform -chdir=$PROJECT_DIR/terraform/kind-argocd destroy -auto-approve
}

secrets-destroy() {
  terraform -chdir=$PROJECT_DIR/terraform/secrets destroy -auto-approve
}

# if `$1` is a function, execute it. Otherwise, print usage
# compgen -A 'function' list all declared functions
# https://stackoverflow.com/a/2627461
FUNC=$(compgen -A 'function' | grep $1)
[[ -n $FUNC ]] &&
    { info EXECUTE $1; eval $1; } || 
    usage
exit 0
