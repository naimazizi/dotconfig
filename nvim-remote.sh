#!/bin/bash
current_path=$(pwd)
exec ssh projects.devpod -- cd "$current_path" ";" nvim "$@"
