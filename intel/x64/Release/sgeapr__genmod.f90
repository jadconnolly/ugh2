        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SGEAPR__genmod
          INTERFACE 
            SUBROUTINE SGEAPR(SIDE,TRANS,N,PERM,K,B,LDB)
              INTEGER(KIND=4) :: LDB
              CHARACTER(LEN=1) :: SIDE
              CHARACTER(LEN=1) :: TRANS
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: PERM(*)
              INTEGER(KIND=4) :: K
              REAL(KIND=8) :: B(LDB,*)
            END SUBROUTINE SGEAPR
          END INTERFACE 
        END MODULE SGEAPR__genmod
