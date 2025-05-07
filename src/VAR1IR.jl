"""
    VAR1IR(A,T,B=1.0)

Calculate the impulse response function of a VAR(1) system. Gives n x k x T output


# Input
- `A::Matrix`:    nxn, VAR(1) matrix in x(t) = A*x(t-1) + e(t)
- `T::Matrix`:    scalar, last period to calculate for
- `B::Matrix`:    (optional) n x k matrix, such that e(t) = B*u(t), where u(t) is kx1.
-                 u(t) could, for instance, be structural shocks

# Output
- `C::3DArray`:   n x k x T, 3-dimensional matrix with VMA

"""
function VAR1IR(A,T,B=1.0)

  n = size(A,1)
  isa(B,Number) && (B = Diagonal(fill(B,n)))  #diagonal matrix filled with B along main diagonal
  k  = size(B,2)

  C        = fill(NaN,n,k,T)     #to put results in
  C[:,:,1] = B                   #period 1 (same as shock)
  for t in 2:T                     #periods 2,3,...,T
    C[:,:,t] = A*C[:,:,t-1]
  end

  return C

end
##------------------------------------------------------------------------------


##------------------------------------------------------------------------------

"""
    MACovPs(C,Omega)

Calculate covariance matrix from a vector MA representation

# Input
- `C::3D Array`:      n x k x q, 3D array, such that MA the representation of ith element is
                      y(i,t) = C[i,:,1]*e(t) + C[i,:,2]*e(t-1) + ..., e(t) is iid
- `Omega::Matrix`:    k x k covariance matrix of iid shocks e(t)

# Output
- `CovM::Matrix`:        n x n covariance matrix, element ij is Cov[y(i,t),y(j,t)]

# Remark
- to turn an nxq matrix into a n x 1 x q 3D array use `reshape(C,n,1,:)`

"""
function MACov(C,Omega)

  (ndims(C) != 3) && error("C should be a 3D matrix")
  (n,k,q) = size(C)

  CovM = zeros(n,n)
  for s in 1:q                      #y(i,t) = C(i,:,1)*e(t) + C(i,:,2)*e(t-1) + ...
    CovM += C[:,:,s]*Omega*C[:,:,s]'
  end

  (n == 1) && (CovM = only(CovM))                 #2D ->Number

  return CovM

end
##------------------------------------------------------------------------------
