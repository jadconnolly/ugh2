        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NGGNFM__genmod
          INTERFACE 
            SUBROUTINE NGGNFM(SIDE,N,K1,K2,S,A,LDA)
              INTEGER(KIND=4) :: LDA
              CHARACTER(LEN=1) :: SIDE
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: K1
              INTEGER(KIND=4) :: K2
              REAL(KIND=8) :: S(*)
              REAL(KIND=8) :: A(LDA,*)
            END SUBROUTINE NGGNFM
          END INTERFACE 
        END MODULE NGGNFM__genmod
