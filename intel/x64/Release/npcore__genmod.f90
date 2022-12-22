        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NPCORE__genmod
          INTERFACE 
            SUBROUTINE NPCORE(UNITQ,INFORM,MAJITS,N,NCLIN,NCTOTL,NACTIV,&
     &NFREE,NZ,LDAQP,LDR,NFUN,NGRAD,ISTATE,KACTIV,KX,OBJF,FDNORM,XNORM, &
     &OBJFUN,AQP,AX,BL,BU,C,CLAMDA,FEATOL,GRAD,GRADU,R,X,IW,W,LENW)
              INTEGER(KIND=4) :: LENW
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDAQP
              INTEGER(KIND=4) :: NCTOTL
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: INFORM
              INTEGER(KIND=4) :: MAJITS
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NFUN
              INTEGER(KIND=4) :: NGRAD
              INTEGER(KIND=4) :: ISTATE(*)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: OBJF
              REAL(KIND=8) :: FDNORM
              REAL(KIND=8) :: XNORM
              EXTERNAL OBJFUN
              REAL(KIND=8) :: AQP(LDAQP,*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(NCTOTL)
              REAL(KIND=8) :: BU(NCTOTL)
              REAL(KIND=8) :: C(*)
              REAL(KIND=8) :: CLAMDA(NCTOTL)
              REAL(KIND=8) :: FEATOL(NCTOTL)
              REAL(KIND=8) :: GRAD(N)
              REAL(KIND=8) :: GRADU(N)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: X(N)
              INTEGER(KIND=4) :: IW(*)
              REAL(KIND=8) :: W(LENW)
            END SUBROUTINE NPCORE
          END INTERFACE 
        END MODULE NPCORE__genmod
