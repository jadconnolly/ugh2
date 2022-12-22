        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMFEAS__genmod
          INTERFACE 
            SUBROUTINE CMFEAS(N,NCLIN,ISTATE,BIGBND,NVIOL,JMAX,ERRMAX,AX&
     &,BL,BU,FEATOL,X)
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: ISTATE(N+NCLIN)
              REAL(KIND=8) :: BIGBND
              INTEGER(KIND=4) :: NVIOL
              INTEGER(KIND=4) :: JMAX
              REAL(KIND=8) :: ERRMAX
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(N+NCLIN)
              REAL(KIND=8) :: BU(N+NCLIN)
              REAL(KIND=8) :: FEATOL(N+NCLIN)
              REAL(KIND=8) :: X(N)
            END SUBROUTINE CMFEAS
          END INTERFACE 
        END MODULE CMFEAS__genmod
