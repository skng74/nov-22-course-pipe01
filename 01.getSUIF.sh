#!/bin/bash

. ./setEnv.sh

echo "Environment dump before SUIF download"
env | sort

mkdir -p "${SUIF_CACHE_HOME}/01.scripts" "${SUIF_AUDIT_BASE_DIR}"

echo "Getting file ${SUIF_HOME_URL}/01.scripts/commonFunctions.sh"

curl "${SUIF_HOME_URL}/01.scripts/commonFunctions.sh"  --silent -o "${SUIF_CACHE_HOME}/01.scripts/commonFunctions.sh"

RESULT_curl=$?
if [ ${RESULT_curl} -ne 0 ]; then
  echo "Cannot get SUIF commons: curl of URL ${SUIF_HOME_URL}/01.scripts/commonFunctions.sh failed, code ${RESULT_curl}"
  exit 1
fi

. "${SUIF_CACHE_HOME}/01.scripts/commonFunctions.sh"

huntForSuifFile "01.scripts/installation" "setupFunctions.sh" || exit 2

if [ ! -f "${SUIF_CACHE_HOME}/01.scripts/installation/setupFunctions.sh" ]; then
  logE "Error downloading file ${SUIF_CACHE_HOME}/01.scripts/installation/setupFunctions.sh"
  ls -l "${SUIF_CACHE_HOME}/01.scripts/"
  ls -l "${SUIF_CACHE_HOME}/01.scripts/installation"
  exit 3
fi

chmod u+x "${SUIF_CACHE_HOME}/01.scripts/installation/setupFunctions.sh"

huntForSuifFile "01.scripts/pwsh" "generateInventoryFileFromInstallScript.ps1" || exit 4
