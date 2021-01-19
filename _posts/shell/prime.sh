#!/bin/bash

function Usage() {
    echo "Usage $0 start_num end_num"
    exit
}

function is_prime() {
    num=$1
    for (( j=2; j<${num}; j++ )); do
        if [[ $[ ${num} % $j ] -eq 0 ]]; then
            return 1
        fi
    done
    return 0
}

if [[ $# -ne 2 ]];then
    echo "Error"
    Usage
fi

Start=$1
End=$2

for ((i=${Start}; i<=${End}; i++)); do
    is_prime $i
    if [[ $? -eq 0 ]]; then
        echo $i
    fi
done
