        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SGESRC__genmod
          INTERFACE 
            SUBROUTINE SGESRC(SIDE,PIVOT,DIRECT,M,N,K1,K2,C,S,A,LDA)
              INTEGER(KIND=4) :: LDA
              CHARACTER(LEN=1) :: SIDE
              CHARACTER(LEN=1) :: PIVOT
              CHARACTER(LEN=1) :: DIRECT
              INTEGER(KIND=4) :: M
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: K1
              INTEGER(KIND=4) :: K2
              REAL(KIND=8) :: C(*)
              REAL(KIND=8) :: S(*)
              REAL(KIND=8) :: A(LDA,*)
            END SUBROUTINE SGESRC
          END INTERFACE 
        END MODULE SGESRC__genmod
