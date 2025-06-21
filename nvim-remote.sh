#!/bin/bash
current_path=$(pwd)
exec ssh -F ~/.lima/lima-box/ssh.config lima-lima-box -- cd $current_path ";" nvim "$@"
