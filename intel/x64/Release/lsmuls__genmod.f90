        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSMULS__genmod
          INTERFACE 
            SUBROUTINE LSMULS(N,NACTIV,NFREE,LDA,LDT,NUMINF,NZ,NRZ,     &
     &ISTATE,KACTIV,KX,DINKY,JSMLST,KSMLST,JINF,JTINY,JBIGST,KBIGST,    &
     &TRULAM,A,ANORMS,GQ,RLAMDA,T,WTINF)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NUMINF
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: ISTATE(*)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: DINKY
              INTEGER(KIND=4) :: JSMLST
              INTEGER(KIND=4) :: KSMLST
              INTEGER(KIND=4) :: JINF
              INTEGER(KIND=4) :: JTINY
              INTEGER(KIND=4) :: JBIGST
              INTEGER(KIND=4) :: KBIGST
              REAL(KIND=8) :: TRULAM
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: ANORMS(*)
              REAL(KIND=8) :: GQ(N)
              REAL(KIND=8) :: RLAMDA(N)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: WTINF(*)
            END SUBROUTINE LSMULS
          END INTERFACE 
        END MODULE LSMULS__genmod
