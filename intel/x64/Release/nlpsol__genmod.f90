        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NLPSOL__genmod
          INTERFACE 
            SUBROUTINE NLPSOL(N,NCLIN,LDA,LDR,A,BL,BU,OBJFUN,ITER,ISTATE&
     &,CLAMDA,OBJF,GRADU,R,X,IW,LENIW,W,LENW)
              INTEGER(KIND=4) :: LENW
              INTEGER(KIND=4) :: LENIW
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: BL(N+NCLIN)
              REAL(KIND=8) :: BU(N+NCLIN)
              EXTERNAL OBJFUN
              INTEGER(KIND=4) :: ITER
              INTEGER(KIND=4) :: ISTATE(N+NCLIN)
              REAL(KIND=8) :: CLAMDA(N+NCLIN)
              REAL(KIND=8) :: OBJF
              REAL(KIND=8) :: GRADU(N)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: X(N)
              INTEGER(KIND=4) :: IW(LENIW)
              REAL(KIND=8) :: W(LENW)
            END SUBROUTINE NLPSOL
          END INTERFACE 
        END MODULE NLPSOL__genmod
