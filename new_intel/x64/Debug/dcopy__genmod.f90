        !COMPILER-GENERATED INTERFACE MODULE: Thu Sep 12 17:04:56 2024
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE DCOPY__genmod
          INTERFACE 
            SUBROUTINE DCOPY(N,X,INCX,Y,INCY)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(*)
              INTEGER(KIND=4) :: INCX
              REAL(KIND=8) :: Y(*)
              INTEGER(KIND=4) :: INCY
            END SUBROUTINE DCOPY
          END INTERFACE 
        END MODULE DCOPY__genmod