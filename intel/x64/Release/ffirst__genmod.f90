        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:15 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE FFIRST__genmod
          INTERFACE 
            RECURSIVE SUBROUTINE FFIRST(A,IND,LEFT,RIGHT,K,N,DUMSUB)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: A(N)
              INTEGER(KIND=4) :: IND(N)
              INTEGER(KIND=4) :: LEFT
              INTEGER(KIND=4) :: RIGHT
              INTEGER(KIND=4) :: K
              EXTERNAL DUMSUB
            END SUBROUTINE FFIRST
          END INTERFACE 
        END MODULE FFIRST__genmod
