        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE DDOT__genmod
          INTERFACE 
            FUNCTION DDOT(N,X,INCX,Y)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(*)
              INTEGER(KIND=4) :: INCX
              REAL(KIND=8) :: Y(*)
              REAL(KIND=8) :: DDOT
            END FUNCTION DDOT
          END INTERFACE 
        END MODULE DDOT__genmod
