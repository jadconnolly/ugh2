        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:14 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CHFD__genmod
          INTERFACE 
            SUBROUTINE CHFD(MODE,N,FDNORM,OBJF,OBJFUN,BL,BU,GRAD,X,DUMMY&
     &)
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: MODE
              REAL(KIND=8) :: FDNORM
              REAL(KIND=8) :: OBJF
              EXTERNAL OBJFUN
              REAL(KIND=8) :: BL(N)
              REAL(KIND=8) :: BU(N)
              REAL(KIND=8) :: GRAD(N)
              REAL(KIND=8) :: X(N)
              REAL(KIND=8) :: DUMMY(N)
            END SUBROUTINE CHFD
          END INTERFACE 
        END MODULE CHFD__genmod
