# Test Running the CHIME Python Scripts in R via reticulate::
# Gabriel Odom
# 2020-04-03

# We have python scripts in src/. The scripts are a subset of the app scripts 
#   from https://github.com/CodeForPhilly/chime/tree/develop/src/penn_chime

library(reticulate)

###  Install Python Packages  ###
reticulate::py_install("datetime")
reticulate::py_install("collections")
reticulate::py_install("typing")
reticulate::py_install("abc")


###  Source Python Scripts  ###
reticulate::source_python("src/constants.py")
# Because we have to define objects and classes for OOP, these must be sourced
#   in a particular order.
reticulate::source_python("src/validators/base.py")
# reticulate::import_from_path(".base", path = "src/validators/base.py")
reticulate::source_python("src/validators/validators.py")
# In order for the above code to work, I needed theo __init__.py file in the
#   validators/ directory (see https://realpython.com/absolute-vs-relative-python-imports/)
#   and also to remove the "." from in front of "base" because this code doesn't
#   currently live in a python package (see https://stackoverflow.com/a/52756937/8366590)

reticulate::source_python("src/parameters.py")
