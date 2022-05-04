#!/bin/bash

install_github_release(){

    path="${1}"

    repo="${path%/*}"

    filename="${path##*/}"

    file_sha256="${filename}.sha256"

    executable="${filename%-*}"

    platform="${filename##*-}"

    url="https://github.com/${repo}/${executable}"

    echo "${executable} is out of date, installing new version"
    echo "installing ${executable} from ${url}"

    jq_line='.assets[] | select (.browser_download_url | contains ("'
    jq_line+="${platform}"
    jq_line+='")) | .browser_download_url'

    curl -s "https://api.github.com/repos/${repo}/${executable}/releases/latest" \
    | jq -c "${jq_line}" \
    | xargs -I release_url curl -H "Authorization: $GITHUB_TOKEN" -s -L -O release_url

    tar xf ${executable}*

    chmod +x ${executable}
    sudo mv ${executable} /usr/local/bin/${executable}

}

install_github_release "errata-ai/vale-Linux"