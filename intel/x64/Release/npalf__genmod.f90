        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NPALF__genmod
          INTERFACE 
            SUBROUTINE NPALF(INFORM,N,NCLIN,ALFA,ALFMIN,ALFMAX,BIGBND,  &
     &DXNORM,ANORM,ADX,AX,BL,BU,DX,X)
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: INFORM
              INTEGER(KIND=4) :: NCLIN
              REAL(KIND=8) :: ALFA
              REAL(KIND=8) :: ALFMIN
              REAL(KIND=8) :: ALFMAX
              REAL(KIND=8) :: BIGBND
              REAL(KIND=8) :: DXNORM
              REAL(KIND=8) :: ANORM(*)
              REAL(KIND=8) :: ADX(*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(*)
              REAL(KIND=8) :: BU(*)
              REAL(KIND=8) :: DX(N)
              REAL(KIND=8) :: X(N)
            END SUBROUTINE NPALF
          END INTERFACE 
        END MODULE NPALF__genmod
