#!/bin/bash
# NAME: COVID-19 CHIME MODELS
# AUTHORS: gabrielodom
# SOURCE: local
# DATE CREATED: 2020-04-03

# This script lists the install commands for all python packages we need to run
# the scripts in the src/ directory
# After much pain and suffering, Tim Norris helped me set up my Conda environment.

# For macOS:
conda create --name env_sflCHARM python=3.6 pandas numpy altair
source activate env_sflCHARM
pip install streamlit

# For Windows:
# Install Anaconda:
# https://problemsolvingwithpython.com/01-Orientation/01.03-Installing-Anaconda-on-Windows/
# Update your system path (section 3):
# https://appuals.com/fix-conda-is-not-recognized-as-an-internal-or-external-command-operable-program-or-batch-file/

# conda create --name env_sflCHARM python=3.6 pandas numpy altair
# This triggers a permissions error, which I've emailed Angel Ruiz about.

# For Windows:
# conda init powershell
# conda activate env_sflCHARM
# pip install streamlit

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
