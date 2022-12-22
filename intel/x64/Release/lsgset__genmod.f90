        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSGSET__genmod
          INTERFACE 
            SUBROUTINE LSGSET(PRBTYP,LINOBJ,SINGLR,UNITGZ,UNITQ,N,NCLIN,&
     &NFREE,LDA,LDZY,LDR,NRANK,NZ,NRZ,ISTATE,KX,BIGBND,TOLRNK,NUMINF,   &
     &SUMINF,BL,BU,A,RES,FEATOL,GQ,CQ,R,X,WTINF,ZY,WRK)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDZY
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              CHARACTER(LEN=2) :: PRBTYP
              LOGICAL(KIND=4) :: LINOBJ
              LOGICAL(KIND=4) :: SINGLR
              LOGICAL(KIND=4) :: UNITGZ
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: ISTATE(*)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: BIGBND
              REAL(KIND=8) :: TOLRNK
              INTEGER(KIND=4) :: NUMINF
              REAL(KIND=8) :: SUMINF
              REAL(KIND=8) :: BL(*)
              REAL(KIND=8) :: BU(*)
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: RES(*)
              REAL(KIND=8) :: FEATOL(*)
              REAL(KIND=8) :: GQ(N)
              REAL(KIND=8) :: CQ(*)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: WTINF(*)
              REAL(KIND=8) :: ZY(LDZY,*)
              REAL(KIND=8) :: WRK(N)
            END SUBROUTINE LSGSET
          END INTERFACE 
        END MODULE LSGSET__genmod
