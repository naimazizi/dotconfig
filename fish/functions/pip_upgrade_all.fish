function pip_upgrade_all
    python -m uv pip install --upgrade $(pip freeze | awk -F '==' '{print $1}' | awk -F ' @' '{print $1}')
end