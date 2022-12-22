        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SMCOPY__genmod
          INTERFACE 
            SUBROUTINE SMCOPY(MATRIX,M,N,A,LDA,B,LDB)
              INTEGER(KIND=4) :: LDB
              INTEGER(KIND=4) :: LDA
              CHARACTER(LEN=1) :: MATRIX
              INTEGER(KIND=4) :: M
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: B(LDB,*)
            END SUBROUTINE SMCOPY
          END INTERFACE 
        END MODULE SMCOPY__genmod
