#!/bin/bash


if command -v /usr/bin/shellcheck &> /dev/null; then
    exit
fi

apt install -y shellcheck