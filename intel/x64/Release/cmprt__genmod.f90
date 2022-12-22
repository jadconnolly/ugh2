        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:04 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CMPRT__genmod
          INTERFACE 
            SUBROUTINE CMPRT(NFREE,N,NCTOTL,NACTIV,KACTIV,KX,CLAMDA,    &
     &RLAMDA)
              INTEGER(KIND=4) :: NCTOTL
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: CLAMDA(NCTOTL)
              REAL(KIND=8) :: RLAMDA(N)
            END SUBROUTINE CMPRT
          END INTERFACE 
        END MODULE CMPRT__genmod
