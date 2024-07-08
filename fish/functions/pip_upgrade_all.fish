function pip_upgrade_all
    uv pip install --upgrade $(pip freeze | awk -F '==' '{print $1}' | awk -F ' @' '{print $1}')
end