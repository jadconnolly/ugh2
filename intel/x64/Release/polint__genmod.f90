        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 13:59:55 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE POLINT__genmod
          INTERFACE 
            SUBROUTINE POLINT(H,S,K,X,SS,DSS)
              INTEGER(KIND=4) :: K
              REAL(KIND=8) :: H(K)
              REAL(KIND=8) :: S(K)
              REAL(KIND=8) :: X
              REAL(KIND=8) :: SS
              REAL(KIND=8) :: DSS
            END SUBROUTINE POLINT
          END INTERFACE 
        END MODULE POLINT__genmod
