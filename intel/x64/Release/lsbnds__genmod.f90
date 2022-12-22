        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSBNDS__genmod
          INTERFACE 
            SUBROUTINE LSBNDS(UNITQ,INFORM,NZ,NFREE,NRANK,NRES,NGQ,N,   &
     &LDZY,LDA,LDR,LDT,ISTATE,KX,CONDMX,A,R,T,RES,GQ,ZY,W,C,S)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: LDZY
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: INFORM
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: NRES
              INTEGER(KIND=4) :: NGQ
              INTEGER(KIND=4) :: ISTATE(*)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: CONDMX
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: RES(N,*)
              REAL(KIND=8) :: GQ(N,*)
              REAL(KIND=8) :: ZY(LDZY,*)
              REAL(KIND=8) :: W(N)
              REAL(KIND=8) :: C(N)
              REAL(KIND=8) :: S(N)
            END SUBROUTINE LSBNDS
          END INTERFACE 
        END MODULE LSBNDS__genmod
