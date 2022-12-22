        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE RZADD__genmod
          INTERFACE 
            SUBROUTINE RZADD(UNITQ,RSET,INFORM,IFIX,IADD,JADD,IT,NACTIV,&
     &NZ,NFREE,NRZ,NGQ,N,LDA,LDQ,LDR,LDT,KX,CONDMX,DRZZ,A,R,T,GQM,Q,W,C,&
     &S)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDQ
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: UNITQ
              LOGICAL(KIND=4) :: RSET
              INTEGER(KIND=4) :: INFORM
              INTEGER(KIND=4) :: IFIX
              INTEGER(KIND=4) :: IADD
              INTEGER(KIND=4) :: JADD
              INTEGER(KIND=4) :: IT
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: NGQ
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: CONDMX
              REAL(KIND=8) :: DRZZ
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: GQM(N,*)
              REAL(KIND=8) :: Q(LDQ,*)
              REAL(KIND=8) :: W(N)
              REAL(KIND=8) :: C(N)
              REAL(KIND=8) :: S(N)
            END SUBROUTINE RZADD
          END INTERFACE 
        END MODULE RZADD__genmod
