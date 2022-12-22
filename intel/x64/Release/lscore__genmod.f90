        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSCORE__genmod
          INTERFACE 
            SUBROUTINE LSCORE(PRBTYP,LINOBJ,UNITQ,INFORM,ITER,JINF,NCLIN&
     &,NCTOTL,NACTIV,NFREE,NRANK,NZ,NRZ,N,LDA,LDR,ISTATE,KACTIV,KX,CTX, &
     &SSQ,SSQ1,SUMINF,NUMINF,XNORM,BL,BU,A,CLAMDA,AX,FEATOL,R,X,W)
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NCTOTL
              CHARACTER(LEN=2) :: PRBTYP
              LOGICAL(KIND=4) :: LINOBJ
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: INFORM
              INTEGER(KIND=4) :: ITER
              INTEGER(KIND=4) :: JINF
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NRANK
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: NRZ
              INTEGER(KIND=4) :: ISTATE(NCTOTL)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: CTX
              REAL(KIND=8) :: SSQ
              REAL(KIND=8) :: SSQ1
              REAL(KIND=8) :: SUMINF
              INTEGER(KIND=4) :: NUMINF
              REAL(KIND=8) :: XNORM
              REAL(KIND=8) :: BL(NCTOTL)
              REAL(KIND=8) :: BU(NCTOTL)
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: CLAMDA(NCTOTL)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: FEATOL(NCTOTL)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: W(*)
            END SUBROUTINE LSCORE
          END INTERFACE 
        END MODULE LSCORE__genmod
