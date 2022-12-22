        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMCHZR__genmod
          INTERFACE 
            SUBROUTINE CMCHZR(FIRSTV,N,NCLIN,ISTATE,BIGALF,BIGBND,PNORM,&
     &HITLOW,MOVE,ONBND,UNBNDD,ALFA,ALFAP,JHIT,ANORM,AP,AX,BL,BU,FEATOL,&
     &FEATLU,P,X)
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: FIRSTV
              INTEGER(KIND=4) :: ISTATE(N+NCLIN)
              REAL(KIND=8) :: BIGALF
              REAL(KIND=8) :: BIGBND
              REAL(KIND=8) :: PNORM
              LOGICAL(KIND=4) :: HITLOW
              LOGICAL(KIND=4) :: MOVE
              LOGICAL(KIND=4) :: ONBND
              LOGICAL(KIND=4) :: UNBNDD
              REAL(KIND=8) :: ALFA
              REAL(KIND=8) :: ALFAP
              INTEGER(KIND=4) :: JHIT
              REAL(KIND=8) :: ANORM(*)
              REAL(KIND=8) :: AP(*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(N+NCLIN)
              REAL(KIND=8) :: BU(N+NCLIN)
              REAL(KIND=8) :: FEATOL(N+NCLIN)
              REAL(KIND=8) :: FEATLU(N+NCLIN)
              REAL(KIND=8) :: P(N)
              REAL(KIND=8) :: X(N)
            END SUBROUTINE CMCHZR
          END INTERFACE 
        END MODULE CMCHZR__genmod
