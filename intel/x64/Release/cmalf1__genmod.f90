        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMALF1__genmod
          INTERFACE 
            SUBROUTINE CMALF1(FIRSTV,NEGSTP,BIGALF,BIGBND,PNORM,JADD1,  &
     &JADD2,PALFA1,PALFA2,ISTATE,N,NCTOTL,ANORM,AP,AX,BL,BU,FEATOL,P,X)
              INTEGER(KIND=4) :: NCTOTL
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: FIRSTV
              LOGICAL(KIND=4) :: NEGSTP
              REAL(KIND=8) :: BIGALF
              REAL(KIND=8) :: BIGBND
              REAL(KIND=8) :: PNORM
              INTEGER(KIND=4) :: JADD1
              INTEGER(KIND=4) :: JADD2
              REAL(KIND=8) :: PALFA1
              REAL(KIND=8) :: PALFA2
              INTEGER(KIND=4) :: ISTATE(NCTOTL)
              REAL(KIND=8) :: ANORM(*)
              REAL(KIND=8) :: AP(*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(NCTOTL)
              REAL(KIND=8) :: BU(NCTOTL)
              REAL(KIND=8) :: FEATOL(NCTOTL)
              REAL(KIND=8) :: P(N)
              REAL(KIND=8) :: X(N)
            END SUBROUTINE CMALF1
          END INTERFACE 
        END MODULE CMALF1__genmod
