        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE RZADDS__genmod
          INTERFACE 
            SUBROUTINE RZADDS(UNITQ,VERTEX,K1,K2,IT,NACTIV,NARTIF,NZ,   &
     &NFREE,NREJTD,NGQ,N,LDQ,LDA,LDT,ISTATE,KACTIV,KX,CONDMX,A,T,GQM,Q,W&
     &,C,S)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: LDQ
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: UNITQ
              LOGICAL(KIND=4) :: VERTEX
              INTEGER(KIND=4) :: K1
              INTEGER(KIND=4) :: K2
              INTEGER(KIND=4) :: IT
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NARTIF
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NREJTD
              INTEGER(KIND=4) :: NGQ
              INTEGER(KIND=4) :: ISTATE(*)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: CONDMX
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: GQM(N,*)
              REAL(KIND=8) :: Q(LDQ,*)
              REAL(KIND=8) :: W(N)
              REAL(KIND=8) :: C(N)
              REAL(KIND=8) :: S(N)
            END SUBROUTINE RZADDS
          END INTERFACE 
        END MODULE RZADDS__genmod
