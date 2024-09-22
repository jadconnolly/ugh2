        !COMPILER-GENERATED INTERFACE MODULE: Thu Sep 12 17:04:56 2024
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMMUL1__genmod
          INTERFACE 
            SUBROUTINE CMMUL1(N,LDA,LDT,NACTIV,NFREE,NZ,ISTATE,KACTIV,KX&
     &,ZEROLM,NOTOPT,NUMINF,TRUSML,SMLLST,JSMLST,KSMLST,TINYST,JTINY,   &
     &JINF,TRUBIG,BIGGST,JBIGST,KBIGST,A,ANORMS,GQ,RLAMDA,T,WTINF)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: ISTATE(*)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: ZEROLM
              INTEGER(KIND=4) :: NOTOPT
              INTEGER(KIND=4) :: NUMINF
              REAL(KIND=8) :: TRUSML
              REAL(KIND=8) :: SMLLST
              INTEGER(KIND=4) :: JSMLST
              INTEGER(KIND=4) :: KSMLST
              REAL(KIND=8) :: TINYST
              INTEGER(KIND=4) :: JTINY
              INTEGER(KIND=4) :: JINF
              REAL(KIND=8) :: TRUBIG
              REAL(KIND=8) :: BIGGST
              INTEGER(KIND=4) :: JBIGST
              INTEGER(KIND=4) :: KBIGST
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: ANORMS(*)
              REAL(KIND=8) :: GQ(N)
              REAL(KIND=8) :: RLAMDA(N)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: WTINF(*)
            END SUBROUTINE CMMUL1
          END INTERFACE 
        END MODULE CMMUL1__genmod
