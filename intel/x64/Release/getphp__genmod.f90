        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:01 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE GETPHP__genmod
          INTERFACE 
            SUBROUTINE GETPHP(ID,JD,SICK,SSICK,PPOIS,BULKG,BSICK)
              INTEGER(KIND=4) :: ID
              INTEGER(KIND=4) :: JD
              LOGICAL(KIND=4) :: SICK(28)
              LOGICAL(KIND=4) :: SSICK
              LOGICAL(KIND=4) :: PPOIS
              LOGICAL(KIND=4) :: BULKG
              LOGICAL(KIND=4) :: BSICK
            END SUBROUTINE GETPHP
          END INTERFACE 
        END MODULE GETPHP__genmod
