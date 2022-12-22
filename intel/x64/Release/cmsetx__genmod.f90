        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMSETX__genmod
          INTERFACE 
            SUBROUTINE CMSETX(ROWERR,UNITQ,NCLIN,NACTIV,NFREE,NZ,N,LDQ, &
     &LDA,LDT,ISTATE,KACTIV,KX,JMAX,ERRMAX,XNORM,A,AX,BL,BU,FEATOL,T,X,Q&
     &,P,WORK)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: LDQ
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NCLIN
              LOGICAL(KIND=4) :: ROWERR
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: ISTATE(N+NCLIN)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              INTEGER(KIND=4) :: JMAX
              REAL(KIND=8) :: ERRMAX
              REAL(KIND=8) :: XNORM
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(N+NCLIN)
              REAL(KIND=8) :: BU(N+NCLIN)
              REAL(KIND=8) :: FEATOL(N+NCLIN)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: Q(LDQ,*)
              REAL(KIND=8) :: P(N)
              REAL(KIND=8) :: WORK(N)
            END SUBROUTINE CMSETX
          END INTERFACE 
        END MODULE CMSETX__genmod
