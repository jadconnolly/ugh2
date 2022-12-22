        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:14 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NPIQP__genmod
          INTERFACE 
            SUBROUTINE NPIQP(FEASQP,UNITQ,NQPERR,MINITS,N,NCLIN,LDAQP,  &
     &LDR,LINACT,NLNACT,NACTIV,NFREE,NZ,NUMINF,ISTATE,KACTIV,KX,DXNORM, &
     &GDX,QPCURV,AQP,ADX,AX,BL,BU,CLAMDA,DX,QPBL,QPBU,QPTOL,R,X,WTINF,W)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDAQP
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: FEASQP
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: NQPERR
              INTEGER(KIND=4) :: MINITS
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: LINACT
              INTEGER(KIND=4) :: NLNACT
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NUMINF
              INTEGER(KIND=4) :: ISTATE(*)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: DXNORM
              REAL(KIND=8) :: GDX
              REAL(KIND=8) :: QPCURV
              REAL(KIND=8) :: AQP(LDAQP,*)
              REAL(KIND=8) :: ADX(*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(*)
              REAL(KIND=8) :: BU(*)
              REAL(KIND=8) :: CLAMDA(*)
              REAL(KIND=8) :: DX(N)
              REAL(KIND=8) :: QPBL(*)
              REAL(KIND=8) :: QPBU(*)
              REAL(KIND=8) :: QPTOL(*)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: WTINF(*)
              REAL(KIND=8) :: W(*)
            END SUBROUTINE NPIQP
          END INTERFACE 
        END MODULE NPIQP__genmod
