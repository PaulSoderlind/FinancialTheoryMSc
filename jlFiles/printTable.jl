"""
    printTable([fh::IO],x,colNames=[],rowNames=[],width=10,prec=3,NoPrinting=false,htmlQ=false)

Print formatted row names (1st column) column names (1st row), and data matrix (the rest).

See printmat() for (width,prec)

To do: (a) put inputs into Dict (see TablePs)?; (b) allow for different n-vectors width&prec

"""
function printTable(fh::IO,x,colNames=[],rowNames=[],width=10,prec=3,NoPrinting=false,htmlQ=false)

  (m,n) = (size(x,1),size(x,2))

  if isempty(rowNames)                                 #create row names "r1"
    rowNames = [string("r",i) for i = 1:m]
  end
  if isempty(colNames)                                 #create column names "c1"
    colNames = [string("c",i) for i = 1:n]
  end

  rNamesWidth = maximum([length(rowNames[i]) for i = 1:length(rowNames)])  #max length of rowNames

  if htmlQ                                             #print column names
    cNamesStr = string("<tr><td>",rpad("",rNamesWidth),"</td>")
    for i = 1:n
      cNamesStr = string(cNamesStr,"<th>",lpad(colNames[i],width),"</th>")
    end
    cNamesStr = string(cNamesStr,"</tr>")
  else
    cNamesStr = rpad("",rNamesWidth)                     #"" for cell 0,0
    for i = 1:n                                          #create string
      cNamesStr = string(cNamesStr,lpad(colNames[i],width))
    end
  end

  xStr  = printmat(fh,x,width,prec,true,htmlQ)   #body of table, one long string
  xStrV = split(xStr,"\n")                       #vector of strings (one per row of x)

  iob = IOBuffer()
  write(iob,cNamesStr,"\n")
  for i = 1:m                           #loop over rows in x, print rowNames[i] and x[i,:]
    if htmlQ
      write(iob,"<tr><td><b>",rpad(rowNames[i],rNamesWidth),"</td></b>",xStrV[i],"</tr> \n")
    else
      write(iob,rpad(rowNames[i],rNamesWidth),xStrV[i],"\n")
    end
  end
  str = String(take!(iob))

  if NoPrinting                              #no printing, just return str
    return str
  else                                       #print, return nothing
    print(fh,str,"\n")
    return nothing
  end

end
                        #when fh is not supplied: printing to screen
printTable(x,colNames=[],rowNames=[],width=10,prec=3,NoPrinting=false,htmlQ=false) =
printTable(stdout::IO,x,colNames,rowNames,width,prec,NoPrinting,htmlQ)
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
"""
    println4Ps([fh::IO],width,prec,z...)

Subsitute for println by formatting of width and precision


# Input
- `fh::IO`:    (optional) file handle. If not supplied, prints to screen
- `z::String`:   string, numbers and arrays to print



Paul.Soderlind@unisg.ch, May 2017

"""
function println4Ps(fh::IO,width,prec,z...)

  for x in z                              #loop over inputs in z...
    if isa(x,Union{String,Date,DateTime,Missing})
      print(fh,lpad(x,width))
    else                                         #other types
      iob = IOBuffer()
      for i = 1:length(x)
        if isa(x[i],AbstractFloat)               #Float
          write(iob,fmtNumPs(x[i],width,prec,"right"))
        else                                     #Integer, etc
          write(iob,lpad(x[i],width))
        end
      end
      print(fh,String(take!(iob)))
    end
  end

  print(fh,"\n")

end
                        #when fh is not supplied: printing to screen
println4Ps(width,prec,z...) = println4Ps(stdout::IO,width,prec,z...)
#------------------------------------------------------------------------------
