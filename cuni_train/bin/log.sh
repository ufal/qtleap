#!/bin/bash

level=$1

declare -A color=( [INFO]=36 [DEBUG]=35 [WARN]=33 [ERROR]=31 )
code=${color[$level]}

shift

line="[$(date '+%F %T')]\t$level $*"
#if [ -t 2 -a _$code != _ ]; then
if [ _$code != _ ]; then
    echo -e "\e[${code}m${line}\e[0m"
else
    echo -e "$line"
fi >&2
