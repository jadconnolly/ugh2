        !COMPILER-GENERATED INTERFACE MODULE: Thu Dec 22 14:00:01 2022
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE GETLOC__genmod
          INTERFACE 
            SUBROUTINE GETLOC(ITRI,JTRI,IJPT,WT,NODATA)
              INTEGER(KIND=4) :: ITRI(4)
              INTEGER(KIND=4) :: JTRI(4)
              INTEGER(KIND=4) :: IJPT
              REAL(KIND=8) :: WT(3)
              LOGICAL(KIND=4) :: NODATA
            END SUBROUTINE GETLOC
          END INTERFACE 
        END MODULE GETLOC__genmod
