        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LPSOL__genmod
          INTERFACE 
            SUBROUTINE LPSOL(N,NCLIN,A,LDA,BL,BU,CVEC,ISTATE,X,ITER,OBJ,&
     &AX,CLAMDA,IW,LENIW,W,LENW,IFAIL,ISTART,TOL,LPPROB)
              INTEGER(KIND=4) :: LENW
              INTEGER(KIND=4) :: LENIW
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: BL(N+NCLIN)
              REAL(KIND=8) :: BU(N+NCLIN)
              REAL(KIND=8) :: CVEC(*)
              INTEGER(KIND=4) :: ISTATE(N+NCLIN)
              REAL(KIND=8) :: X(N)
              INTEGER(KIND=4) :: ITER
              REAL(KIND=8) :: OBJ
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: CLAMDA(N+NCLIN)
              INTEGER(KIND=4) :: IW(LENIW)
              REAL(KIND=8) :: W(LENW)
              INTEGER(KIND=4) :: IFAIL
              INTEGER(KIND=4) :: ISTART
              REAL(KIND=8) :: TOL
              INTEGER(KIND=4) :: LPPROB
            END SUBROUTINE LPSOL
          END INTERFACE 
        END MODULE LPSOL__genmod
