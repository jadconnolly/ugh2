        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SMLOAD__genmod
          INTERFACE 
            SUBROUTINE SMLOAD(MATRIX,M,N,CONST,DIAG,A,LDA)
              INTEGER(KIND=4) :: LDA
              CHARACTER(LEN=1) :: MATRIX
              INTEGER(KIND=4) :: M
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: CONST
              REAL(KIND=8) :: DIAG
              REAL(KIND=8) :: A(LDA,*)
            END SUBROUTINE SMLOAD
          END INTERFACE 
        END MODULE SMLOAD__genmod
