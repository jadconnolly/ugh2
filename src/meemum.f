c Please do not distribute any part of this source.
 
c Copyright (c) 1987-2020 by James A. D. Connolly, Institute for Mineralogy
c & Petrography, Swiss Federal Insitute of Technology, CH-8092 Zurich,
c SWITZERLAND. All rights reserved.

      program meemm
c----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer i, ier

      logical bulk, bad, readyn

      character amount*6

      double precision num, x(l2+k5), objf

      external readyn

      integer npt,jdv
      logical fulrnk
      double precision cptot,ctotal
      common/ cst78 /cptot(k19),ctotal,jdv(k19),npt,fulrnk

      double precision atwt
      common/ cst45 /atwt(k0) 

      double precision v,tr,pr,r,ps
      common/ cst5  /v(l2),tr,pr,r,ps

      integer ipot,jv,iv
      common / cst24 /ipot,jv(l2),iv(l2)

      character*5 cname
      common/ csta4 /cname(k5)

      integer is
      double precision a,b,c
      common/ cst313 /a(k5,k1),b(k5),c(k1),is(k1+k5)

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp

      integer io3,io4,io9
      common / cst41 /io3,io4,io9

      double precision goodc, badc
      common/ cst20 /goodc(3),badc(3)

      integer icont
      double precision dblk,cx
      common/ cst314 /dblk(3,k5),cx(2),icont

      integer iam
      common/ cst4 /iam
c----------------------------------------------------------------------- 
c                                 iam is a flag indicating the Perple_X program
      iam = 2
c                                 initialization, read files etc.
      call iniprp

      bulk = .false.

      if (icont.eq.1) then 
c                                 prompt for bulk composition if compostional variables
c                                 are not explicit
         write (*,1000)
c                                 bulk is true, user enters composition and p-t conditions

         if (readyn())  bulk = .true.

      end if
c                                 iwt is set by input, it is only used below to determine
c                                 whether to convert weight compositions to molar. the 
c                                 computations are done solely in molar units. 
      amount = 'molar '

      if (iwt.eq.1) amount = 'weight'

c     if (lopt(28)) open (666,file='times.txt')
c                                 MC test
      if (lopt(28)) then 
c                                 read phase compositions
         call mccomp

         write (*,*) mphase

         do i = 1, ipot+mphase-1
            x(i) = 0.5
         end do

         call mcobjf (x,objf)
c https://people.sc.fsu.edu/~jburkardt/f77_src/asa047/asa047.html
      end if
c                                 computational loop
      do 
c                                 read potential variable values    
c                                 v(1) is P(bar), v(2) is T(K) the pointer jv used 
c                                 for general problems but can be eliminated for calculations 
c                                 simply as a f(P,T)       
         write (*,1070) (vname(jv(i)), i = 1, ipot)
         read (*,*,iostat=ier) (v(jv(i)), i = 1, ipot)
         if (ier.ne.0) cycle
         if (v(jv(1)).eq.0d0) exit 
          
         if (bulk) then 
c                                 load the composition into b, the component names are  
c                                 in cname, if iwt = 1 the composition is in mass fractions
c                                 otherwise in molar units. 
            do 
               write (*,1060) amount
               write (*,'(12(a,1x))') (cname(i),i=1,jbulk)
               read (*,*,iostat=ier) (cblk(i),i=1,jbulk)
               if (ier.eq.0) exit
            end do  
         
            if (iwt.eq.1) then 
c                                 convert mass to molar 
               do i = 1, jbulk
                  cblk(i) = cblk(i)/atwt(i)
               end do 

            end if

         else if (icont.gt.1) then 
c                                 files set up for bulk compositional variables
            do i = 2, icont
               write (*,1010) i-1
               read (*,*) cx(i-1)
            end do

            call setblk

         end if 
c                                 meemum does the minimization
         call meemum (bad)

         if (.not.bad) then
c                                 calpr0 outputs the results to console 
c                                 and, if requested, the print file (n3)
            call calpr0 (6)

            if (io3.eq.0) call calpr0 (n3)

         end if 

         if (goodc(1)+badc(1).gt.0d0) then

            num = badc(1)/(badc(1)+goodc(1))*1d2
            if (num.gt.1d-1) call warn (53,num,i,'MEEMUM')

         end if 

      end do

1000  format (/,'Interactively enter bulk compositions (y/n)?',/,
     *          'If you answer no, MEEMUM uses the bulk composition',
     *         ' specified in the input file.',/)
1010  format (/,'Enter value of bulk compositional variable X(C',i1,'):'
     *       )
1060  format (/,'Enter ',a,' amounts of the components:')
1070  format (/,'Enter (zeroes to quit) ',7(a,1x))

      end 

      subroutine mccomp
c-----------------------------------------------------------------------
c a subprogram to read auxilliary input file for MC thermobarometry
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer j, ier

      character c

      double precision atwt
      common/ cst45 /atwt(k0)

      character tname*10
      logical refine, lresub
      common/ cxt26 /refine,lresub,tname
c-----------------------------------------------------------------------
c                                 look for phase compositions in
c                                 my_project.imc
      call mertxt (tfname,prject,'.imc',0)
      open (n8,file=tfname,status='old',iostat=ier)

      if (ier.ne.0) call errdbg 
     *   ('can''t open assemblage composition file: '//tfname)

      mphase = 0

      do

         read (n8,'(a)',iostat=ier) tname
c                                 presumed EOF
         if (ier.ne.0) exit
c                                 filter out comments
         read (tname,'(a)') c
         if (c.eq.'|') cycle
c                                 got a live one
         mphase = mphase + 1
c                                 check name
         call matchj (tname,pids(mphase))

         if (pids(mphase).eq.0) 
     *      call errdbg ('no such entity as: '//tname)
c                                 all clear
         read (n8,*,iostat=ier) 
     *                        pmode(mphase), (pblk(mphase,j),j=1,kbulk),
     *                        emode(mphase), (eblk(mphase,j),j=1,kbulk)

         if (ier.ne.0) call errdbg ('invalid data format for: '//tname)
c                                 convert to molar if mass units
         if (iwt.eq.1) then 
c                                 convert to molar if mass units
            do j = 1, kbulk
               pblk(mphase,j) = pblk(mphase,j)/atwt(j)
               eblk(mphase,j) = eblk(mphase,j)/atwt(j)
            end do 

         end if

      end do

      if (mphase.lt.2) call errdbg ('input must specify > 1 phase')

      close (n8)

      end

      subroutine mcobjf (x,obj)
c-----------------------------------------------------------------------
c a subprogram to evaluate objective function for MC thermobarometry
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical bad

      integer i

      double precision x(*), obj

      double precision v,tr,pr,r,ps
      common/ cst5  /v(l2),tr,pr,r,ps

      integer ipot,jv,iv
      common / cst24 /ipot,jv(l2),iv(l2)

      double precision vmax,vmin,dv
      common/ cst9  /vmax(l2),vmin(l2),dv(l2)
c-----------------------------------------------------------------------
c                                 convert the scaled potential variables back
c                                 to the normal variables:
      do i = 1, ipot
         v(jv(i)) = vmin(jv(i)) + x(i) * (vmax(jv(i)) - vmin(jv(i)))
      end do
c                                 set the bulk composition
      call setmcb (x)
c                                 do the optimization
c                                 meemum does the minimization and outputs
c                                 the results to the print file.
      call meemum (bad)

      call calpr0 (6)

      end

      subroutine setmcb (x)
c-----------------------------------------------------------------------
c set bulk composition for MC thermobarometry
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      double precision x(*)

      integer i, j, k

      integer npt,jdv
      logical fulrnk
      double precision cptot,ctotal
      common/ cst78 /cptot(k19),ctotal,jdv(k19),npt,fulrnk

      integer is
      double precision a,b,c
      common/ cst313 /a(k5,k1),b(k5),c(k1),is(k1+k5)

      integer hcp,idv
      common/ cst52  /hcp,idv(k7)

      integer ipot,jv,iv
      common / cst24 /ipot,jv(l2),iv(l2)
c-----------------------------------------------------------------------
      cblk(1:kbulk) = 0d0
      ctotal = 0d0 

      do i = 1, mphase

         k = ipot + i

         if (i.lt.mphase) then 
            ctotal = ctotal + x(k)
         else
            x(k) = 1d0 - ctotal
         end if

         do j = 1, kbulk
            cblk(j) = cblk(j) + x(k)*pblk(i,j)
         end do

      end do
c                                 modify cblk here to change the 
c                                 composition before minimization.
      ctotal = 0d0
c                                 get total moles to compute mole fractions 
      do i = 1, hcp
         ctotal = ctotal + cblk(i)
      end do

      do i = 1, hcp 
         b(i) = cblk(i)/ctotal
      end do

      end