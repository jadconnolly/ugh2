        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSFEAS__genmod
          INTERFACE 
            SUBROUTINE LSFEAS(N,NCLIN,ISTATE,BIGBND,CVNORM,ERRMAX,JMAX, &
     &NVIOL,AX,BL,BU,FEATOL,X,WORK)
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
              REAL(KIND=8) :: FEATOL(N+NCLIN)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: WORK(N+NCLIN)
            END SUBROUTINE LSFEAS
          END INTERFACE 
        END MODULE LSFEAS__genmod
