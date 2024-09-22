        !COMPILER-GENERATED INTERFACE MODULE: Thu Sep 12 17:04:56 2024
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMCRSH__genmod
          INTERFACE 
            SUBROUTINE CMCRSH(ISTART,VERTEX,NCLIN,NCTOTL,NACTIV,NARTIF, &
     &NFREE,N,LDA,ISTATE,KACTIV,KX,BIGBND,TOLACT,A,AX,BL,BU,FEATOL,X,WX,&
     &WORK)
              INTEGER(KIND=4) :: LDA
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NCTOTL
              INTEGER(KIND=4) :: ISTART
              LOGICAL(KIND=4) :: VERTEX
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NARTIF
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: ISTATE(NCTOTL)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: BIGBND
              REAL(KIND=8) :: TOLACT
              REAL(KIND=8) :: A(LDA,*)
              REAL(KIND=8) :: AX(*)
              REAL(KIND=8) :: BL(NCTOTL)
              REAL(KIND=8) :: BU(NCTOTL)
              REAL(KIND=8) :: FEATOL(NCTOTL)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: WX(N)
              REAL(KIND=8) :: WORK(N)
            END SUBROUTINE CMCRSH
          END INTERFACE 
        END MODULE CMCRSH__genmod
