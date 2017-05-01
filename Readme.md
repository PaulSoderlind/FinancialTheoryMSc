# Introduction
The .ipynb files are Julia notebooks. They use some data, which you find in the Data folder. The notebooks are meant to be used together with my lecture notes (pdf files). Actually, many of the examples in the lecture notes come from the calculations in these notebooks. 


# Instructions

You use IJulia to edit and run these Julia notebooks. You can either install Julia/IJulia on your local computer (see https://sites.google.com/site/paulsoderlindecon/home/software for instructions) or you can use JuliaBox.com. The rest of these instructions are for the JuliaBox.com alternative.

1. Log in at JuliaBox.com
2. In the menu, go to Files. Upload the notebook for Chapter 1 as well as the printmat.jl file (it's for printing matrices).
3. In the menu, go to Jupyter and open up the notebook by clicking on it. You can now start working. Using packages (Plots, GR, Roots, Optim) may take some time on the first run. If those packages do not work, follow the instructions below.


## Installing more Packages

To install a package, do as follows:
Open up a notebook (or create a new one). Insert a cell and run the command

>Pkg.add("Roots") 

For the notebooks you need the packages "Plots", "GR", "Roots" and "Optim". You can now close this notebook.

## Working with Files

The Jupyter tab allows you to create folders and delete files. For instance, create a subfolder called Data and then upload your data there.
