#!/bin/bash

## Developed by: Daniel Joven
## Version: 0.0.1


set -e

## Getting the variables from the Docker env file
ENV_FILE='docker/local/.env'
test -r ${ENV_FILE} || exit 1
. ${ENV_FILE}


####
## Functions
####

function api_request() {
  ## Do the API request to SonarQube

  local endpoint=${1}
  local method=${2}
  local data=${3}

  ## The default password is changed at the beginning, so it is neccesary to manage that casuistry
  if [[ -n ${4} ]]
  then
    local password=${SONARQUBE_PASSWORD_DEFAULT}
  else
    local password=${SONARQUBE_PASSWORD}
  fi

  RESPONSE=$(curl \
    -s \
    -u "${SONARQUBE_USER}:${password}" \
    -X ${method} \
    "http://localhost:${SONARQUBE_EXTERNAL_PORT}/api/${endpoint}?${data}" \
    | jq
  )

  ## This is neccesary to avoid an early exit
  if [[ ${endpoint} == 'system/health' ]]; then
    echo $RESPONSE
  elif [[ ${RESPONSE} == *"errors"* ]]; then
    exit 1
  elif [[ ${endpoint} == 'user_tokens/generate' ]]; then
    echo $RESPONSE | jq -r '.token'
  elif [[ ${endpoint} == *"show" ]]; then
    echo $RESPONSE | jq -r '.conditions[] | select(.metric == "new_duplicated_lines_density") | .id'
  fi
}


function get_sonarqube_status() {
  ## Check if SonarQube is running

  echo -e "\nCheck if SonarQube is running..."

  for i in {1..12}
  do
    RESPONSE=$(api_request \
      'system/health' \
      'GET' \
      'null' \
      | jq
    )

    if [[ ${RESPONSE} == *"errors"* ]]
    then
      echo "Still unavailable... ${i}/12"
      sleep 15
    else
      break
    fi
  done

  echo "Check if SonarQube is running... OK"
}


function update_admin_password() {
  ## Update the password of the default SonarQube user

  echo -e "\nUpdate the password of the default SonarQube user..."

  api_request \
    'users/change_password' \
    'GET' \
    "login=${SONARQUBE_USER}&previousPassword=${SONARQUBE_PASSWORD_DEFAULT}&password=${SONARQUBE_PASSWORD}" \
    "${SONARQUBE_PASSWORD_DEFAULT}"

  ## No response is given

  echo "Update the password of the default SonarQube user... OK"
}


function new_token() {
  ## Generate a token for the default SonarQube user

  echo -e "\nGenerate a token for the default SonarQube user..."

  RESPONSE=$(api_request \
    'user_tokens/generate' \
    'POST' \
    "name=${SONARQUBE_PROJECT_TOKEN_NAME}&login=${SONARQUBE_USER}"
  )

  ## Update env file
  sed -i "s/SONARQUBE_PROJECT_TOKEN=.*/SONARQUBE_PROJECT_TOKEN=${RESPONSE}/" ${ENV_FILE}

  echo "Generate a token for the default SonarQube user... OK"
}


function new_project() {
  ## Create the project

  echo -e "\nCreate the project..."

  api_request \
    'projects/create' \
    'POST' \
    "name=${SONARQUBE_PROJECT_KEY}&project=${SONARQUBE_PROJECT_KEY}"

  echo "Create the project... OK"
}


function copy_default_quality_gates() {
  ## Copy the default rules of SonarQube

  echo -e "\nCopy the default rules of SonarQube..."

  api_request \
  'qualitygates/copy' \
  'POST' \
  "name=${SONARQUBE_QUALITY_GATES}&sourceName=${SONARQUBE_QUALITY_GATES_DEFAULT}"

  echo "Copy the default rules of SonarQube... OK"
}


function modify_default_quality_gates() {
  ## Modification in the default quality gates copied

  echo -e "\Modifying the default rules of SonarQube..."

  CONDITION_ID=$(api_request \
  'qualitygates/show' \
  'GET' \
  "name=${SONARQUBE_QUALITY_GATES}")

  api_request \
  'qualitygates/update_condition' \
  'POST' \
  "id=${CONDITION_ID}&metric=new_duplicated_lines_density&op=GT&error=20"
}


function new_quality_gates() {
  ## Create conditions for 'Overall Code'

  echo -e "\nCreate conditions for 'Overall Code'..."

  local CONDITIONS="
  gateName=${SONARQUBE_QUALITY_GATES}&metric=sqale_rating&op=GT&error=1
  gateName=${SONARQUBE_QUALITY_GATES}&metric=security_rating&op=GT&error=1
  gateName=${SONARQUBE_QUALITY_GATES}&metric=security_hotspots_reviewed&op=LT&error=100
  gateName=${SONARQUBE_QUALITY_GATES}&metric=reliability_rating&op=GT&error=1
  gateName=${SONARQUBE_QUALITY_GATES}&metric=coverage&op=LT&error=80
  gateName=${SONARQUBE_QUALITY_GATES}&metric=duplicated_lines_density&op=GT&error=3
  "

  for condition in ${CONDITIONS};
  do
    api_request \
      'GET' \
      'qualitygates/create_condition' \
      ${condition}
  done

  echo "Create conditions for 'Overall Code'... OK"
}


function assign_quality_gates_to_project() {
  ## Assign the project to the custom SonarQube Quality Gates

  echo -e "\nAssign the project to the custom SonarQube Quality Gates..."

  api_request \
    'qualitygates/select' \
    'POST' \
    "gateName=${SONARQUBE_QUALITY_GATES}&projectKey=${SONARQUBE_PROJECT_KEY}"

  ## No response is given

  echo "Assign the project to the custom SonarQube Quality Gates... OK"
}


####
## Calling the functions
####

get_sonarqube_status
update_admin_password
new_token
new_project
copy_default_quality_gates
modify_default_quality_gates
assign_quality_gates_to_project
