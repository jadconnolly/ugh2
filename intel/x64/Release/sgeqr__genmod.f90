        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SGEQR__genmod
          INTERFACE 
            SUBROUTINE SGEQR(M,N,A,LDA,ZETA)
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: M
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: ZETA(*)
            END SUBROUTINE SGEQR
          END INTERFACE 
        END MODULE SGEQR__genmod
