        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NPSRCH__genmod
          INTERFACE 
            SUBROUTINE NPSRCH(NEEDFD,INFORM,N,NFUN,NGRAD,OBJFUN,ALFA,   &
     &ALFMAX,ALFSML,DXNORM,EPSRF,ETA,GDX,GRDALF,GLF,OBJF,OBJALF,XNORM,DX&
     &,GRAD,GRADU,X1,X,BL,BU)
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: NEEDFD
              INTEGER(KIND=4) :: INFORM
              INTEGER(KIND=4) :: NFUN
              INTEGER(KIND=4) :: NGRAD
              EXTERNAL OBJFUN
              REAL(KIND=8) :: ALFA
              REAL(KIND=8) :: ALFMAX
              REAL(KIND=8) :: ALFSML
              REAL(KIND=8) :: DXNORM
              REAL(KIND=8) :: EPSRF
              REAL(KIND=8) :: ETA
              REAL(KIND=8) :: GDX
              REAL(KIND=8) :: GRDALF
              REAL(KIND=8) :: GLF
              REAL(KIND=8) :: OBJF
              REAL(KIND=8) :: OBJALF
              REAL(KIND=8) :: XNORM
              REAL(KIND=8) :: DX(N)
              REAL(KIND=8) :: GRAD(N)
              REAL(KIND=8) :: GRADU(N)
              REAL(KIND=8) :: X1(N)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: BL(*)
              REAL(KIND=8) :: BU(*)
            END SUBROUTINE NPSRCH
          END INTERFACE 
        END MODULE NPSRCH__genmod
