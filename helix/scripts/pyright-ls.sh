if [[ $VIRTUAL_ENV ]]; then
  python_path="${VIRTUAL_ENV}/bin/python"
elif [[ $CONDA_PREFIX ]] ; then
  python_path="${CONDA_PREFIX}/bin/python"
else
  python_path="python"
fi

export PYTHONPATH=python_path
