        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSMOVE__genmod
          INTERFACE 
            SUBROUTINE LSMOVE(HITCON,HITLOW,LINOBJ,UNITGZ,NCLIN,NRANK,  &
     &NRZ,N,LDR,JADD,NUMINF,ALFA,CTP,CTX,XNORM,AP,AX,BL,BU,GQ,HZ,P,RES,R&
     &,X,WORK)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: HITCON
              LOGICAL(KIND=4) :: HITLOW
              LOGICAL(KIND=4) :: LINOBJ
              LOGICAL(KIND=4) :: UNITGZ
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: JADD
              INTEGER(KIND=4) :: NUMINF
              REAL(KIND=8) :: ALFA
              REAL(KIND=8) :: CTP
              REAL(KIND=8) :: CTX
              REAL(KIND=8) :: XNORM
              REAL(KIND=8) :: AP(*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(*)
              REAL(KIND=8) :: BU(*)
              REAL(KIND=8) :: GQ(*)
              REAL(KIND=8) :: HZ(*)
              REAL(KIND=8) :: P(N)
              REAL(KIND=8) :: RES(*)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: WORK(*)
            END SUBROUTINE LSMOVE
          END INTERFACE 
        END MODULE LSMOVE__genmod
