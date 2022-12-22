        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:15 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE PARTIT__genmod
          INTERFACE 
            FUNCTION PARTIT(A,IND,LEFT,RIGHT,OPIVOT,N)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: A(N)
              INTEGER(KIND=4) :: IND(N)
              INTEGER(KIND=4) :: LEFT
              INTEGER(KIND=4) :: RIGHT
              INTEGER(KIND=4) :: OPIVOT
              INTEGER(KIND=4) :: PARTIT
            END FUNCTION PARTIT
          END INTERFACE 
        END MODULE PARTIT__genmod
