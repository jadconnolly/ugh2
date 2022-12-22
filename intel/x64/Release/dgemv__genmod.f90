        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE DGEMV__genmod
          INTERFACE 
            SUBROUTINE DGEMV(TRANS,M,N,ALPHA,A,LDA,X,BETA,Y)
              INTEGER(KIND=4) :: LDA
              CHARACTER(LEN=1) :: TRANS
              INTEGER(KIND=4) :: M
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: ALPHA
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: X(*)
              REAL(KIND=8) :: BETA
              REAL(KIND=8) :: Y(*)
            END SUBROUTINE DGEMV
          END INTERFACE 
        END MODULE DGEMV__genmod
