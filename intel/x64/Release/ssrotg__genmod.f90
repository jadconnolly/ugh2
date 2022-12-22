        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SSROTG__genmod
          INTERFACE 
            SUBROUTINE SSROTG(PIVOT,DIRECT,N,ALPHA,X,INCX,C,S)
              CHARACTER(LEN=1) :: PIVOT
              CHARACTER(LEN=1) :: DIRECT
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: ALPHA
              REAL(KIND=8) :: X(*)
              INTEGER(KIND=4) :: INCX
              REAL(KIND=8) :: C(*)
              REAL(KIND=8) :: S(*)
            END SUBROUTINE SSROTG
          END INTERFACE 
        END MODULE SSROTG__genmod
