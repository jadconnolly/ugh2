        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMALF__genmod
          INTERFACE 
            SUBROUTINE CMALF(FIRSTV,HITLOW,ISTATE,INFORM,JADD,N,NCTOTL, &
     &NUMINF,ALFA,PALFA,ATPHIT,BIGALF,BIGBND,PNORM,ANORM,AP,AX,BL,BU,   &
     &FEATOL,P,X)
              INTEGER(KIND=4) :: NCTOTL
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: FIRSTV
              LOGICAL(KIND=4) :: HITLOW
              INTEGER(KIND=4) :: ISTATE(NCTOTL)
              INTEGER(KIND=4) :: INFORM
              INTEGER(KIND=4) :: JADD
              INTEGER(KIND=4) :: NUMINF
              REAL(KIND=8) :: ALFA
              REAL(KIND=8) :: PALFA
              REAL(KIND=8) :: ATPHIT
              REAL(KIND=8) :: BIGALF
              REAL(KIND=8) :: BIGBND
              REAL(KIND=8) :: PNORM
              REAL(KIND=8) :: ANORM(*)
              REAL(KIND=8) :: AP(*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(NCTOTL)
              REAL(KIND=8) :: BU(NCTOTL)
              REAL(KIND=8) :: FEATOL(NCTOTL)
              REAL(KIND=8) :: P(N)
              REAL(KIND=8) :: X(N)
            END SUBROUTINE CMALF
          END INTERFACE 
        END MODULE CMALF__genmod
