        !COMPILER-GENERATED INTERFACE MODULE: Thu Sep 12 17:04:56 2024
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMSINF__genmod
          INTERFACE 
            SUBROUTINE CMSINF(N,NCLIN,LDA,ISTATE,BIGBND,NUMINF,SUMINF,BL&
     &,BU,A,FEATOL,CVEC,X,WTINF)
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: ISTATE(*)
              REAL(KIND=8) :: BIGBND
              INTEGER(KIND=4) :: NUMINF
              REAL(KIND=8) :: SUMINF
              REAL(KIND=8) :: BL(*)
              REAL(KIND=8) :: BU(*)
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: FEATOL(*)
              REAL(KIND=8) :: CVEC(N)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: WTINF(*)
            END SUBROUTINE CMSINF
          END INTERFACE 
        END MODULE CMSINF__genmod
