#!/bin/bash

. ./setEnv.sh
. "${SUIF_CACHE_HOME}/01.scripts/commonFunctions.sh"
. "${SUIF_CACHE_HOME}/01.scripts/installation/setupFunctions.sh"

if [ ! -f "${SDCCREDENTIALS_SECUREFILEPATH}" ]; then
  echo "Secure file path not present: ${SDCCREDENTIALS_SECUREFILEPATH}"
  exit 1
fi

logI "Sourcing secure information..."
. "${SDCCREDENTIALS_SECUREFILEPATH}"

if [ -z ${SUIF_EMPOWER_USER+x} ]; then
  echo "Secure information has not been sourced correctly: SUIF_EMPOWER_USER is missing!"
  exit 2
fi

logI "Creating work folder and assuring shared folders (${MY_binDir})"
mkdir -p "${MY_binDir}" "$MY_sd/sessions/$MY_crtDay"


mkdir -p \
  "$SUIF_PRODUCT_IMAGES_OUTPUT_DIRECTORY" \
  "$SUIF_PRODUCT_IMAGES_SHARED_DIRECTORY" \
  "$SUIF_FIX_IMAGES_OUTPUT_DIRECTORY" \
  "$SUIF_FIX_IMAGES_SHARED_DIRECTORY"


# Params:
# $1 - Template ID
processTemplate(){
  logI "Processing template ${template}..."

  local lProductsSharedDir="${SUIF_PRODUCT_IMAGES_SHARED_DIRECTORY}/${1}"
  local lProductsSharedImageFile="${lProductsSharedDir}/products.zip"

  if [ -f "${lProductsSharedImageFile}" ]; then
    logI "Products image for template ${1} already exists, nothing to do."
  else
    # Parameters
    # $1 -> setup template
    # $2 -> OPTIONAL - installer binary location, default /tmp/installer.bin
    # $3 -> OPTIONAL - output folder, default /tmp/images/product
    # $4 -> OPTIONAL - platform string, default LNXAMD64
    # NOTE: default URLs for download are fit for Europe. Use the ones without "-hq" for Americas
    # NOTE: pass SDC credentials in env variables SUIF_EMPOWER_USER and SUIF_EMPOWER_PASSWORD
    # NOTE: /dev/shm/productsImagesList.txt may be created upfront if image caches are available
    generateProductsImageFromTemplate \
      "${template}" \
      "${SUIF_INSTALL_INSTALLER_BIN}" \
      "${SUIF_PRODUCT_IMAGES_OUTPUT_DIRECTORY}" \
      "${SUIF_PRODUCT_IMAGES_PLATFORM}"
    
    logI "Uploading products file to share"
    mkdir -p "${lProductsSharedDir}"
    cp -r "${SUIF_PRODUCT_IMAGES_OUTPUT_DIRECTORY}/${1}/"* "${lProductsSharedDir}/"
    logI "Uploaded products file to share"
  fi

  local lFixesSharedDir="${SUIF_FIX_IMAGES_SHARED_DIRECTORY}/${1}/${SUIF_FIXES_DATE_TAG}"
  local lFixesSharedImageFile="${lFixesSharedDir}/fixes.zip"
  if [ -f "${lFixesSharedImageFile}" ]; then
    logI "Fixes image for template ${1} and tag ${SUIF_FIXES_DATE_TAG} already exists, nothing to do."
  else
    # TODO: generalize
    # Parameters
    # $1 -> setup template
    # $2 -> OPTIONAL - output folder, default /tmp/images/product
    # $3 -> OPTIONAL - fixes tag. Defaulted to current day
    # $4 -> OPTIONAL - platform string, default LNXAMD64
    # $5 -> OPTIONAL - sum home, default /tmp/sumv11
    # $6 -> OPTIONAL - sum-bootstrap binary location, default /tmp/sum-bootstrap.bin
    # NOTE: pass SDC credentials in env variables SUIF_EMPOWER_USER and SUIF_EMPOWER_PASSWORD
    generateFixesImageFromTemplate "${template}" \
      "${SUIF_FIX_IMAGES_OUTPUT_DIRECTORY}" \
      "${SUIF_FIXES_DATE_TAG}" \
      "${SUIF_PRODUCT_IMAGES_PLATFORM}" \
      "${SUIF_SUM_HOME}"
    
    logI "Uploading fixes file to share"
    local lFixesDir="${SUIF_FIX_IMAGES_OUTPUT_DIRECTORY}/${1}/${SUIF_FIXES_DATE_TAG}"
    mkdir -p "${lFixesSharedDir}"
    cp -r "${lFixesDir}/"* "${lFixesSharedDir}/"
    logI "Uploaded fixes file to share"
  fi


  logI "Template $template processed."
}

for template in $MY_templates; do
  processTemplate "${template}"
done
