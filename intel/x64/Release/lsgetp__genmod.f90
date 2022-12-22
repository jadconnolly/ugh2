        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSGETP__genmod
          INTERFACE 
            SUBROUTINE LSGETP(LINOBJ,SINGLR,UNITGZ,UNITQ,N,NCLIN,NFREE, &
     &LDA,LDZY,LDR,NRANK,NUMINF,NRZ,KX,CTP,PNORM,A,AP,RES,HZ,P,GQ,CQ,R, &
     &ZY,WORK)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDZY
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: LINOBJ
              LOGICAL(KIND=4) :: SINGLR
              LOGICAL(KIND=4) :: UNITGZ
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: NUMINF
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: CTP
              REAL(KIND=8) :: PNORM
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: AP(*)
              REAL(KIND=8) :: RES(*)
              REAL(KIND=8) :: HZ(*)
              REAL(KIND=8) :: P(N)
              REAL(KIND=8) :: GQ(N)
              REAL(KIND=8) :: CQ(*)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: ZY(LDZY,*)
              REAL(KIND=8) :: WORK(N)
            END SUBROUTINE LSGETP
          END INTERFACE 
        END MODULE LSGETP__genmod
