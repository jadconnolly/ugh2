        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE RZDEL__genmod
          INTERFACE 
            SUBROUTINE RZDEL(UNITQ,IT,N,NACTIV,NFREE,NGQ,NZ,NRZ,LDA,LDQ,&
     &LDT,JDEL,KDEL,KACTIV,KX,A,T,GQM,Q,C,S)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDQ
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: IT
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NGQ
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: JDEL
              INTEGER(KIND=4) :: KDEL
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: GQM(N,*)
              REAL(KIND=8) :: Q(LDQ,*)
              REAL(KIND=8) :: C(N)
              REAL(KIND=8) :: S(N)
            END SUBROUTINE RZDEL
          END INTERFACE 
        END MODULE RZDEL__genmod
