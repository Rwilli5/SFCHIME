#!/bin/bash
# NAME: COVID-19 CHIME MODELS
# AUTHORS: gabrielodom
# SOURCE: local
# DATE CREATED: 2020-04-03

# This script lists the install commands for all python packages we need to run
# the scripts in the src/ directory
# After much pain and suffering, Tim Norris helped me set up my Conda environment

conda create --name env_sflCHARM python=3.6 pandas numpy altair
# For macOS
source activate env_sflCHARM
# For Windows:
# conda init powershell
# conda activate env_sflCHARM
pip install streamlit

# pip install datetime
# pip install collections
# # pip install typing
# conda install typing
# pip install abc
# conda install abc
# # conda update -n base conda
# 
# # for Anshul's script
# pip install functools
# # pip install pandas
# conda install pandas
# pip install streamlit
# pip install numpy
# pip install altair
