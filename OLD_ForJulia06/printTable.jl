"""
    printTable([fh::IO],x,colNames,rowNames,width=10,prec=3,NoPrinting=false,htmlQ=false)

Print formatted row names (1st column) column names (1st row), and data matrix (the rest).

See printmat() for (width,prec)

"""
function printTable(fh::IO,x,colNames=[],rowNames=[],width=10,prec=3,NoPrinting=false,htmlQ=false)

  (m,n) = (size(x,1),size(x,2))

  if isempty(rowNames)                                 #row names, vector of strings
    rowNames = [string("r",i) for i = 1:m]
  end
  if isempty(colNames)                                 #column names, vector of strings
    colNames = [string("c",i) for i = 1:n]
  end

  rNamesWidth = maximum([length(rowNames[i]) for i = 1:length(rowNames)])

  if htmlQ
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
  xStrV = split(xStr,"\n")                     #vector of strings (one element per line)

  iob = IOBuffer()
  write(iob,cNamesStr,"\n")
  for i = 1:m
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
    if typeof(x) <: String
      print(fh,x)
    elseif typeof(x) <: Union{Date,DateTime}
      print(fh,rpad(x,width))
    else
      iob = IOBuffer()                     #opening IOBuffer
      for i = 1:length(x)
        eltype_x = eltype(x[i])
        if eltype_x <: Union{AbstractFloat,Missing}
          write(iob,fmtNumPs(x[i],width,prec,"right"))
        elseif eltype_x <: Union{Integer,Missing}
          write(iob,fmtNumPs(x[i],width,0,"right"))
        else
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


#------------------------------------------------------------------------------
"""
    printmatDate([fh::IO],dN,x,DateFmt="yyyy-mm-dd",width=10,prec=3)

Print formatted dates (1st column) and data matrix (remaining colums).

See Dates.format() for the DateFmt and printmat() for (width,prec)

Could perhaps replace this coding by creating Any[] array?

"""
function printmatDate(fh::IO,dN,x,DateFmt="yyyy-mm-dd",width=10,prec=3)

  dNStr = Dates.format.(dN,DateFmt)            #vector of strings
  T     = length(dNStr)

  xStr  = printmat(fh,x,width,prec,true)        #one long string
  xStrV = split(xStr,"\n")                      #vector of strings (one element per line)

  iob = IOBuffer()
  for i = 1:T
    write(iob,dNStr[i],xStrV[i],"\n")
  end
  print(fh,String(take!(iob)),"\n")

end
                        #when fh is not supplied: printing to screen
printmatDate(dN,x,DateFmt="yyyy-mm-dd",width=10,prec=3) = printmatDate(stdout::IO,
             dN,x,DateFmt,width,prec)
#------------------------------------------------------------------------------
