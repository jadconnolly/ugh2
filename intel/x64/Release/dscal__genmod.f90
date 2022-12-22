        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE DSCAL__genmod
          INTERFACE 
            SUBROUTINE DSCAL(N,ALPHA,X,INCX)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: ALPHA
              REAL(KIND=8) :: X(*)
              INTEGER(KIND=4) :: INCX
            END SUBROUTINE DSCAL
          END INTERFACE 
        END MODULE DSCAL__genmod
