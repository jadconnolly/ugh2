c Please do not distribute any part of this source.
 
c Copyright (c) 1987-2020 by James A. D. Connolly, Institute for Mineralogy
c & Petrography, Swiss Federal Insitute of Technology, CH-8092 Zurich,
c SWITZERLAND. All rights reserved. 

      program meemm
c----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer i, n, conchk, kcount, icount, ifault, iprint,
     *        iquad, j, igood, ntry, ibest

      logical readyn

      character amount*6

      double precision var(l2+k5), objf, mcobjf, x(l2+k5),
     *                 tol, step(l2+k5), simplx, bstobj

      external readyn, mcobjf, mcobj1

      integer npt,jdv
      double precision cptot,ctotal
      common/ cst78 /cptot(k19),ctotal,jdv(k19),npt

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

      call invxpt
c                                 initialization, read files etc.
      call iniprp
c                                 iwt is set by input, it is only used below to determine
c                                 whether to convert weight compositions to molar. the 
c                                 computations are done solely in molar units. 
      amount = 'molar '

      if (iwt.eq.1) amount = 'weight'
c                                 read phase compositions
         call mccomp

         n = ipot+mphase-1

         x(1:n) = 0.5d0

         tol = 1d-8
         step(1:n) = 5d-1
         conchk = 10
         iprint = -1
         iquad = 1
         ibest = 0
         igood = 0
         bstobj = 1d99
         simplx = 1d-8
         ntry = 100
c                                 max number of objf evaluations
         kcount = 10000
c                                 initialize drand
         call random_seed

1080  format ('Search ',i3,' initial normalized coordinates: ',
     *        5(g12.6,1x))
1090  format (10x,'initial potentials: ',5(g12.6,1x))
1020  format ('Minimization failed IFAULT = ',i3,' igood = ',i3)
1030  format ('Final normalized coordinates: ',5(g12.6,1x))
1040  format ('Final potentials: ',5(g12.6,1x))
1050  format ('Number of function evaluations: ',i5,
     *        ' igood = ',i3,' icount = ',i5)
1100  format (i3,' Successes in ',i4,' tries.')
1110  format ('Best result was search ',i3,' objf =',g12.6)

         do i = 1, ntry

            write (*,1080) i, x(1:n)

            call mcsetv (x)

            write (*,1090) (v(jv(j)),j= 1, ipot)
c                                 MINIM R O'neil
c                                 www.scilab.org/sites/default/files/neldermead.pdf
c                                 code: lib.stat.cmu.edu/apstat/47
            call minim (x, step, n, objf, kcount, iprint, tol, 
     *           conchk, iquad, simplx, var, mcobj1, icount, ifault)

c https://people.sc.fsu.edu/~jburkardt/f77_src/asa047/asa047.html
c           call nelmin (mcobjf, n, xini, xopt, objf, tol, step, conchk,
c    *                kcount, icount, numres, ifault)

            if (ifault.ne.0) then 

               write (*,1020) ifault,igood,icount

            else

               igood = igood + 1

               if (objf.lt.bstobj) then 
                  ibest = i
                  bstobj = objf
               end if

               write (*,1030) x(1:n)
               call mcsetv (x)
               write (*,1040) (v(jv(j)),j= 1, ipot)
               write (*,1050) icount, igood
            end if
c                               new starting point
            do j = 1, n
               call random_number (x(j))
            end do

c           if (i.eq.5) then 
c              x(1:n) = 0.5
c           end if

         end do

         write (*,1100) igood, ntry
         write (*,1110) ibest, bstobj

         pause

1000  format (/,'Interactively enter bulk compositions (y/n)?',/,
     *          'If you answer no, MEEMUM uses the bulk composition',
     *         ' specified in the input file.',/)
1010  format (/,'Enter value of bulk compositional variable X(C',i1,'):'
     *       )
1060  format (/,'Enter ',a,' amounts of the components:')
1070  format (/,'Enter (zeroes to quit) ',7(a,1x))

      end 

      subroutine invxpt
c----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer i, n, conchk, kcount, icount, ifault, iprint,
     *        iquad, j, igood, ntry, ibest

      logical readyn

      double precision var(l2+k5), objf, x(l2+k5),
     *                 tol, step(l2+k5), simplx, bstobj

      external readyn, mcobj2

      integer npt,jdv
      double precision cptot,ctotal
      common/ cst78 /cptot(k19),ctotal,jdv(k19),npt

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
c                                 set flag for parameter perturbation
      mcpert = .true.
c                                 initialization, read files etc.
      call iniprp
c                                 read experimental data and inversion candidates
      call mcxpt
c                                 parameters for inversion
c                                 wL, wS, dqf_fnin = a_fnin + b_fin*T
      n = 4

      x(1:n) = 0.5d0

      tol = 1d-6
      step(1:n) = .25
      conchk = 10
      iprint = 0
      iquad = 1
      ibest = 0
      igood = 0
      bstobj = 1d99
      simplx = 1d-8
c                                 number of initial starting conditions
      ntry = 100
c                                 max number of objf evaluations
      kcount = 500
c                                 initialize drand
      call random_seed

      do i = 1, ntry

         write (*,'(80(''-''))')
         write (*,1080) i, x(1:n)

         call minim (x, step, n, objf, kcount, iprint, tol, 
     *               conchk, iquad, simplx, var, mcobj2, icount, ifault)

         if (ifault.ne.0) then 

            write (*,'(80(''-''))')
            write (*,1020) ifault,igood
            write (*,'(80(''-''))')

         else

            igood = igood + 1

            if (objf.lt.bstobj) then 
                  ibest = i
                  bstobj = objf
               end if

               write (*,1030) x(1:n)
               write (*,1050) icount, igood
               write (*,1110) ibest, bstobj

            end if
c                               new starting point
            do j = 1, n
               call random_number (x(j))
            end do

         end do

         write (*,1100) igood, ntry
         write (*,1110) ibest, bstobj

         pause

1000  format (/,'Interactively enter bulk compositions (y/n)?',/,
     *          'If you answer no, MEEMUM uses the bulk composition',
     *         ' specified in the input file.',/)
1010  format (/,'Enter value of bulk compositional variable X(C',i1,'):'
     *       )
1020  format ('Minimization failed IFAULT = ',i3,' igood = ',i3)
1030  format ('Final normalized coordinates: ',5(g12.6,1x))
1040  format ('Final potentials: ',5(g12.6,1x))
1050  format ('Number of function evaluations: ',i5,
     *        ' igood = ',i3,' icount = ',i5)
1100  format (i3,' Successes in ',i4,' tries.')
1110  format (/,'Best result was search ',i3,' objf =',g12.6,/)
1060  format (/,'Enter ',a,' amounts of the components:')
1070  format (/,'Enter (zeroes to quit) ',7(a,1x))

1080  format ('Search ',i3,' initial normalized coordinates: ',
     *        5(g12.6,1x))
1090  format (10x,'initial potentials: ',5(g12.6,1x))


      end 

      subroutine mccomp
c-----------------------------------------------------------------------
c a subprogram to read auxilliary input file for MC thermobarometry
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer i, j, ier

      character c

      double precision total

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp

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

      if (iopt(2).eq.1) then
         write (*,*) 'resetting composition_phase option to mol'
         iopt(2) = 0d0
      end if

      mphase = 0

      do

         read (n8,'(a)',iostat=ier) tname
c                                 presumed EOF
         if (ier.ne.0) exit
c                                 filter out comments
         read (tname,'(a)') c
         if (c.eq.'|'.or.c.eq.' ') cycle
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

            do j = 1, icomp
               pblk(mphase,j) = pblk(mphase,j)/atwt(j)
               eblk(mphase,j) = eblk(mphase,j)/atwt(j)
            end do 

         end if

      end do

      if (mphase.lt.2) call errdbg ('input must specify > 1 phase')
c                                 normalize to the icomp (>= icp) components
      do i = 1, mphase

         total = 0d0

         do j = 1, icomp

            total = total + pblk(i,j)

         end do

         do j = 1, icomp

            pblk(i,j) = pblk(i,j) / total
            eblk(i,j) = eblk(i,j) / total

         end do

      end do

      close (n8)

      end

      subroutine mcxpt
c-----------------------------------------------------------------------
c a subprogram to read auxilliary input file for MC inversion of exptal
c data.
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical ok

      integer i, nph, ier, ids

      character key*22, val*3, nval1*12, nval2*12, nval3*12,
     *          strg*40, strg1*40

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp

      character cname*5
      common/ csta4  /cname(k5)

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

      if (iopt(2).eq.1) then
         write (*,*) 'resetting composition_phase option to mol'
         iopt(2) = 0d0
      end if

c                                 read solutions and compounds to be perturbed
      call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

      if (key.ne.'begin_phases') 
     *                     call errdbg ('invalid data, last read '//key)

      mccpd = 0
      mcsol = 0

      ok = .false.
c                                 loop to read inversion phases
      do

         call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

         if (key.eq.'end_phases') exit
c                                 phase name
         read (key,'(a)') tname
c                                 check name
         call matchj (tname,i)

         if (i.lt.0) then

            ok = .true.
            mccpd = mccpd + 1
            mcid(mccpd) = -i

         else if (i.gt.0) then

            ok = .true.
            mcsol = mcsol + 1
            mcids(mcsol) = i
c                                 flag to make gall recalculate
c                                 static compounds
            mcflag(i) = .true.

         end if

      end do

      if (.not.ok) call errdbg ('no legitimate inversion phases')
c                                 number of xpts
      mxpt = 0
c                                 number of phase compositions
      cxpt = 0
c                                 loop to read observation data
      do

         call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)
c                                 assume EOF on error
         if (ier.ne.0) exit

         if (key.ne.'begin_exp') then
            call errdbg ('invalid data, last read '//key)
         end if
c                                an experiment
         mxpt = mxpt + 1
c                                initialize bulk
         xptblk(mxpt,1:icp) = 0
c                                initialize solution counters
         msolct(mxpt,1:isoct) = 0
c                                read name
         call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

         xptnam(mxpt) = key
c                               read expt p,t
         call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

         read (key,*) xptpt(mxpt,1)

         call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

         read (key,*) xptpt(mxpt,2)
c                               read bulk composition
         call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

         if (key.ne.'begin_bulk') then
            call errdbg ('invalid data, last read '//key)
         end if

         do

            call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

            if (key.eq.'end_bulk') exit

            ok = .false.

            do i = 1, icp
               if (key.eq.cname(i)) then
                  ok = .true.
                  exit
               end if
            end do

            if (.not.ok) call errdbg ('invalid component '//key)

            read (strg,*) xptblk(mxpt,i)

         end do

         nph = 0
         ok = .true.

         do
c                                 now read phase data
            call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

            if (key.eq.'end_exp') then
               ok = .false.
               exit
            end if
c                                 phase name
            read (key,'(a)') tname

            nph = nph + 1
c                                 check name
            call matchj (tname,ids)

            xptids(mxpt,nph) = ids

            if (ids.eq.0) call errdbg ('no such entity as: '//tname)
c                                 all clear,
c                                 if compound don't read composition
            if (ids.lt.0) cycle
c                                 counters in case same solution > 1 time
            if (msolct(mxpt,ids).eq.0) then
c                                 first case
               msolct(mxpt,ids) = 1
               msloc(mxpt,msolct(mxpt,ids)) = nph

            else

                msolct(mxpt,ids) = msolct(mxpt,ids) + 1
                msloc(mxpt,msolct(mxpt,ids)) = nph

             end if
c                                 get solution composition
            call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

            if (key.ne.'begin_comp') then
               call errdbg ('invalid data, last read '//key)
            end if

            do

               call redcd1 (n8,ier,key,val,nval1,nval2,nval3,strg,strg1)

               if (key.eq.'end_comp') exit

               ok = .false.

               do i = 1, icp
                  if (key.eq.cname(i)) then
                     ok = .true.
                     exit
                  end if
               end do

               if (.not.ok) call errdbg ('invalid component '//key)

               read (strg,*) xptc(cxpt+i)

            end do
c                                 pointer to the composition of phase nph in expt mexpt 
            xptptr(mxpt,nph) = cxpt

            xptnph(mxpt) = nph
c                                 increment composition pointer
            cxpt = cxpt + icp

         end do
c                                 next experiment
      end do

      close (n8)

      end

      subroutine mcsetv (x)
c-----------------------------------------------------------------------
c a subprogram to set potential variables from scaled coordinates during
c MC inversion.
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer i

      double precision x(*)

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

      end 

      subroutine mcsetb (x)
c-----------------------------------------------------------------------
c set bulk composition for MC thermobarometry
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      double precision x(*)

      integer i, j, k

      integer npt,jdv
      double precision cptot,ctotal
      common/ cst78 /cptot(k19),ctotal,jdv(k19),npt

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
            cblk(j) = cblk(j) + x(k) * pblk(i,j)
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
         b(i) = cblk(i) / ctotal
      end do

      end

      subroutine mcstb2 (id)
c-----------------------------------------------------------------------
c set bulk composition for MC experiment inversion
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer i, id

      integer npt,jdv
      double precision cptot,ctotal
      common/ cst78 /cptot(k19),ctotal,jdv(k19),npt

      integer is
      double precision a,b,c
      common/ cst313 /a(k5,k1),b(k5),c(k1),is(k1+k5)

      integer hcp,idv
      common/ cst52  /hcp,idv(k7)

      double precision v,tr,pr,r,ps
      common/ cst5  /v(l2),tr,pr,r,ps
c-----------------------------------------------------------------------
      cblk(1:kbulk) = 0d0
      ctotal = 0d0

      do i = 1, hcp
         cblk(i) = xptblk(id,i)
      end do
c                                 get total moles to compute mole fractions 
      do i = 1, hcp
         ctotal = ctotal + cblk(i)
      end do

      do i = 1, hcp 
         b(i) = cblk(i) / ctotal
      end do
c                                 set p-t
      v(1) = xptpt(id,1)
      v(2) = xptpt(id,2)

      end

      subroutine mcobj1 (x,obj,bad)
c-----------------------------------------------------------------------
c a subprogram to evaluate objective function for MC thermobarometry
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical bad, ok, imout(k5), imin(k5)

      integer i, j, l, kct(k5), ksol(k5,k5)

      double precision x(*), obj, wcomp, wextra, wmiss, total, mpred

      double precision v,tr,pr,r,ps
      common/ cst5  /v(l2),tr,pr,r,ps

      integer ipot,jv,iv
      common / cst24 /ipot,jv(l2),iv(l2)

      double precision vmax,vmin,dv
      common/ cst9  /vmax(l2),vmin(l2),dv(l2)

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp

      integer kkp,np,ncpd,ntot
      double precision cp3,amt
      common/ cxt15 /cp3(k0,k19),amt(k19),kkp(k19),np,ncpd,ntot

      double precision props,psys,psys1,pgeo,pgeo1
      common/ cxt22 /props(i8,k5),psys(i8),psys1(i8),pgeo(i8),pgeo1(i8)
c-----------------------------------------------------------------------
c                                 convert the scaled potential variables back
c                                 to the normal variables:
      do i = 1, ipot
         v(jv(i)) = vmin(jv(i)) + x(i) * (vmax(jv(i)) - vmin(jv(i)))
      end do
c                                 set the bulk composition
      call mcsetb (x)
c                                 do the optimization and via getloc compute system
c                                 and derivative properties, these computations are costly 
c                                 and can be streamlined for specific applications.
      call meemum (bad)
c                                 compute the objective function
      kct(1:mphase) = 0
c                                 compositional residual weight
      wcomp  = 1d0
c                                 extra phase amount residual weight
      wextra = 1d1
c                                 missing phase residual weight
      wmiss  = 1d1

      ok = .false. 

      imout(1:ntot) = .true.
      imin(1:mphase) = .false.

      do i = 1, ntot

         do j = 1, mphase

            if (kkp(i).eq.pids(j)) then

               ok = .true.
               imout(i) = .false.

               kct(j) = kct(j) + 1
               ksol(j,kct(j)) = i

            end if

         end do

      end do

      if (.not.ok) then
c                                 none of the target phases found
c                                 set obj to ridiculous value
         obj = 1d99

      else

         obj = 0d0
         mpred = 0
c                                 first extraneous phases:
         do i = 1, ntot

            if (imout(i)) then 
c                                 residual is wextra * mass_fraction^2
               obj = obj + 
     *               wextra * (props(17,i)*props(16,i)/psys(17))**2

            end if

         end do
c                                 potential target phases:
         do j = 1, mphase

            if (kct(j).eq.1) then

               mpred = mpred + 1d0
c                                 found phase and no ambiguity
               if (kkp(ksol(j,1)).gt.0) then
c                                 it's a solution compute and add residual
                  total = 0d0
c                                 normalization
                  do l = 1, icomp
                     total = total + pcomp(l,ksol(j,1))
                  end do
c                                 residual
                  do l = 1, icomp
                     obj = obj +
     *               wcomp * (pcomp(l,ksol(j,1))/total - 
     *                       pblk(j,l))**2
                  end do

               end if

            else if (kct(j).gt.1) then 

               mpred = mpred + 1d0
c                                 found phase and ambiguity
               call errdbg ('need more')

            end if

         end do
c                                 missing phase residual
         obj = obj + wmiss * (1d0 - mpred/mphase)

      end if

      end

      SUBROUTINE MINIM(P,STEP,NOP,FUNC,MAX,IPRINT,STOPCR,NLOOP,IQUAD,
     1  SIMP,VAR,FUNCTN,NEVAL,IFAULT)
C
C     A PROGRAM FOR FUNCTION MINIMIZATION USING THE SIMPLEX METHOD.
C     The minimum found will often be a local, not a global, minimum.
C
C     FOR DETAILS, SEE NELDER & MEAD, THE COMPUTER JOURNAL, JANUARY 1965
C
C     PROGRAMMED BY D.E.SHAW,
C     CSIRO, DIVISION OF MATHEMATICS & STATISTICS
C     P.O. BOX 218, LINDFIELD, N.S.W. 2070
C
C     WITH AMENDMENTS BY R.W.M.WEDDERBURN
C     ROTHAMSTED EXPERIMENTAL STATION
C     HARPENDEN, HERTFORDSHIRE, ENGLAND
C
C     Further amended by Alan Miller,
C     CSIRO, Division of Mathematics & Statistics
C     Private Bag 10, CLAYTON, VIC. 3168
C
C     ARGUMENTS:-
C     P()     = INPUT, STARTING VALUES OF PARAMETERS
C               OUTPUT, FINAL VALUES OF PARAMETERS
C     STEP()  = INPUT, INITIAL STEP SIZES
C     NOP     = INPUT, NO. OF PARAMETERS, INCL. ANY TO BE HELD FIXED
C     FUNC    = OUTPUT, THE FUNCTION VALUE CORRESPONDING TO THE FINAL
C               PARAMETER VALUES
C     MAX     = INPUT, THE MAXIMUM NO. OF FUNCTION EVALUATIONS ALLOWED
C     IPRINT  = INPUT, PRINT CONTROL PARAMETER
C                     < 0 NO PRINTING
C                     = 0 PRINTING OF PARAMETER VALUES AND THE FUNCTION
C                         VALUE AFTER INITIAL EVIDENCE OF CONVERGENCE.
C                     > 0 AS FOR IPRINT = 0 PLUS PROGRESS REPORTS AFTER
C                         EVERY IPRINT EVALUATIONS, PLUS PRINTING FOR THE
C                         INITIAL SIMPLEX.
C     STOPCR  = INPUT, STOPPING CRITERION
C     NLOOP   = INPUT, THE STOPPING RULE IS APPLIED AFTER EVERY NLOOP
C               FUNCTION EVALUATIONS.
C     IQUAD   = INPUT, = 1 IF THE FITTING OF A QUADRATIC SURFACE IS REQUIRED
C                      = 0 IF NOT
C     SIMP    = INPUT, CRITERION FOR EXPANDING THE SIMPLEX TO OVERCOME
C               ROUNDING ERRORS BEFORE FITTING THE QUADRATIC SURFACE.
C     VAR()   = OUTPUT, CONTAINS THE DIAGONAL ELEMENTS OF THE INVERSE OF
C               THE INFORMATION MATRIX.
C     FUNCTN  = INPUT, NAME OF THE USER'S SUBROUTINE - ARGUMENTS (P,FUNC)
C               WHICH RETURNS THE FUNCTION VALUE FOR A GIVEN SET OF
C               PARAMETER VALUES IN ARRAY P.
C****   FUNCTN MUST BE DECLARED EXTERNAL IN THE CALLING PROGRAM.
C       IFAULT  = OUTPUT, = 0 FOR SUCCESSFUL TERMINATION
C                         = 1 IF MAXIMUM NO. OF FUNCTION EVALUATIONS EXCEEDED
C                         = 2 IF INFORMATION MATRIX IS NOT +VE SEMI-DEFINITE
C                         = 3 IF NOP < 1
C                         = 4 IF NLOOP < 1
C
C       Advice on usage:
C       If the function minimized can be expected to be smooth in the vicinity
C       of the minimum, users are strongly urged to use the quadratic-surface
C       fitting option.   This is the only satisfactory way of testing that the
C       minimum has been found.   The value of SIMP should be set to at least
C       1000 times the rounding error in calculating the fitted function.
C       e.g. in double precision on a micro- or mini-computer with about 16
C       decimal digit representation of floating-point numbers, the rounding
C       errors in calculating the objective function may be of the order of
C       1.E-12 say in a particular case.   A suitable value for SIMP would then
C       be 1.E-08.   However, if numerical integration is required in the
C       calculation of the objective function, it may only be accurate to say
C       1.E-05 and an appropriate value for SIMP would be about 0.1.
C       If the fitted quadratic surface is not +ve definite (and the function
C       should be smooth in the vicinity of the minimum), it probably means
C       that the search terminated prematurely and you have not found the
C       minimum.
C
C       N.B. P, STEP AND VAR (IF IQUAD = 1) MUST HAVE DIMENSION AT LEAST NOP
C            IN THE CALLING PROGRAM.
C       THE DIMENSIONS BELOW ARE FOR A MAXIMUM OF 20 PARAMETERS.
C      The dimension of BMAT should be at least NOP*(NOP+1)/2.
C
C****      N.B. This version is in DOUBLE PRECISION throughout
C
C       LATEST REVISION - 11 August 1991
C
C*****************************************************************************
C                                 original code used implicit typing
      implicit double precision (a-h, o-z)

      external FUNCTN

      logical bad

      integer nop, lout, iprint, ifault, nloop, nap, loop, iflag, i, 
     *        irow, j, np1, imax, imin, iquad, neval, max, i1, i2, j1, 
     *        k, l, ii, ij, nullty, irank, jj, ijk

      double precision zero, one, two, three, half, a, b, c, func, 
     *                 fnap, fnp1, savemn, test, simp, a0, stopcr,
     *                 rmax, ymin, hmax, hmin, hstar, hstst, hstd, 
     *                 hmean, P(NOP),STEP(NOP),VAR(NOP)

      double precision G(21,20),H(21),PBAR(20),PSTAR(20),PSTST(20),
     *                 AVAL(20),BMAT(210),PMIN(20),VC(210),TEMP(20)

      DATA ZERO/0.D0/, ONE/1.D0/, TWO/2.D0/, THREE/3.D0/, HALF/0.5D0/
C
C     A = REFLECTION COEFFICIENT, B = CONTRACTION COEFFICIENT, AND
C     C = EXPANSION COEFFICIENT.
C
      DATA A,B,C/1.D0, 0.5D0, 2.D0/
C
C     SET LOUT = LOGICAL UNIT NO. FOR OUTPUT
C
      DATA LOUT/6/
C
C     IF PROGRESS REPORTS HAVE BEEN REQUESTED, PRINT HEADING
C
      IF(IPRINT.GT.0) WRITE(LOUT,1000) IPRINT
 1000 FORMAT(' PROGRESS REPORT EVERY',I4,' FUNCTION EVALUATIONS'/,
     1  ' EVAL.  FUNC.',15X,'PARAMETER VALUES')
C
C     CHECK INPUT ARGUMENTS
C
      IFAULT=0
      IF(NOP.LE.0) IFAULT=3
      IF(NLOOP.LE.0) IFAULT=4
      IF(IFAULT.NE.0) RETURN
C
C     SET NAP = NO. OF PARAMETERS TO BE VARIED, I.E. WITH STEP.NE.0
C
      NAP=0
      LOOP=0
      IFLAG=0
      DO 10 I=1,NOP
        IF(STEP(I).NE.ZERO) NAP=NAP+1
   10 CONTINUE
C
C     IF NAP = 0 EVALUATE FUNCTION AT THE STARTING POINT AND RETURN
C
      IF(NAP.GT.0) GO TO 30
      CALL FUNCTN(P,FUNC,bad)
      if (bad) ifault = 99
      RETURN
C
C     SET UP THE INITIAL SIMPLEX
C
   30 DO 40 I=1,NOP
   40 G(1,I)=P(I)
      IROW=2
      DO 60 I=1,NOP
        IF(STEP(I).EQ.ZERO) GO TO 60
        DO 50 J=1,NOP
   50   G(IROW,J)=P(J)
        G(IROW,I)=P(I)+STEP(I)
        IROW=IROW+1
   60 CONTINUE
      NP1=NAP+1
      NEVAL=0
      DO 90 I=1,NP1
        DO 70 J=1,NOP
   70   P(J)=G(I,J)
        CALL FUNCTN(P,H(I),bad)

        if (bad) then 
           ifault = 99
           return
        end if

        NEVAL=NEVAL+1
        IF(IPRINT.LE.0) GO TO 90
        WRITE(LOUT,1010) NEVAL,H(I),(P(J),J=1,NOP)
 1010   FORMAT(/I4, 2X, G12.5, 2X, 5G12.5, 3(/20X, 5G12.5))
   90 CONTINUE
C
C     START OF MAIN CYCLE.
C
C     FIND MAX. & MIN. VALUES FOR CURRENT SIMPLEX (HMAX & HMIN).
C
  100 LOOP=LOOP+1
      IMAX=1
      IMIN=1
      HMAX=H(1)
      HMIN=H(1)
      DO 120 I=2,NP1
        IF(H(I).LE.HMAX) GO TO 110
        IMAX=I
        HMAX=H(I)
        GO TO 120
  110   IF(H(I).GE.HMIN) GO TO 120
        IMIN=I
        HMIN=H(I)
  120 CONTINUE
C
C     FIND THE CENTROID OF THE VERTICES OTHER THAN P(IMAX)
C
      DO 130 I=1,NOP
  130 PBAR(I)=ZERO
      DO 150 I=1,NP1
        IF(I.EQ.IMAX) GO TO 150
        DO 140 J=1,NOP
  140   PBAR(J)=PBAR(J)+G(I,J)
  150 CONTINUE
      DO 160 J=1,NOP
      FNAP = NAP
  160 PBAR(J)=PBAR(J)/FNAP
C
C     REFLECT MAXIMUM THROUGH PBAR TO PSTAR,
C     HSTAR = FUNCTION VALUE AT PSTAR.
C
      DO 170 I=1,NOP
  170 PSTAR(I)=A*(PBAR(I)-G(IMAX,I))+PBAR(I)
      CALL FUNCTN(PSTAR,HSTAR,bad)
      NEVAL=NEVAL+1

        if (bad) then 
           ifault = 99
           return
        end if

      IF(IPRINT.LE.0) GO TO 180
      IF(MOD(NEVAL,IPRINT).EQ.0) WRITE(LOUT,1010) NEVAL,HSTAR,
     1  (PSTAR(J),J=1,NOP)
C
C     IF HSTAR < HMIN, REFLECT PBAR THROUGH PSTAR,
C     HSTST = FUNCTION VALUE AT PSTST.
C
  180 IF(HSTAR.GE.HMIN) GO TO 220
      DO 190 I=1,NOP
  190 PSTST(I)=C*(PSTAR(I)-PBAR(I))+PBAR(I)
      CALL FUNCTN(PSTST,HSTST,bad)
      NEVAL=NEVAL+1

        if (bad) then 
           ifault = 99
           return
        end if

      IF(IPRINT.LE.0) GO TO 200
      IF(MOD(NEVAL,IPRINT).EQ.0) WRITE(LOUT,1010) NEVAL,HSTST,
     1  (PSTST(J),J=1,NOP)
C
C     IF HSTST < HMIN REPLACE CURRENT MAXIMUM POINT BY PSTST AND
C     HMAX BY HSTST, THEN TEST FOR CONVERGENCE.
C
  200 IF(HSTST.GE.HMIN) GO TO 320
      DO 210 I=1,NOP
        IF(STEP(I).NE.ZERO) G(IMAX,I)=PSTST(I)
  210 CONTINUE
      H(IMAX)=HSTST
      GO TO 340
C
C     HSTAR IS NOT < HMIN.
C     TEST WHETHER IT IS < FUNCTION VALUE AT SOME POINT OTHER THAN
C     P(IMAX).   IF IT IS REPLACE P(IMAX) BY PSTAR & HMAX BY HSTAR.
C
  220 DO 230 I=1,NP1
        IF(I.EQ.IMAX) GO TO 230
        IF(HSTAR.LT.H(I)) GO TO 320
  230 CONTINUE
C
C     HSTAR > ALL FUNCTION VALUES EXCEPT POSSIBLY HMAX.
C     IF HSTAR <= HMAX, REPLACE P(IMAX) BY PSTAR & HMAX BY HSTAR.
C
      IF(HSTAR.GT.HMAX) GO TO 260
      DO 250 I=1,NOP
        IF(STEP(I).NE.ZERO) G(IMAX,I)=PSTAR(I)
  250 CONTINUE
      HMAX=HSTAR
      H(IMAX)=HSTAR
C
C     CONTRACTED STEP TO THE POINT PSTST,
C     HSTST = FUNCTION VALUE AT PSTST.
C
  260 DO 270 I=1,NOP
  270 PSTST(I)=B*G(IMAX,I) + (1.d0-B)*PBAR(I)
      CALL FUNCTN(PSTST,HSTST,bad)
      NEVAL=NEVAL+1

        if (bad) then 
           ifault = 99
           return
        end if

      IF(IPRINT.LE.0) GO TO 280
      IF(MOD(NEVAL,IPRINT).EQ.0) WRITE(LOUT,1010) NEVAL,HSTST,
     1  (PSTST(J),J=1,NOP)
C
C     IF HSTST < HMAX REPLACE P(IMAX) BY PSTST & HMAX BY HSTST.
C
  280 IF(HSTST.GT.HMAX) GO TO 300
      DO 290 I=1,NOP
        IF(STEP(I).NE.ZERO) G(IMAX,I)=PSTST(I)
  290 CONTINUE
      H(IMAX)=HSTST
      GO TO 340
C
C     HSTST > HMAX.
C     SHRINK THE SIMPLEX BY REPLACING EACH POINT, OTHER THAN THE CURRENT
C     MINIMUM, BY A POINT MID-WAY BETWEEN ITS CURRENT POSITION AND THE
C     MINIMUM.
C
  300 DO 315 I=1,NP1
        IF(I.EQ.IMIN) GO TO 315
        DO 310 J=1,NOP
          IF(STEP(J).NE.ZERO) G(I,J)=(G(I,J)+G(IMIN,J))*HALF
          P(J)=G(I,J)
  310   CONTINUE
        CALL FUNCTN(P,H(I),bad)
        NEVAL=NEVAL+1

        if (bad) then 
           ifault = 99
           return
        end if

        IF(IPRINT.LE.0) GO TO 315
        IF(MOD(NEVAL,IPRINT).EQ.0) WRITE(LOUT,1010) NEVAL,H(I),
     1              (P(J),J=1,NOP)
  315 CONTINUE
      GO TO 340
C
C     REPLACE MAXIMUM POINT BY PSTAR & H(IMAX) BY HSTAR.
C
  320 DO 330 I=1,NOP
        IF(STEP(I).NE.ZERO) G(IMAX,I)=PSTAR(I)
  330 CONTINUE
      H(IMAX)=HSTAR
C
C     IF LOOP = NLOOP TEST FOR CONVERGENCE, OTHERWISE REPEAT MAIN CYCLE.
C
  340 IF(LOOP.LT.NLOOP) GO TO 100
C
C     CALCULATE MEAN & STANDARD DEVIATION OF FUNCTION VALUES FOR THE
C     CURRENT SIMPLEX.
C
      HSTD=ZERO
      HMEAN=ZERO
      DO 350 I=1,NP1
  350 HMEAN=HMEAN+H(I)
      FNP1 = NP1
      HMEAN=HMEAN/FNP1
      DO 360 I=1,NP1
  360 HSTD=HSTD+(H(I)-HMEAN)**2
      HSTD=SQRT(HSTD/FLOAT(NP1))
C
C     IF THE RMS > STOPCR, SET IFLAG & LOOP TO ZERO AND GO TO THE
C     START OF THE MAIN CYCLE AGAIN.
C
      IF(HSTD.LE.STOPCR.OR.NEVAL.GT.MAX) GO TO 410
      IFLAG=0
      LOOP=0
      GO TO 100
C
C     FIND THE CENTROID OF THE CURRENT SIMPLEX AND THE FUNCTION VALUE THERE.
C
  410 DO 380 I=1,NOP
        IF(STEP(I).EQ.ZERO) GO TO 380
        P(I)=ZERO
        DO 370 J=1,NP1
  370   P(I)=P(I)+G(J,I)
        FNP1 = NP1
        P(I)=P(I)/FNP1
  380 CONTINUE
      CALL FUNCTN(P,FUNC,bad)
      NEVAL=NEVAL+1

        if (bad) then 
           ifault = 99
           return
        end if
      IF(IPRINT.LE.0) GO TO 390
      IF(MOD(NEVAL,IPRINT).EQ.0) WRITE(LOUT,1010) NEVAL,FUNC,
     1  (P(J),J=1,NOP)
C
C     TEST WHETHER THE NO. OF FUNCTION VALUES ALLOWED, MAX, HAS BEEN
C     OVERRUN; IF SO, EXIT WITH IFAULT = 1.
C
  390 IF(NEVAL.LE.MAX) GO TO 420
      IFAULT=1
      IF(IPRINT.LT.0) RETURN
      WRITE(LOUT,1020) MAX
 1020 FORMAT(' NO. OF FUNCTION EVALUATIONS EXCEEDS',I5)
      WRITE(LOUT,1030) HSTD
 1030 FORMAT(' RMS OF FUNCTION VALUES OF LAST SIMPLEX =',G14.6)
      WRITE(LOUT,1040)(P(I),I=1,NOP)
 1040 FORMAT(' CENTROID OF LAST SIMPLEX =',4(/1X,6G13.5))
      WRITE(LOUT,1050) FUNC
 1050 FORMAT(' FUNCTION VALUE AT CENTROID =',G14.6)
      RETURN
C
C     CONVERGENCE CRITERION SATISFIED.
C     IF IFLAG = 0, SET IFLAG & SAVE HMEAN.
C     IF IFLAG = 1 & CHANGE IN HMEAN <= STOPCR THEN SEARCH IS COMPLETE.
C
  420 IF(IPRINT.LT.0) GO TO 430
      WRITE(LOUT,1060)
 1060 FORMAT(/' EVIDENCE OF CONVERGENCE')
      WRITE(LOUT,1040)(P(I),I=1,NOP)
      WRITE(LOUT,1050) FUNC
  430 IF(IFLAG.GT.0) GO TO 450
      IFLAG=1
  440 SAVEMN=HMEAN
      LOOP=0
      GO TO 100
  450 IF(ABS(SAVEMN-HMEAN).GE.STOPCR) GO TO 440
      IF(IPRINT.LT.0) GO TO 460
      WRITE(LOUT,1070) NEVAL
 1070 FORMAT(//' MINIMUM FOUND AFTER',I5,' FUNCTION EVALUATIONS')
      WRITE(LOUT,1080)(P(I),I=1,NOP)
 1080 FORMAT(' MINIMUM AT',4(/1X,6G13.6))
      WRITE(LOUT,1090) FUNC
 1090 FORMAT(' FUNCTION VALUE AT MINIMUM =',G14.6)
  460 IF(IQUAD.LE.0) RETURN
C-------------------------------------------------------------------
C
C     QUADRATIC SURFACE FITTING
C
      IF(IPRINT.GE.0) WRITE(LOUT,1110)
 1110 FORMAT(/' QUADRATIC SURFACE FITTING ABOUT SUPPOSED MINIMUM'/)
C
C     EXPAND THE FINAL SIMPLEX, IF NECESSARY, TO OVERCOME ROUNDING
C     ERRORS.
C
      NEVAL=0
      DO 490 I=1,NP1
  470   TEST=ABS(H(I)-FUNC)
        IF(TEST.GE.SIMP) GO TO 490
        DO 480 J=1,NOP
          IF(STEP(J).NE.ZERO) G(I,J)=(G(I,J)-P(J))+G(I,J)
          PSTST(J)=G(I,J)
  480   CONTINUE
        CALL FUNCTN(PSTST,H(I))
        NEVAL=NEVAL+1
        GO TO 470
  490 CONTINUE
C
C     FUNCTION VALUES ARE CALCULATED AT AN ADDITIONAL NAP POINTS.
C
      DO 510 I=1,NAP
        I1=I+1
        DO 500 J=1,NOP
  500   PSTAR(J)=(G(1,J)+G(I1,J))*HALF
        CALL FUNCTN(PSTAR,AVAL(I))
        NEVAL=NEVAL+1
  510 CONTINUE
C
C     THE MATRIX OF ESTIMATED SECOND DERIVATIVES IS CALCULATED AND ITS
C     LOWER TRIANGLE STORED IN BMAT.
C
      A0=H(1)
      DO 540 I=1,NAP
        I1=I-1
        I2=I+1
        IF(I1.LT.1) GO TO 540
        DO 530 J=1,I1
          J1=J+1
          DO 520 K=1,NOP
  520     PSTST(K)=(G(I2,K)+G(J1,K))*HALF
          CALL FUNCTN(PSTST,HSTST)
          NEVAL=NEVAL+1
          L=I*(I-1)/2+J
          BMAT(L)=TWO*(HSTST+A0-AVAL(I)-AVAL(J))
  530   CONTINUE
  540 CONTINUE
      L=0
      DO 550 I=1,NAP
        I1=I+1
        L=L+I
        BMAT(L)=TWO*(H(I1)+A0-TWO*AVAL(I))
  550 CONTINUE
C
C     THE VECTOR OF ESTIMATED FIRST DERIVATIVES IS CALCULATED AND
C     STORED IN AVAL.
C
      DO 560 I=1,NAP
        I1=I+1
        AVAL(I)=TWO*AVAL(I)-(H(I1)+THREE*A0)*HALF
  560 CONTINUE
C
C     THE MATRIX Q OF NELDER & MEAD IS CALCULATED AND STORED IN G.
C
      DO 570 I=1,NOP
  570 PMIN(I)=G(1,I)
      DO 580 I=1,NAP
        I1=I+1
        DO 580 J=1,NOP
        G(I1,J)=G(I1,J)-G(1,J)
  580 CONTINUE
      DO 590 I=1,NAP
        I1=I+1
        DO 590 J=1,NOP
          G(I,J)=G(I1,J)
  590 CONTINUE
C
C     INVERT BMAT
C
      CALL SYMINV(BMAT,NAP,BMAT,TEMP,NULLTY,IFAULT,RMAX)
      IF(IFAULT.NE.0) GO TO 600
      IRANK=NAP-NULLTY
      GO TO 610
  600 IF(IPRINT.GE.0) WRITE(LOUT,1120)
 1120 FORMAT(/' MATRIX OF ESTIMATED SECOND DERIVATIVES NOT +VE DEFN.'/
     1  ' MINIMUM PROBABLY NOT FOUND'/)
      IFAULT=2
      RETURN
C
C     BMAT*A/2 IS CALCULATED AND STORED IN H.
C
  610 DO 650 I=1,NAP
        H(I)=ZERO
        DO 640 J=1,NAP
          IF(J.GT.I) GO TO 620
          L=I*(I-1)/2+J
          GO TO 630
  620     L=J*(J-1)/2+I
  630     H(I)=H(I)+BMAT(L)*AVAL(J)
  640   CONTINUE
  650 CONTINUE
C
C     FIND THE POSITION, PMIN, & VALUE, YMIN, OF THE MINIMUM OF THE
C     QUADRATIC.
C
      YMIN=ZERO
      DO 660 I=1,NAP
  660 YMIN=YMIN+H(I)*AVAL(I)
      YMIN=A0-YMIN
      DO 670 I=1,NOP
        PSTST(I)=ZERO
        DO 670 J=1,NAP
  670 PSTST(I)=PSTST(I)+H(J)*G(J,I)
      DO 680 I=1,NOP
  680 PMIN(I)=PMIN(I)-PSTST(I)
      IF(IPRINT.LT.0) GO TO 682
      WRITE(LOUT,1130) YMIN,(PMIN(I),I=1,NOP)
 1130 FORMAT(' MINIMUM OF QUADRATIC SURFACE =',G14.6,' AT',
     1  4(/1X,6G13.5))
      WRITE(LOUT,1150)
 1150 FORMAT(' IF THIS DIFFERS BY MUCH FROM THE MINIMUM ESTIMATED',
     1  1X,'FROM THE MINIMIZATION,'/
     2  ' THE MINIMUM MAY BE FALSE &/OR THE INFORMATION MATRIX MAY BE',
     3  1X,'INACCURATE'/)
c
c     Calculate true function value at the minimum of the quadratic.
c
  682 neval = neval + 1
      call functn(pmin, hstar)
c
c     If HSTAR < FUNC, replace search minimum with quadratic minimum.
c
      if (hstar .ge. func) go to 690
      func = hstar
      do 684 i = 1, nop
  684 p(i) = pmin(i)
      write(lout, 1140) func
 1140 format(' True func. value at minimum of quadratic = ', g14.6/)
C
C     Q*BMAT*Q'/2 IS CALCULATED & ITS LOWER TRIANGLE STORED IN VC
C
  690 DO 760 I=1,NOP
        DO 730 J=1,NAP
          H(J)=ZERO
          DO 720 K=1,NAP
            IF(K.GT.J) GO TO 700
            L=J*(J-1)/2+K
            GO TO 710
  700       L=K*(K-1)/2+J
  710       H(J)=H(J)+BMAT(L)*G(K,I)*HALF
  720     CONTINUE
  730   CONTINUE
        DO 750 J=I,NOP
          L=J*(J-1)/2+I
          VC(L)=ZERO
          DO 740 K=1,NAP
  740     VC(L)=VC(L)+H(K)*G(K,J)
  750   CONTINUE
  760 CONTINUE
C
C     THE DIAGONAL ELEMENTS OF VC ARE COPIED INTO VAR.
C
      J=0
      DO 770 I=1,NOP
        J=J+I
        VAR(I)=VC(J)
  770    CONTINUE
      IF(IPRINT.LT.0) RETURN
      WRITE(LOUT,1160) IRANK
 1160 FORMAT(' RANK OF INFORMATION MATRIX =',I3/
     1  ' GENERALIZED INVERSE OF INFORMATION MATRIX:-')
      IJK=1
      GO TO 880
  790 CONTINUE
      WRITE(LOUT,1170)
 1170 FORMAT(/' IF THE FUNCTION MINIMIZED WAS -LOG(LIKELIHOOD),'/
     1  ' THIS IS THE COVARIANCE MATRIX OF THE PARAMETERS'/
     2  ' IF THE FUNCTION WAS A SUM OF SQUARES OF RESIDUALS'/
     3  ' THIS MATRIX MUST BE MULTIPLIED BY TWICE THE ESTIMATED',
     4  1X'RESIDUAL VARIANCE'/' TO OBTAIN THE COVARIANCE MATRIX.'/)
      CALL SYMINV(VC,NAP,BMAT,TEMP,NULLTY,IFAULT,RMAX)
C
C     BMAT NOW CONTAINS THE INFORMATION MATRIX
C
      WRITE(LOUT,1190)
 1190 FORMAT(' INFORMATION MATRIX:-'/)
      IJK=3
      GO TO 880
c
c     Calculate correlations of parameter estimates, put into VC.
c
  800 IJK=2
      II=0
      IJ=0
      DO 840 I=1,NOP
        II=II+I
        IF(VC(II).GT.ZERO) THEN
          VC(II)=ONE/SQRT(VC(II))
        ELSE 
          VC(II)=ZERO
	END IF
        JJ=0
        DO 830 J=1,I-1
          JJ=JJ+J
          IJ=IJ+1
          VC(IJ)=VC(IJ)*VC(II)*VC(JJ)
  830   CONTINUE
        IJ=IJ+1
  840 CONTINUE
      WRITE(LOUT,1200)
 1200 FORMAT(/' CORRELATION MATRIX:-')
      II=0
      DO 850 I=1,NOP
        II=II+I
        IF(VC(II).NE.ZERO) VC(II)=ONE
  850 CONTINUE
      GO TO 880
  860 WRITE(LOUT,1210) NEVAL
 1210 FORMAT(/' A FURTHER',I4,' FUNCTION EVALUATIONS HAVE BEEN USED'/)
      RETURN
c
c     Pseudo-subroutine to print VC if IJK = 1 or 2, or
c     BMAT if IJK = 3.
c
  880 L=1
  890 IF(L.GT.NOP) GO TO (790,860,800),IJK
      II=L*(L-1)/2
      DO 910 I=L,NOP
        I1=II+L
        II=II+I
        I2=MIN(II,I1+5)
        IF(IJK.EQ.3) GO TO 900
        WRITE(LOUT,1230)(VC(J),J=I1,I2)
        GO TO 910
  900   WRITE(LOUT,1230)(BMAT(J),J=I1,I2)
  910 CONTINUE
 1230 FORMAT(1X,6G13.5)
      WRITE(LOUT,1240)
 1240 FORMAT(/)
      L=L+6
      GO TO 890
      END

      SUBROUTINE SYMINV(A,N,C,W,NULLTY,IFAULT,RMAX)
C
C     ALGORITHM AS7, APPLIED STATISTICS, VOL.17, 1968.
C
C     ARGUMENTS:-
C     A()     = INPUT, THE SYMMETRIC MATRIX TO BE INVERTED, STORED IN
C               LOWER TRIANGULAR FORM
C     N       = INPUT, ORDER OF THE MATRIX
C     C()     = OUTPUT, THE INVERSE OF A (A GENERALIZED INVERSE IF C IS
C               SINGULAR), ALSO STORED IN LOWER TRIANGULAR.
C               C AND A MAY OCCUPY THE SAME LOCATIONS.
C     W()     = WORKSPACE, DIMENSION AT LEAST N.
C     NULLTY  = OUTPUT, THE RANK DEFICIENCY OF A.
C     IFAULT  = OUTPUT, ERROR INDICATOR
C                     = 1 IF N < 1
C                     = 2 IF A IS NOT +VE SEMI-DEFINITE
C                     = 0 OTHERWISE
C     RMAX    = OUTPUT, APPROXIMATE BOUND ON THE ACCURACY OF THE DIAGONAL
C               ELEMENTS OF C.  E.G. IF RMAX = 1.E-04 THEN THE DIAGONAL
C               ELEMENTS OF C WILL BE ACCURATE TO ABOUT 4 DEC. DIGITS.
C
C     LATEST REVISION - 18 October 1985
C
C*************************************************************************
C
      implicit double precision (a-h, o-z)

      integer n, nrow, nullty, ifault, nn, irow, ndiag, l, i, icol, 
     *        jcol, mdiag, j, k

      double precision zero, one, rmax, x
      double precision A(*),C(*),W(N)

      DATA ZERO/0.D0/, ONE/1.D0/
C
      NROW=N
      IFAULT=1
      IF(NROW.LE.0) GO TO 100
      IFAULT=0
C
C     CHOLESKY FACTORIZATION OF A, RESULT IN C
C
      CALL CHOLA(A,NROW,C,NULLTY,IFAULT,RMAX,W)
      IF(IFAULT.NE.0) GO TO 100
C
C     INVERT C & FORM THE PRODUCT (CINV)'*CINV, WHERE CINV IS THE INVERSE
C     OF C, ROW BY ROW STARTING WITH THE LAST ROW.
C     IROW = THE ROW NUMBER, NDIAG = LOCATION OF LAST ELEMENT IN THE ROW.
C
      NN=NROW*(NROW+1)/2
      IROW=NROW
      NDIAG=NN
   10 IF(C(NDIAG).EQ.ZERO) GO TO 60
      L=NDIAG
      DO 20 I=IROW,NROW
        W(I)=C(L)
        L=L+I
   20 CONTINUE
      ICOL=NROW
      JCOL=NN
      MDIAG=NN
   30 L=JCOL
      X=ZERO
      IF(ICOL.EQ.IROW) X=ONE/W(IROW)
      K=NROW
   40 IF(K.EQ.IROW) GO TO 50
      X=X-W(K)*C(L)
      K=K-1
      L=L-1
      IF(L.GT.MDIAG) L=L-K+1
      GO TO 40
   50 C(L)=X/W(IROW)
      IF(ICOL.EQ.IROW) GO TO 80
      MDIAG=MDIAG-ICOL
      ICOL=ICOL-1
      JCOL=JCOL-1
      GO TO 30
c
c     Special case, zero diagonal element.
c
   60 L=NDIAG
      DO 70 J=IROW,NROW
        C(L)=ZERO
        L=L+J
   70 CONTINUE
c
c      End of row.
c
   80 NDIAG=NDIAG-IROW
      IROW=IROW-1
      IF(IROW.NE.0) GO TO 10
  100 RETURN
      END

      SUBROUTINE CHOLA(A, N, U, NULLTY, IFAULT, RMAX, R)
C
C     ALGORITHM AS6, APPLIED STATISTICS, VOL.17, 1968, WITH
C     MODIFICATIONS BY A.J.MILLER
C
C     ARGUMENTS:-
C     A()     = INPUT, A +VE DEFINITE MATRIX STORED IN LOWER-TRIANGULAR
C               FORM.
C     N       = INPUT, THE ORDER OF A
C     U()     = OUTPUT, A LOWER TRIANGULAR MATRIX SUCH THAT U*U' = A.
C               A & U MAY OCCUPY THE SAME LOCATIONS.
C     NULLTY  = OUTPUT, THE RANK DEFICIENCY OF A.
C     IFAULT  = OUTPUT, ERROR INDICATOR
C                     = 1 IF N < 1
C                     = 2 IF A IS NOT +VE SEMI-DEFINITE
C                     = 0 OTHERWISE
C     RMAX    = OUTPUT, AN ESTIMATE OF THE RELATIVE ACCURACY OF THE
C               DIAGONAL ELEMENTS OF U.
C     R()     = OUTPUT, ARRAY CONTAINING BOUNDS ON THE RELATIVE ACCURACY
C               OF EACH DIAGONAL ELEMENT OF U.
C
C     LATEST REVISION - 18 October 1985
C
C*************************************************************************
C
      implicit double precision (a-h, o-z)

      integer n, irow, l, icol, m, ifault, nullty, i, j, k

      double precision A(*),U(*),R(N), w, eta, zero, five, rmax, rsq
C
C     ETA SHOULD BE SET EQUAL TO THE SMALLEST +VE VALUE SUCH THAT
C     1.0 + ETA IS CALCULATED AS BEING GREATER THAN 1.0 IN THE ACCURACY
C     BEING USED.
C
      DATA ETA/1.D-16/, ZERO/0.D0/, FIVE/5.D0/
C
      IFAULT=1
      IF(N.LE.0) GO TO 100
      IFAULT=2
      NULLTY=0
      RMAX=ETA
      R(1)=ETA
      J=1
      K=0
C
C     FACTORIZE COLUMN BY COLUMN, ICOL = COLUMN NO.
C
      DO 80 ICOL=1,N
        L=0
C
C     IROW = ROW NUMBER WITHIN COLUMN ICOL
C
        DO 40 IROW=1,ICOL
          K=K+1
          W=A(K)
          IF(IROW.EQ.ICOL) RSQ=(W*ETA)**2
          M=J
          DO 10 I=1,IROW
            L=L+1
            IF(I.EQ.IROW) GO TO 20
            W=W-U(L)*U(M)
            IF(IROW.EQ.ICOL) RSQ=RSQ+(U(L)**2*R(I))**2
            M=M+1
   10     CONTINUE
   20     IF(IROW.EQ.ICOL) GO TO 50
          IF(U(L).EQ.ZERO) GO TO 30
          U(K)=W/U(L)
          GO TO 40
   30     U(K)=ZERO
          IF(ABS(W).GT.ABS(RMAX*A(K))) GO TO 100
   40   CONTINUE
C
C     END OF ROW, ESTIMATE RELATIVE ACCURACY OF DIAGONAL ELEMENT.
C
   50   RSQ=SQRT(RSQ)
        IF(ABS(W).LE.FIVE*RSQ) GO TO 60
        IF(W.LT.ZERO) GO TO 100
        U(K)=SQRT(W)
        R(I)=RSQ/W
        IF(R(I).GT.RMAX) RMAX=R(I)
        GO TO 70
   60   U(K)=ZERO
        NULLTY=NULLTY+1
   70   J=J+ICOL
   80 CONTINUE
      IFAULT=0
C
  100 RETURN
      END

      double precision function score (kd,id,j)
c-----------------------------------------------------------------------
c a function to evaluate the distance between oberved and candidate 
c compositions for MC
c-----------------------------------------------------------------------
      include 'perplex_parameters.h'

      integer id, kd, j, l

      double precision total

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp
c-----------------------------------------------------------------------
      total = 0d0
      score = 0d0
c                                 normalization
      do l = 1, icomp
         total = total + pcomp(l,kd)
      end do
c                                 residual
      do l = 1, icomp
         score = score + (pcomp(l,kd)/total - 
     *                    xptc(xptptr(id,j)+l))**2
      end do

      end

      subroutine mcobj2 (x,obj,bad)
c-----------------------------------------------------------------------
c a subprogram to evaluate objective function for MC data inversion
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical bad, ok, imout(k5), imin(k5), used(k5,k5)

      integer id, jd, ids, i, j, kct(k5), ksol(k5,k5), ibest

      double precision x(*), lobj, wcomp, wextra, wmiss, mpred, 
     *                 obj, score, best, res

      external score

      double precision v,tr,pr,r,ps
      common/ cst5  /v(l2),tr,pr,r,ps

      integer ipot,jv,iv
      common / cst24 /ipot,jv(l2),iv(l2)

      double precision vmax,vmin,dv
      common/ cst9  /vmax(l2),vmin(l2),dv(l2)

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp

      integer kkp,np,ncpd,ntot
      double precision cp3,amt
      common/ cxt15 /cp3(k0,k19),amt(k19),kkp(k19),np,ncpd,ntot

      double precision props,psys,psys1,pgeo,pgeo1
      common/ cxt22 /props(i8,k5),psys(i8),psys1(i8),pgeo(i8),pgeo1(i8)

      double precision wgl, wkl, vlar
      common/ cxt2r /wgl(m3,m1,h9),wkl(m16,m17,m18,h9),vlar(m3,m4,h9)
c-----------------------------------------------------------------------
c     write (*,'(5(f14.6,1x))') x(1:4)
c                                 set the cpd dqf's
      do i = 1, mccpd
         mdqf(make(mcid(i)),1) = -5d3 + x(1) * 1d4
         mdqf(make(mcid(i)),2) = -5d1 + x(2) * 1d2
      end do

      do i = 1, mcsol
         wgl(1,1,mcids(i)) = -5d4 + x(2+i) * 1d5
      end do

      obj = 0d0
c                                 loop through observations
      do id = 1, mxpt
c                                 set p, t, bulk
         call mcstb2 (id)

c                                 do the optimization and via getloc compute system
c                                 and derivative properties, these computations are costly 
c                                 and can be streamlined for specific applications.
         call meemum (bad)

         if (bad) then 
            write (*,*) 'oink'
         end if

c        call calpr0 (6)
c                                 compute the observation objective function
         kct(1:xptnph(id)) = 0
c                                 compositional residual weight
         wcomp  = 1d0
c                                 extra phase amount residual weight
         wextra = 1d1
c                                 missing phase residual weight
         wmiss  = 1d1

         ok = .false. 

         imout(1:ntot) = .true.
         used = .false.
         imin(1:mphase) = .false.
         kct = 0
         ksol = 0

         do i = 1, ntot

            do j = 1, xptnph(id)

               if (kkp(i).eq.xptids(id,j)) then

                  ok = .true.
                  imout(i) = .false.

                  kct(j) = kct(j) + 1
                  ksol(j,kct(j)) = i

               end if

            end do

         end do

         if (.not.ok) then
c                                 none of the target phases found
c                                 set obj to ridiculous value
            lobj = 1d2

         else

            lobj = 0d0
            mpred = 0
c                                 first extraneous phases:
            do i = 1, ntot

               if (imout(i)) then 
c                                 residual is wextra * mass_fraction^2
                  lobj = lobj + 
     *                   wextra * (props(17,i)*props(16,i)/psys(17))**2

               end if

            end do
c                                 potential target phases:
            do j = 1, xptnph(id)

               if (kct(j).eq.0) cycle

               jd = ksol(j,1)
               ids = kkp(jd)

               if (kct(j).eq.1.and.ids.lt.0) then
c                                 a compound, just count
                  mpred = mpred + 1d0

               else if (kct(j).eq.1.and.
     *                  msolct(id,ids).eq.1) then
c                                 found solution and no ambiguity
                  mpred = mpred + 1d0
c                                 compute and add residual
                  lobj = lobj + wcomp * score (jd,id,j)

               else if (kct(j).gt.1) then

                  best = 1d99
                  ok = .false.

                  do i = 1, kct(j)

                     if (used(j,i)) cycle

                     res = score (ksol(j,i),id,j)

                     if (res.lt.best) then
                        best = res
                        ibest = i
                        ok = .true.
                     end if

                  end do

                  if (ok) then

                     used(j,ibest) = .true.
                     mpred = mpred + 1d0
                     lobj = lobj + wcomp * best

                  end if

               end if

            end do
c                                 score remaining extraneous phaes
            do j = 1, xptnph(id)

               if (kct(j).lt.2) cycle

               do i = 1, kct(j)

                  if (used(j,i)) cycle

                  jd = ksol(j,i)
c                                 residual is wextra * mass_fraction^2
                  lobj = lobj + wextra * 
     *                         (props(17,jd)*props(16,jd)/psys(17))**2

               end do

            end do
c                                 missing phase residual
            lobj = lobj + wmiss * (1d0 - mpred/xptnph(id))

         end if
c                                 accumulate scores
         obj = obj + lobj

c        write (*,'(i3,1x,2(g12.6,1x,a))') id, lobj, xptnam(id),obj

      end do

      end