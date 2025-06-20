#!/usr/bin/env bash


## Author: Tommy Miland (@tmiland) - Copyright (c) 2025

######################################################################
####                    Pubchem Compound.sh                       ####
####                                                              ####
####     Script to retrieve compound from the pubchem database    ####
####                                                              ####
####                   Maintained by @tmiland                     ####
######################################################################

VERSION='1.0.0' # Must stay on line 14 for updater to fetch the numbers

#------------------------------------------------------------------------------#
#
# MIT License
#
# Copyright (c) 2025 Tommy Miland
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#------------------------------------------------------------------------------#
## Take 'debug' as argument for debugging purposes
if [[ $* =~ "debug" ]]
then
  set -o errexit
  set -o pipefail
  set -o nounset
  set -o xtrace
fi

curl_cmd() {
  curl -s --retry 3 --retry-all-errors "$1"
}

# Define the compound CID (PubChem Compound ID) from input argument
if echo "$1" | grep -oP '[0-9]+' > /dev/null
then
  COMPOUND_CID="$1"
  # remove trailing whitespace characters
  COMPOUND_CID="${COMPOUND_CID%"${COMPOUND_CID##*[![:space:]]}"}"
else
  COMPOUND_NAME="$1"
  # Replace spaces in name with url encoded %20 (Newer version of curl doesn't accept spaces)
  COMPOUND_NAME="${COMPOUND_NAME// /%20}"

  COMPOUND_NAME_API_URL="https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/${COMPOUND_NAME}/JSON"

  COMPOUND_NAME_RESPONSE=$(curl_cmd "$COMPOUND_NAME_API_URL")

  # Check if the response is valid
  if [[ -z "$COMPOUND_NAME_RESPONSE" ]]
  then
    echo "Error: Failed to fetch cid data from PubChem API."
    exit 1
  fi
  # Check if cid is found
  if echo "$COMPOUND_NAME_RESPONSE" | grep -q "No CID found"
  then
    echo "Error: No CID found that matches the given name."
    exit 1
  fi
  # Define the compound CID (PubChem Compound ID) from API
  COMPOUND_CID=$(echo "$COMPOUND_NAME_RESPONSE" | jq -r '.PC_Compounds[].id.id.cid')
fi
# Fetch compound data from NCBI PubChem API in JSON format
COMPOUND_CID_API_URL="https://pubchem.ncbi.nlm.nih.gov/rest/pug_view/data/compound/${COMPOUND_CID}/JSON"

COMPOUND_CID_RESPONSE=$(curl_cmd "$COMPOUND_CID_API_URL")

# Check if the response is valid
if [[ -z "$COMPOUND_CID_RESPONSE" ]]
then
  echo "Error: Failed to fetch data from PubChem API."
  exit 1
fi

# Parse JSON data using jq
gmol_json() {
  jq -r '.Record.Section[] | select(.TOCHeading == "'"$1"'") | .Section[] | .Section[0] | select(.TOCHeading == "'"$2"'") | try .Information[].Value.StringWithMarkup[].String'
}

formula_json() {
  jq -r '.Record.Section[] | select(.TOCHeading == "'"$1"'") | .Section[] | select(.TOCHeading == "'"$2"'") | try.Information[0].Value.StringWithMarkup[].String'
}

name_id_json() {
  jq -r '.Record.Section[] | select(.TOCHeading == "'"$1"'") | .Section[] | select(.TOCHeading == "'"$2"'") | .Section[] | select(.TOCHeading == "'"$3"'") | try .Information[].Value.StringWithMarkup[].String'
}

phar_bio_json() {
  jq -r '.Record.Section[] | select(.TOCHeading == "'"$1"'") | .Section[] | select(.TOCHeading == "'"$2"'") | try .Information[].Value.StringWithMarkup[].String'
}

url_json() {
  jq -r '.Record.Section[] | select(.TOCHeading == "'"$1"'") | .Section[] | select(.TOCHeading == "'"$2"'") | try .Information[].Value.StringWithMarkup[].Markup[0].URL'
}

info_json() {
  jq -r '.Record.Section[] | select(.TOCHeading == "'"$1"'") | .Section[] | select(.TOCHeading == "'"$2"'") | try .Information[0].Value.StringWithMarkup[].String'
}

# Output JSON data
COMPOUND_NAME=$(echo "$COMPOUND_CID_RESPONSE" | jq -r '.Record.RecordTitle')

MOLECULAR_WEIGHT=$(echo "$COMPOUND_CID_RESPONSE" | gmol_json "Chemical and Physical Properties" "Molecular Weight")

MOLECULAR_FORMULA=$(echo "$COMPOUND_CID_RESPONSE" | formula_json "Names and Identifiers" "Molecular Formula")

SMILES=$(echo "$COMPOUND_CID_RESPONSE" | name_id_json "Names and Identifiers" "Computed Descriptors" "SMILES")

DESCRIPTION=$(echo "$COMPOUND_CID_RESPONSE" | phar_bio_json "Pharmacology and Biochemistry" "Pharmacodynamics")

INFORMATION=$(echo "$COMPOUND_CID_RESPONSE" | info_json "Drug and Medication Information" "Drug Indication")

URL=$(echo "$COMPOUND_CID_RESPONSE" | url_json "Pharmacology and Biochemistry" "Pharmacodynamics")


# Output csv format if second argument is "csv"
if [[ ${2} == "csv" ]]
then
  echo "Name,CID,Molecular Weight,Molecular Formula,SMILES,Description,Information,Link"
  echo "$COMPOUND_NAME,$COMPOUND_CID,$MOLECULAR_WEIGHT,$MOLECULAR_FORMULA,$SMILES,$DESCRIPTION,$INFORMATION,$URL"
else
  # Display the extracted information
  printf 'Name: %s\n\n' "$COMPOUND_NAME"

  printf 'CID: %s\n\n' "$COMPOUND_CID"

  printf 'Molecular Weight: %s\n\n' "$MOLECULAR_WEIGHT"
  if [ -n "$MOLECULAR_FORMULA" ]
  then
    printf 'Molecular Formula: %s\n\n' "$MOLECULAR_FORMULA"
  fi
  if [ -n "$SMILES" ]
  then
    printf 'SMILES: %s\n\n' "$SMILES"
  fi
  if [ -n "$DESCRIPTION" ]
  then
    printf 'Description: %s\n\n' "$DESCRIPTION"
  fi
  if [ -n "$INFORMATION" ]
  then
    printf 'Information: %s\n\n' "$INFORMATION"
  fi
  if [ -n "$URL" ]
  then
    printf 'Link: %s\n' "$URL"
  fi
fi

exit
