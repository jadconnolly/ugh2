        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:16:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE XNPALF__genmod
          INTERFACE 
            SUBROUTINE XNPALF(INFORM,N,NCLIN,ALFA,ALFMIN,ALFMAX,BIGBND, &
     &DXNORM,ANORM,ADX,AX,BL,BU,DSLK,DX,SLK,X)
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
              REAL(KIND=8) :: DSLK(*)
              REAL(KIND=8) :: DX(N)
              REAL(KIND=8) :: SLK(*)
              REAL(KIND=8) :: X(N)
            END SUBROUTINE XNPALF
          END INTERFACE 
        END MODULE XNPALF__genmod
