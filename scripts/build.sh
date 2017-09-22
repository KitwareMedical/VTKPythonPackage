# Prove that the environment is ready to go
cmake --version
python --version
pip --version

pip install --upgrade pip setuptools wheel
pip install -r requirements-dev.txt

python setup.py bdist_wheel
