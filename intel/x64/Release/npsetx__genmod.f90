        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 16:22:40 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NPSETX__genmod
          INTERFACE 
            SUBROUTINE NPSETX(UNITQ,NCQP,NACTIV,NFREE,NZ,N,NCTOTL,LDZY, &
     &LDAQP,LDR,LDT,ISTATE,KACTIV,KX,DXNORM,GDX,AQP,ADX,BL,BU,RPQ,RPQ0, &
     &DX,GQ,R,T,ZY,WORK)
              INTEGER(KIND=4) :: LDT
              INTEGER(KIND=4) :: LDR
              INTEGER(KIND=4) :: LDAQP
              INTEGER(KIND=4) :: LDZY
              INTEGER(KIND=4) :: NCTOTL
              INTEGER(KIND=4) :: N
              LOGICAL(KIND=4) :: UNITQ
              INTEGER(KIND=4) :: NCQP
              INTEGER(KIND=4) :: NACTIV
              INTEGER(KIND=4) :: NFREE
              INTEGER(KIND=4) :: NZ
              INTEGER(KIND=4) :: ISTATE(NCTOTL)
              INTEGER(KIND=4) :: KACTIV(N)
              INTEGER(KIND=4) :: KX(N)
              REAL(KIND=8) :: DXNORM
              REAL(KIND=8) :: GDX
              REAL(KIND=8) :: AQP(LDAQP,*)
              REAL(KIND=8) :: ADX(*)
              REAL(KIND=8) :: BL(NCTOTL)
              REAL(KIND=8) :: BU(NCTOTL)
              REAL(KIND=8) :: RPQ(N)
              REAL(KIND=8) :: RPQ0(N)
              REAL(KIND=8) :: DX(N)
              REAL(KIND=8) :: GQ(N)
              REAL(KIND=8) :: R(LDR,*)
              REAL(KIND=8) :: T(LDT,*)
              REAL(KIND=8) :: ZY(LDZY,*)
              REAL(KIND=8) :: WORK(N)
            END SUBROUTINE NPSETX
          END INTERFACE 
        END MODULE NPSETX__genmod
