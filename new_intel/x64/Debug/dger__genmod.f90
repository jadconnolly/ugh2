        !COMPILER-GENERATED INTERFACE MODULE: Thu Sep 12 17:04:56 2024
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE DGER__genmod
          INTERFACE 
            SUBROUTINE DGER(M,N,ALPHA,X,Y,A,LDA)
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: M
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: ALPHA
              REAL(KIND=8) :: X(*)
              REAL(KIND=8) :: Y(*)
              REAL(KIND=8) :: A(LDA,*)
            END SUBROUTINE DGER
          END INTERFACE 
        END MODULE DGER__genmod
