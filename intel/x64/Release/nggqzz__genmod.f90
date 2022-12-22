        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NGGQZZ__genmod
          INTERFACE 
            SUBROUTINE NGGQZZ(HESS,N,K1,K2,C,S,A,LDA)
              INTEGER(KIND=4) :: LDA
              CHARACTER(LEN=1) :: HESS
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: K1
              INTEGER(KIND=4) :: K2
              REAL(KIND=8) :: C(*)
              REAL(KIND=8) :: S(*)
              REAL(KIND=8) :: A(LDA,*)
            END SUBROUTINE NGGQZZ
          END INTERFACE 
        END MODULE NGGQZZ__genmod
