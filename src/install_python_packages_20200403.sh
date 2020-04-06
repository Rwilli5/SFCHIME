#!/bin/bash
# NAME: COVID-19 CHIME MODELS
# AUTHORS: gabrielodom
# SOURCE: local
# DATE CREATED: 2020-04-03

# This script lists the install commands for all python packages we need to run
# the scripts in the src/ directory
# After much pain and suffering, Tim Norris helped me set up my Conda environment.

# For macOS:
conda create --name env_sflCHIME python=3.6 pandas numpy altair
# source activate env_sflCHIME
conda activate env_sflCHIME
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


# Python complains that I don't have a Java Developer's Toolkit (JDK). Install
#   is not trivial, because Oracle hides the link to the .dmg file:
# https://www.oracle.com/java/technologies/javase-jdk14-downloads.html
# Also, read these instructions (DURING install):
# https://docs.oracle.com/en/java/javase/14/install/installation-jdk-macos.html#GUID-F575EB4A-70D3-4AB4-A20E-DBE95171AB5F
