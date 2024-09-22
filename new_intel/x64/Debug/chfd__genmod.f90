        !COMPILER-GENERATED INTERFACE MODULE: Thu Sep 12 17:04:57 2024
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CHFD__genmod
          INTERFACE 
            SUBROUTINE CHFD(N,FDNORM,FX,OBJFUN,BL,BU,GRAD,X,BAD)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: FDNORM
              REAL(KIND=8) :: FX
              EXTERNAL OBJFUN
              REAL(KIND=8) :: BL(N)
              REAL(KIND=8) :: BU(N)
              REAL(KIND=8) :: GRAD(N)
              REAL(KIND=8) :: X(N)
              LOGICAL(KIND=4) :: BAD
            END SUBROUTINE CHFD
          END INTERFACE 
        END MODULE CHFD__genmod
