        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SGEQRP__genmod
          INTERFACE 
            SUBROUTINE SGEQRP(PIVOT,M,N,A,LDA,ZETA,PERM,WORK)
              INTEGER(KIND=4) :: LDA
              CHARACTER(LEN=1) :: PIVOT
              INTEGER(KIND=4) :: M
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: ZETA(*)
              INTEGER(KIND=4) :: PERM(*)
              REAL(KIND=8) :: WORK(*)
            END SUBROUTINE SGEQRP
          END INTERFACE 
        END MODULE SGEQRP__genmod
