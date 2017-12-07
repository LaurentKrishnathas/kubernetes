#!/usr/bin/env bash
# @author Laurent Krishnathas

set -e
set -u
set -x


function hello_script(){
    echo "hello" $1

}

$*