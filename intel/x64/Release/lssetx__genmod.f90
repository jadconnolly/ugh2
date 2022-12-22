        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSSETX__genmod
          INTERFACE 
            SUBROUTINE LSSETX(LINOBJ,ROWERR,UNITQ,NCLIN,NACTIV,NFREE,   &
     &NRANK,NZ,N,NCTOTL,LDZY,LDA,LDR,LDT,ISTATE,KACTIV,KX,JMAX,ERRMAX,  &
     &CTX,XNORM,A,AX,BL,BU,CQ,RES,RES0,FEATOL,R,T,X,ZY,P,WORK)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: LDZY
              INTEGER(KIND=4) :: NCTOTL
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: LINOBJ
              LOGICAL(KIND=4) :: ROWERR
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: ISTATE(NCTOTL)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              INTEGER(KIND=4) :: JMAX
              REAL(KIND=8) :: ERRMAX
              REAL(KIND=8) :: CTX
              REAL(KIND=8) :: XNORM
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(NCTOTL)
              REAL(KIND=8) :: BU(NCTOTL)
              REAL(KIND=8) :: CQ(*)
              REAL(KIND=8) :: RES(*)
              REAL(KIND=8) :: RES0(*)
              REAL(KIND=8) :: FEATOL(NCTOTL)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: ZY(LDZY,*)
              REAL(KIND=8) :: P(N)
              REAL(KIND=8) :: WORK(NCTOTL)
            END SUBROUTINE LSSETX
          END INTERFACE 
        END MODULE LSSETX__genmod
