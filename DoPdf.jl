using JSON, PaulSFnModule

#file for creating pdfs from the notebooks



files = filter(x -> endswith(lowercase(x),".ipynb"), readdir())  #all .ipynb files
filter!(x -> !endswith(lowercase(x),"_xx.ipynb"),files)
printmat(1:length(files),files)
##------------------------------------------------------------------------------

#=                                                   #run sum, Append to for others
NoExecFiles =
[ "Tutorial_03b_DataContainers.ipynb",
  "Tutorial_26a_Py_C_Call.ipynb",
  "Tutorial_26b_RCall.ipynb",
  "Tutorial_28_Modules_Projects.ipynb" ]

for file in NoExecFiles                   #do NoExecFiles
  file_o = AppendNotebookPs(file)
  sleep(0.5)
  run(`quarto render $file_o --to pdf`)
end

files = files[26:end]
ExecFiles = filter(s -> !in(s,NoExecFiles),files)
for file in ExecFiles
  printstyled("converting $file\n",color=:blue)
  QuartoToPdfPs(file;executeQ=true)
  printstyled("--------------------------------\n",color=:blue)
end
=#
##------------------------------------------------------------------------------

for file in files                  #Append to all
  file_o = AppendNotebookPs(file)
  sleep(0.5)
  run(`quarto render $file_o --to pdf`)
end

FileTypes = lowercase.([".pdf",".tex","_xx.ipynb"])
OutDir = "ToPdf"
MoveFilesPs(FileTypes,OutDir)
##------------------------------------------------------------------------------
