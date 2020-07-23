#!/bin/bash
#
# Version: v0.1.1
# Author: Sabatarou <sinkuma135@gmail.com>
# LastUpdate: 07/22/2020 01:17
#
#set -eu

readonly DATETIME="$(date +%Y%m%d_%H%M%S)"
readonly HOST_LIST="host.list"
readonly LOG_DIR="log"
readonly MANAGE_SUMMERY="ping-test"
readonly LOG_NAME="${MANAGE_SUMMERY}"_"${DATETIME}".log
# PINGタイムアウトまでの実行回数とPINGのタイムアウトまでの待ち時間
readonly TIMEOUT=1
readonly COUNT=30

# リストファイルの存在確認
if [[ -e "${HOST_LIST}"  ]]; then
    :
else
    echo "ERROR: ${HOST_LIST} does not exists. please set your host list."

    exit 1
fi


# ログディレクトリの作成
if [[ -e "${LOG_DIR}" ]]; then
    :
else
    mkdir -m 755 ./"${LOG_DIR}"
fi

# PINGヘッダの記載
echo "Abstract:       ${MANAGE_SUMMERY}">> "${LOG_DIR}"/"${LOG_NAME}"
echo "Timeout, Count: ${TIMEOUT}, ${COUNT}">> "${LOG_DIR}"/"${LOG_NAME}"
echo "SourceIP: ">> "${LOG_DIR}"/"${LOG_NAME}"
ifconfig>> "${LOG_DIR}"/"${LOG_NAME}"


# 全ホストの数(行数)の確認
function count_hosts(){
    local _host_count=0

    while read _hosts
    do
        _host_count=$((_host_count+1))
    done <"${HOST_LIST}"
    
    host_total="${_host_count}"

    return 0
}

# PING実行
function ping_test(){
    local _host_count=1

    echo -e "PING test start.\n"

    while read _hosts
    do
        echo -e "----------------------------------------\n">> "${LOG_DIR}"/"${LOG_NAME}"
        echo "PING start time: ${DATETIME}">> "${LOG_DIR}"/"${LOG_NAME}"
        echo "Execute PING -> ${_hosts}...(${_host_count}/${host_total})"
        ping -w "${TIMEOUT}" -t "${COUNT}" "${_hosts}" \
        >> "${LOG_DIR}"/"${LOG_NAME}"
        echo "PING end time: ${DATETIME}">> "${LOG_DIR}"/"${LOG_NAME}"

        _host_count=$((_host_count+1))
    done <"${HOST_LIST}"
    echo -e "\n----------------------------------------">> "${LOG_DIR}"/"${LOG_NAME}"

    echo -e "\nPING test end.\n"
    echo "Test result saved to ${PWD}/${LOG_DIR}/${LOG_NAME}."
    return 0
}

# main関数実行
function main(){
    count_hosts
    ping_test

    return 0
}

main
