        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSDEL__genmod
          INTERFACE 
            SUBROUTINE LSDEL(UNITQ,N,NACTIV,NFREE,NRES,NGQ,NZ,NRZ,LDA,  &
     &LDZY,LDR,LDT,NRANK,JDEL,KDEL,KACTIV,KX,A,RES,R,T,GQ,ZY,C,S)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDZY
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NRES
              INTEGER(KIND=4) :: NGQ
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: JDEL
              INTEGER(KIND=4) :: KDEL
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: RES(N,*)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: GQ(N,*)
              REAL(KIND=8) :: ZY(LDZY,*)
              REAL(KIND=8) :: C(N)
              REAL(KIND=8) :: S(N)
            END SUBROUTINE LSDEL
          END INTERFACE 
        END MODULE LSDEL__genmod
