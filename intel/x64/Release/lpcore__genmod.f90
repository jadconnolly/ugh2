        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LPCORE__genmod
          INTERFACE 
            SUBROUTINE LPCORE(PRBTYP,MSG,CSET,RSET,UNITQ,ITER,ITMAX,JINF&
     &,NVIOL,N,NCLIN,LDA,NACTIV,NFREE,NRZ,NZ,ISTATE,KACTIV,KX,OBJ,NUMINF&
     &,XNORM,A,AX,BL,BU,CVEC,FEATOL,FEATLU,X,W)
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: N
              CHARACTER(LEN=2) :: PRBTYP
              CHARACTER(LEN=6) :: MSG
              LOGICAL(KIND=4) :: CSET
              LOGICAL(KIND=4) :: RSET
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: ITER
              INTEGER(KIND=4) :: ITMAX
              INTEGER(KIND=4) :: JINF
              INTEGER(KIND=4) :: NVIOL
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: ISTATE(N+NCLIN)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: OBJ
              INTEGER(KIND=4) :: NUMINF
              REAL(KIND=8) :: XNORM
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(N+NCLIN)
              REAL(KIND=8) :: BU(N+NCLIN)
              REAL(KIND=8) :: CVEC(*)
              REAL(KIND=8) :: FEATOL(N+NCLIN)
              REAL(KIND=8) :: FEATLU(N+NCLIN)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: W(*)
            END SUBROUTINE LPCORE
          END INTERFACE 
        END MODULE LPCORE__genmod
