        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SUTSQR__genmod
          INTERFACE 
            SUBROUTINE SUTSQR(SIDE,N,K1,K2,C,S,A,LDA)
              INTEGER(KIND=4) :: LDA
              CHARACTER(LEN=1) :: SIDE
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: K1
              INTEGER(KIND=4) :: K2
              REAL(KIND=8) :: C(*)
              REAL(KIND=8) :: S(*)
              REAL(KIND=8) :: A(LDA,*)
            END SUBROUTINE SUTSQR
          END INTERFACE 
        END MODULE SUTSQR__genmod
