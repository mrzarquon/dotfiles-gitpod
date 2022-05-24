#!/bin/bash

#######
# Get Snyk
# execute this script as ./get_snyk.sh /usr/local/bin snyk-linux
# it will install the snyk-linux binary to /usr/local/bin, checking
# if the binary already exists, it will update it to latest
# assumes running as root (in a container)

if command -v snyk &> /dev/null; then
    exit
fi



if [ -z ${1+x} ]; then 
    echo "run get_snyk.sh /dir/where/to/put/binary/ snyk-linux"
    exit 1
fi

if [ -z ${2+x} ]; then 
    echo "run get_snyk.sh /dir/where/to/put/binary/ snyk-linux"
    exit 1
fi

declare -x BINDIR

BINDIR="/usr/local/bin"

declare -x SNYK_BIN

SNYK_BIN="snyk-linux"


filename=${SNYK_BIN}
executable="${filename%-*}"
platform="${filename##*-}"


declare -x SHA_COMMAND

if [[ "${platform}" == "macos" ]]; then
    SHA_COMMAND="shasum"
else
    SHA_COMMAND="sha256sum"
fi

# check for curl and install it if needed
if ! command -v curl &> /dev/null; then
    apt-get update && apt-get install -y curl ca-certificates
fi

if [[ -x "${BINDIR}/${executable}" ]]; then
    snyk_version=$("${BINDIR}/${executable}" --version | cut -d' ' -f1)
else
    snyk_version="0"
fi

latest_version="$(curl -s -L https://static.snyk.io/cli/latest/version)"

if [[ "${snyk_version##*v}" != "${latest_version##*v}" ]]; then

    declare -x CURRENT_DIR

    CURRENT_DIR=$(pwd) || exit 1

    declare -x TMP_DIR

    TMP_DIR=$(mktemp -d) || exit 1

    cd "${TMP_DIR}" || exit 1

    echo "snyk out of date"
    curl -O -s -L "https://static.snyk.io/cli/latest/${filename}"
    curl -O -s -L "https://static.snyk.io/cli/latest/${filename}.sha256"

    file_sha256="${filename}.sha256"

    if "${SHA_COMMAND}" -c "${file_sha256}"; then
        echo "snyk binary checksum passed, updating"
        mv "${filename}" "${BINDIR}/${executable}"
        chmod +x "${BINDIR}/${executable}"
        current_version=$("${BINDIR}/${executable}" --version | cut -d' ' -f1)
        echo "${BINDIR}/${executable} installed with version: ${current_version}"
    else
        echo "snyk binary checksum failed, not updating"
    fi

    cd "${CURRENT_DIR}" || exit 1

    rm -rf "${TMP_DIR}"

else
    echo "No need to update snyk"
fi