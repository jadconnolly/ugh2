        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE ISRANK__genmod
          INTERFACE 
            FUNCTION ISRANK(N,X,INCX,TOL)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(*)
              INTEGER(KIND=4) :: INCX
              REAL(KIND=8) :: TOL
              INTEGER(KIND=4) :: ISRANK
            END FUNCTION ISRANK
          END INTERFACE 
        END MODULE ISRANK__genmod
