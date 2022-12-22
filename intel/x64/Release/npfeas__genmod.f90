        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NPFEAS__genmod
          INTERFACE 
            SUBROUTINE NPFEAS(N,NCLIN,ISTATE,BIGBND,CVNORM,ERRMAX,JMAX, &
     &NVIOL,AX,BL,BU,C,FEATOL,X,WORK)
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: ISTATE(N+NCLIN)
              REAL(KIND=8) :: BIGBND
              REAL(KIND=8) :: CVNORM
              REAL(KIND=8) :: ERRMAX
              INTEGER(KIND=4) :: JMAX
              INTEGER(KIND=4) :: NVIOL
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(N+NCLIN)
              REAL(KIND=8) :: BU(N+NCLIN)
              REAL(KIND=8) :: C(*)
              REAL(KIND=8) :: FEATOL(N+NCLIN)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: WORK(N+NCLIN)
            END SUBROUTINE NPFEAS
          END INTERFACE 
        END MODULE NPFEAS__genmod
