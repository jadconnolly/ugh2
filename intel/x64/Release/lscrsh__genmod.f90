        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE LSCRSH__genmod
          INTERFACE 
            SUBROUTINE LSCRSH(COLD,VERTEX,NCLIN,NCTOTL,NACTIV,NARTIF,   &
     &NFREE,N,LDA,ISTATE,KACTIV,BIGBND,TOLACT,A,AX,BL,BU,X,WX,WORK)
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NCTOTL
              LOGICAL(KIND=4) :: COLD
              LOGICAL(KIND=4) :: VERTEX
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NARTIF
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: ISTATE(NCTOTL)
              INTEGER(KIND=4) :: KACTIV(N)
              REAL(KIND=8) :: BIGBND
              REAL(KIND=8) :: TOLACT
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(NCTOTL)
              REAL(KIND=8) :: BU(NCTOTL)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: WX(N)
              REAL(KIND=8) :: WORK(N)
            END SUBROUTINE LSCRSH
          END INTERFACE 
        END MODULE LSCRSH__genmod
