        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE XCMPRNT__genmod
          INTERFACE 
            SUBROUTINE XCMPRNT(NFREE,N,NCLIN,NCTOTL,NACTIV,KACTIV,KX,   &
     &CLAMDA,RLAMDA)
              INTEGER(KIND=4) :: NCTOTL
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NCLIN
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: CLAMDA(NCTOTL)
              REAL(KIND=8) :: RLAMDA(N)
            END SUBROUTINE XCMPRNT
          END INTERFACE 
        END MODULE XCMPRNT__genmod
