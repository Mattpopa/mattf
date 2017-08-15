#!/bin/bash

if [[ `uname` == 'Darwin' ]]; then
#    echo $(security find-generic-password -a dbs_pass -w)
    export TF_VAR_dbs_pass="$(security find-generic-password -a dbs_pass -w)"
    echo $TF_VAR_dbs_pass
#elif [[ `uname` == 'Linux' ]]; then
#    export TF_VAR_dbs_pass="$(dbs_pass)"
fi
