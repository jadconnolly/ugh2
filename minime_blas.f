
      subroutine minfrc (ifail)
c-----------------------------------------------------------------------
c minimize the omega function for the independent endmember fractions
c of solution ids subject to site fraction constraints

c     number of independent endmember fractions -> nstot-1 (<m19)
c     number of independent endmember fractions -> nz (<m20)
c     closure is forced in the objective function (gsol2)

c ingsol MUST be called prior to minfrc to initialize solution/p-t
c specific properties!

c endmember gibbs energies must be computed (presumably by gall)
c prior to the call to minfxc!
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical tic, zbad, swap, xref

      integer i, nvar, iter, iwork(m22), idif,
     *        istate(m21), nclin, ntot, ifail

      double precision ggrd(m19), lapz(m20,m19),gsol1, pinc,
     *                 bl(m21), bu(m21), gfinal, ppp(m19),
     *                 clamda(m21),r(m19,m19),work(m23),
     *                 yt(m4),zsite(m10,m11), sum

      external gsol2, gsol1

      integer nz
      double precision apz, zl, zu
      common/ cstp2z /apz(h9,m20,m19), zl(h9,m20), zu(h9,m20), nz(h9)

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      double precision units, r13, r23, r43, r59, zero, one, r1
      common/ cst59 /units, r13, r23, r43, r59, zero, one, r1

      logical mus
      double precision mu
      common/ cst330 /mu(k8),mus

      character tname*10
      logical refine, lresub
      common/ cxt26 /refine,lresub,tname

      character fname*10, aname*6, lname*22
      common/ csta7 /fname(h9),aname(h9),lname(h9)

      double precision wmach
      common/ cstmch /wmach(10)

      integer itmxnp, lvlder, lverfy
      common/ ngg020 /itmxnp, lvlder, lverfy

      logical fdchk, cntrl, needfd, fdincs
      common/ cstfds /fdchk, cntrl, needfd, fdincs
c-----------------------------------------------------------------------
      yt = pa

      ifail = 0

      tic = .true.

      nclin = nz(rids)
      ntot = nstot(rids)

      if (equimo(rids)) then
         nvar = ntot - 1
      else 
         nvar = ntot
      end if

      if (boundd(rids)) then
c                                 make the composition non-degenerate
         sum = 0d0
         do i = 1, ntot
            if (pa(i).le.0d0) then 
               pa(i) = zero
            end if

            sum = sum + pa(i)
         end do 

         if (sum.ne.1d0) then
            pa(1:ntot) = pa(1:ntot)/sum
         end if

      end if
c                                 finite difference increments
c                                 will be estimated at this 
c                                 coordinate, so choose a feasible 
c                                 composition
      ppp(1:nvar) = pa(1:nvar)
c                                 initialize bounds
      if (boundd(rids)) then
c                                 the endmember fractions are bounded
         bu(1:nvar) = 1d0
         bl(1:nvar) = 0d0
         if (.not.lorder(rids)) nclin = 0

      else 
c                                 the model has site fractions
         bu(1:nvar) = 1d0
         bl(1:nvar) = -1d0

      end if 
c                                 load the local constraints 
c                                 from the global arrays
      lapz(1:nclin,1:nvar) = apz(rids,1:nclin,1:nvar)

      bl(nvar+1:nvar+nclin) = zl(rids,1:nclin)
      bu(nvar+1:nvar+nclin) = zu(rids,1:nclin)

      if (nvar.eq.ntot) then
c                                 closure for non-equimolar ordering
         nclin = nclin + 1
         bl(nvar+nclin) = 1d0
         bu(nvar+nclin) = 1d0
         lapz(nclin,1:nvar) = 1d0

      else if (nclin.eq.0) then 
c                                 closure for molecular models
         nclin = nclin + 1
         bl(nvar+nclin) = 0d0
         bu(nvar+nclin) = 1d0
         lapz(nclin,1:nvar) = 1d0

      end if

      if (deriv(rids)) then
c                                 LVLDER = 3, all derivatives available
         needfd = .false.
c                                 LVERFY = 0, use input differences
c                                 LVERFY = 1, compute finite difference increments 
c                                 LVERFY = 2, check analytical against numerical derivatives
         lverfy = 1

      else
c                                 LVLDER = 0, no derivatives
         needfd = .true.

      end if

      call nlpsol (nvar,nclin,m20,m19,lapz,bl,bu,gsol2,iter,
     *            istate,clamda,gfinal,ggrd,r,ppp,iwork,m22,work,m23)

      if (iter.eq.0) then
         ifail = 1
         return
      end if

c                                 reconstruct pa-array, necessary? yes
      yt(1:nstot(rids)) = pa(1:nstot(rids))
      call ppp2pa (ppp,sum,nvar)
c                                 reject bad site populations, necessary?
      if (boundd(rids)) then
         if (pa(nstot(rids)).lt.0d0) then 
            ifail = 2
            return
         end if
      end if
      if (zbad(pa,rids,zsite,fname(rids),.false.,fname(rids))) then
         ifail = 3
         return
      end if
c                                 save the final point, the point may have
c                                 already been saved by gsol2 but because
c                                 gsol2 uses a replicate threshold of nopt(37)
c                                 a near solution rpc would prevent gsol2 from 
c                                 saving the final composition. here the replicate
c                                 threshold is reduced to zero (sqrt(eps)).
      call makepp (rids)
c                                 if logical arg = T use implicit ordering
      gfinal = gsol1 (rids,.false.)

      if (rsum.eq.0d0) then 
         ifail = 4
         return
      end if
c                                 save the final QP result
      call savrpc (gfinal,0d0,swap,idif)

      if (lopt(54).and..not.swap) then

         yt(1:nstot(rids)) = pa(1:nstot(rids))
c                                 scatter in only for nstot-1 gradients
         pinc = 1d0 + nopt(48)
c                                 in case on 1st iteration set refine to 
c                                 to true and then reset to old value on 
c                                 exit
         xref = refine
         refine = .true.

         do i = 1, lstot(rids)

            pa(1:nstot(rids)) = yt(1:nstot(rids))/pinc

            pa(i) = pa(i) + (1d0 - 1d0/pinc)

            if (zbad(pa,rids,zsite,fname(rids),.false.,fname(rids))) 
     *                                                            cycle 
            call makepp (rids)
c                                 degeneracy test removed
c                                 if logical arg = T use implicit ordering
            gfinal = gsol1 (rids,.true.)
c                                 save the scatter point
            call savrpc (gfinal,nopt(48)/2d0,swap,idif)

         end do
c                                 reset refine
         refine = xref

      end if

      end

      subroutine ppp2pa (ppp,sum,nvar)
c-----------------------------------------------------------------------
c reconstruct pa array from ppp array for minfxc/minfrc
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical neg

      integer i, nvar

      double precision ppp(*), sum

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)
c-----------------------------------------------------------------------
      sum = 0d0
      neg = .false.

      do i = 1, nvar

         sum = sum + ppp(i)
         pa(i) = ppp(i)

      end do

      if (nvar.lt.nstot(rids)) pa(nstot(rids)) = 1d0 - sum

      end

      subroutine gsol2 (mode,nvar,ppp,gval,dgdp,fdnorm,bl,bu)
c-----------------------------------------------------------------------
c function to evaluate gibbs energy of a solution for minfrc. can call 
c either gsol1 with order true or false, true seems to give better results
c presumably because it's using analytical gradients.
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical zbad, saved, bad, badp(m14)

      integer i, j, nvar, mode, idif

      double precision ppp(*), gval, dgdp(*), psum, 
     *                 gsol1, g, bsum, zsite(m10,m11),
     *                 bl(*), bu(*), fdnorm

      external gsol1, zbad

      logical mus
      double precision mu
      common/ cst330 /mu(k8),mus

      double precision units, r13, r23, r43, r59, zero, one, r1
      common/ cst59 /units, r13, r23, r43, r59, zero, one, r1

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      integer jphct
      double precision g2, cp2, c2tot
      common/ cxt12 /g2(k21),cp2(k5,k21),c2tot(k21),jphct

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp

      logical outrpc
      common/ ngg015 /outrpc

      integer itmxnp, lvlder, lverfy
      common/ ngg020 /itmxnp, lvlder, lverfy

      logical fdchk, cntrl, needfd, fdincs
      common/ cstfds /fdchk, cntrl, needfd, fdincs
c-----------------------------------------------------------------------
      if (lopt(61)) call begtim (2)
c                                 reconstruct pa array
      call ppp2pa (ppp,psum,nvar)

      call makepp (rids)
c                                 get the bulk composition from pa
      call getscp (rcp,rsum,rids,rids)

      if (deriv(rids).and..not.needfd) then

         call getder (g,dgdp,rids,needfd,badp)

         if (needfd) then
c                                 get numeric derivatives:
c                                 -------------------------------------
c                                 set derivative flag for nlpsol
            lvlder = 0
c                                 compute the leveled g, gval
            call gsol5 (g,gval)
c                                 set bad to force numder to evaluate
c                                 all derivatives
            bad = .false.
c                                 numder compute dg'dp
            call numder (gval,dgdp,ppp,fdnorm,bl,bu,psum,nvar,bad,badp,
     *                   mode)

         else 
c                                 analytical derivatives:
c                                 ------------------------------------
            gval = g

            do j = 1, icp
c                                 degenerate sys, mu undefined:
               if (isnan(mu(j))) cycle
c                                 convert g to g'
               gval = gval - rcp(j)*mu(j)
c                                 convert dgdp to dg'dp
               do i = 1, nvar
                  dgdp(i) = dgdp(i) - dcdp(j,i,rids)*mu(j)
               end do

            end do

         end if

      else
c                                 only numeric derivatives are
c                                 available, get g at the composition
         g = gsol1(rids,.false.)
c                                 level it
         call gsol5 (g,gval)
c                                 set bad to force numder to do all
c                                 derivatives
         bad = .false.
c                                  compute derivatives
         call numder (gval,dgdp,ppp,fdnorm,bl,bu,psum,nvar,bad,badp,
     *                mode)

      end if

      if (mode.lt.0) then
         return
      end if
c                                 if numeric derivatives were
c                                 evaluated reset composition
c                                 data
      if (needfd) then
         call getscp (rcp,rsum,rids,rids)
      end if

      if (lopt(57).and.outrpc) then 
c                                 try to eliminate bad results
         if (psum.lt.one.or.psum.gt.1d0+zero.or.bsum.lt.zero) return
         if (zbad(pa,rids,zsite,'a',.false.,'a')) return
c                                 save the composition
         call savrpc (g,nopt(37),saved,idif)

      end if

      if (lopt(61)) call endtim (2,.false.,'Dynamic G')

      end

      subroutine gsol5 (g,gval)
c-----------------------------------------------------------------------
c gsol5 is a shell called by minfrc/gsol2 that calls gsol1 to compute
c the true gibbs energy (g) and the leveled g (gval). both pa and pp
c must be set prior to calling gsol5.
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer j

      double precision gval, gsol1, g

      external gsol1

      logical mus
      double precision mu
      common/ cst330 /mu(k8),mus

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp
c-----------------------------------------------------------------------
      gval = g

      do j = 1, icp
c                                 degenerate sys, mu undefined:
         if (isnan(mu(j))) cycle
c                                 convert g to g'
         gval = gval - rcp(j)*mu(j)

      end do

      end

      subroutine gsol6 (gval,ppp,nvar)
c----------------------------------------------------------------------
c gsol6 is a shell to compute the leveled g for numerical derivatives
c invoked by minfrc via gsol2.
c----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer nvar

      double precision ppp(*), gval, gsol1, g, psum

      external gsol1
c-----------------------------------------------------------------------
c                                 reconstruct pa array from ppp
      call ppp2pa (ppp,psum,nvar)
c                                 make the pp array for gsol1
      call makepp (rids)
c                                 get the bulk composition from pa
      call getscp (rcp,rsum,rids,rids)
c                                 get the real g
      g = gsol1 (rids,.false.)
c                                 get the leveled gval
      call gsol5 (g,gval)
c
      end

      subroutine savrpc (g,tol,swap,idif)
c-----------------------------------------------------------------------
c save a dynamic composition/g for the lp solver
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical swap

      integer i, j, ntot, ltot, ttot, ipt, ist, idif

      double precision g, diff, tol, dtol

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      integer jphct
      double precision g2, cp2, c2tot
      common/ cxt12 /g2(k21),cp2(k5,k21),c2tot(k21),jphct

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp

      double precision wmach
      common/ cstmch /wmach(10)

      double precision units, r13, r23, r43, r59, zero, one, r1
      common/ cst59 /units, r13, r23, r43, r59, zero, one, r1
c-----------------------------------------------------------------------
      ntot = nstot(rids)
      ltot = lstot(rids)
      ttot = tstot(rids)

      idif = 0
c                                o/d models use the pp array, which is 
c                                not normalized for non-equimolar o/d, do
c                                the normalization here
      if (.not.equimo(rids)) then

         diff = 0d0

         do j = 1, ltot
            diff = diff + pp(j)
         end do

         pp(1:ltot) = pp(1:ltot)/diff

      end if

      if (tol.eq.0d0) then
         dtol = zero
      else
         dtol = tol
      end if

      swap = .false.
c                                 degenerate bulk check is in earlier 
c                                 versions, probably was never done right

      do i = jpoint + 1, jphct
c                                 check if duplicate
         if (jkp(i).ne.rids) cycle

         if (lorder(rids)) then
            ist = icoz(i) + ntot
         else 
            ist = icoz(i)
         end if

         diff = 0d0

         do j = 1, ltot

            ipt = ist + j

            if (lorder(rids)) then
               diff = diff + dabs(pp(j) - zco(ipt))
            else
               diff = diff + dabs(pa(j) - zco(ipt))
            end if

         end do

         if (diff.gt.dtol) cycle

         if (diff.lt.zero) then
c                                 true zero difference, set swap to 
c                                 avoid scatter point replication.
            swap = .true.
c                                 if perfect replica swap lower g's
            if (diff.eq.0d0.and.g2(i).gt.g/rsum) g2(i) = g/rsum

            idif = i

            return

         else

            return

         end if

      end do
c                                 increment counters
      jphct = jphct + 1
      idif = jphct
      icoz(jphct) = zcoct
      zcoct = zcoct + ttot

c                                 lagged speciation quack flag
      quack(jphct) = rkwak
c                                 normalize and save the composition
      cp2(1:icomp,jphct) = rcp(1:icomp)/rsum
c                                 the solution model pointer
      jkp(jphct) = rids
c                                 the refinement point pointer
      hkp(jphct) = rkds
c                                 save the normalized g
      g2(jphct) = g/rsum
c                                 sum scp(1:icp)
      if (ksmod(rids).eq.39.and.lopt(32).and..not.rkwak) then
c                                 this will renormalize the bulk to a 
c                                 mole of solvent, it's no longer clear to 
c                                 me why this is desireable.
         c2tot(jphct) = rsum/rsmo
      else
         c2tot(jphct) = rsum
      end if

      quack(jphct) = rkwak
c                                 save the endmember fractions
      zco(icoz(jphct)+1:icoz(jphct)+ntot) = pa(1:ntot)
c                                 and normalized bulk fractions if o/d
      if (lorder(rids)) 
     *   zco(icoz(jphct)+ntot+1:icoz(jphct)+ttot) = pp(1:ltot)

      end 

      subroutine numder (g,dgdp,ppp,fdnorm,bl,bu,sum,nvar,bad,badp,mode)
c-----------------------------------------------------------------------
c subroutine to evaluate the gradient numerically for minfrc/minfxc
c on input sum is the total of the fractions, for bounded models this
c can be used to choose increment sign.
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical zbad, bad, badp(m14)

      integer i, nvar, mode

      double precision ppp(*), dgdp(*), oldpa(m14), sum,
     *            dpp, gsol1, g, zsite(m10,m11), g1, g3,
     *            bl(*), bu(*), dbl, dbu, fdnorm

      external gsol1, zbad

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      double precision cdint, ctol, dxlim, epsrf, eta, fdint, ftol,
     *                 hcndbd
      common/ ngg021 /cdint, ctol, dxlim, epsrf, eta,
     *                fdint, ftol, hcndbd

      integer lfdset, lvldif
      common/ ngg014 /lvldif, lfdset
c-----------------------------------------------------------------------
c                                 one or more derivatives are singular
c                                 because of ln(0) entropy term, evaluate
c                                 by finite difference, save old 0 values:
      oldpa(1:nstot(rids)) = pa(1:nstot(rids))

      fdnorm = 0d0

      do i = 1, nvar
c                                 if bad, numder is being called to supplement
c                                 analytical derivatives, otherwise evaluate 
c                                 all derivatives
         if (bad.and..not.badp(i)) cycle
c                                choose direction away from closest bound
         dbl = bl(i) - ppp(i)
         dbu = bu(i) - ppp(i)
c                                 2nd or 1st order
         if (lvldif.eq.2) then
c                                 2nd
            if (lfdset.eq.1) then
               dpp = cdint
            else
               dpp = hctl(i)
            end if

         else
c                                1st
            if (lfdset.eq.1) then 
               dpp = fdint
            else 
               dpp = hfwd(i)
            end if

         end if
c                                 rel/abs scaling
         dpp = dpp * (1d0 + dabs(ppp(i)))
c                                 first increment, doubled for central
         if (lvldif.eq.2) dpp = 2d0*dpp
c                                 try to avoid invalid values (z<=0)
         if (pa(i).gt.bu(i)-dpp) then 

            dpp = -dpp

         else if (pa(i).gt.bl(i)+2d0*dpp) then

           if (dbl+dbu.lt.0d0) then 

              dpp = -dpp

           end if

!            if (boundd(rids)) then
!c                                 bounded compositions
!               if (sum.gt.1d0-dpp) then
!c                                 only a negative increment is possible
!                  if (pa(i).lt.dpp) then 
!                     mode = -1
!                     return
!                  end if
!
!               end if
!
!               dpp = -dpp
!
!            end if

         end if
c                                 apply the increment
         ppp(i) = oldpa(i) + dpp

         if (dabs(dpp).gt.fdnorm) fdnorm = dabs(dpp)

         if (lvldif.eq.2) then
c                                 g at the double increpent

            call gsol6 (g3,ppp,nvar)
c                                 single increment
            ppp(i) = oldpa(i) + dpp/2d0
c                                 g at the single increment
            call gsol6 (g1,ppp,nvar)

            dgdp(i) = (4d0*g1- 3d0*g-g3)/dpp

         else
c                                 g at the single increment
            call gsol6 (g1,ppp,nvar)

            dgdp(i) = (g1 - g)/dpp

         end if
c                                 reset ppp
         ppp(i) = oldpa(i)

      end do
c                                 reset pa and make pp:
      pa(1:nstot(rids)) = oldpa(1:nstot(rids))

      call makepp (rids)

      end

      subroutine gsol4 (mode,nvar,ppp,gval,dgdp,fdnorm,bl,bu)
c-----------------------------------------------------------------------
c gsol4 - a shell to call gsol1 from minfxc, ingsol must be called
c         prior to minfxc to initialize solution specific paramters. only
c         called for implicit o/d models. 

c         returns the p0 normalized g for non-equimolar o/d.
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical error 

      integer ids, i, nvar, mode

      double precision ppp(*), gval, dgdp(*), d2s(j3,j3), 
     *                 gord, ddq(j3), norm, fdnorm, bl(*), bu(*)

      double precision zz, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),zz(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      logical outrpc, maxs
      common/ ngg015 /outrpc, maxs

      external gord
c-----------------------------------------------------------------------
      ids = rids
c                                   ppp(1:nord) contains the 
c                                   proportions of the ordered species
c                                   pa(lstot+1:nstot).
c                                   -----------------------------------
c                                   set the remaining proportions
      call ppp2p0 (ppp,ids)

      if (.not.maxs) then

         if (equimo(ids)) then
c                                   analytical derivatives, equimolar o/d
            call gderiv (ids,gval,dgdp,.true.,error)

         else 
c                                   analytical derivatives, non-equimolar
           do i = 1, nvar
              ddq(i) = ppp(i)-p0a(lstot(ids)+i)
           end do

           call gpderi (ids,ddq,gval,dgdp,.true.,error)

        end if

      else
c                                   negentropy minimization:
c                                   will only be called for analytical
c                                   dnu = 0 case.
         call sderiv (ids,gval,dgdp,d2s,.true.)

         if (.not.equimo(ids)) call errdbg ('piggy wee, piggy waa')

      end if

      end

      subroutine ppp2p0 (ppp,ids)
c-----------------------------------------------------------------------
c set pa from p0a given current proportions of the ordered species in
c ppp, used by minfxc
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      integer ids, jd, k

      double precision ppp(*), norm

      logical pin
      common/ cyt2 /pin(j3)

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)
c-----------------------------------------------------------------------
      pa(1:nstot(ids)) = p0a(1:nstot(ids))
c                                   update pa for the change in the 
c                                   proportions of the ordered species
      do k = 1, nord(ids)

         if (.not.pin(k)) cycle

         jd = lstot(ids) + k

         call dpinc (ppp(k)-p0a(jd),k,ids,jd)

      end do

      if (equimo(ids)) return
c                                 non-equimolar normalization
      norm = 1d0

      do k = 1, nord(ids)
         norm = norm +  dnu(k,ids) * (ppp(k)-p0a(lstot(ids)+k))
      end do

      pa(1:nstot(ids)) = pa(1:nstot(ids)) / norm

      end

      subroutine p2yx (id,bad)
c-----------------------------------------------------------------------
c converts the independent endmember fractions to 0-1 bounded barycentric 
c coordinates:

c     number of bounding vertices -> mstot (<m4)
c     number of independent fractions -> nstot (<m14)
c     number of linear constraints -> the number of independent
c        site fractions + closure (<m20)
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical bad, site, comp, clos, inv, zbad

      integer liw, lw, mvar, mcon, nvar, i, jter, iwarn,
     *        iwarn1, iwarn2, lpprob

      double precision scp(k5), tol

      parameter (mvar=m4, mcon=m20, liw=2*mvar+3, 
     *           lw=2*(mcon+1)**2+7*mvar+5*mcon)

      integer ncon, id, is(mvar+mcon), iw(liw), idead, istart

      double precision ax(mcon), clamda(mvar+mcon), wrk(lw), c(mvar),
     *                 a(mcon,mvar), bl(mvar+mcon), bu(mvar+mcon), 
     *                 gopt, sum, b(mcon)

      double precision wmach
      common/ cstmch /wmach(10)

      double precision ayz
      common/ csty2z /ayz(h9,m20,m4)

      double precision ayc
      common/ csty2c /ayc(h9,k5,m4)

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      double precision units, r13, r23, r43, r59, zero, one, r1
      common/ cst59 /units, r13, r23, r43, r59, zero, one, r1

      integer lterm, ksub
      common/ cxt1i /lterm(m11,m10,h9),ksub(m0,m11,m10,h9)

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp

      integer jend
      common/ cxt23 /jend(h9,m14+2)
c                                 solution model names
      character fname*10, aname*6, lname*22
      common/ csta7 /fname(h9),aname(h9),lname(h9)

      external zbad

      save iwarn, iwarn1, iwarn2

      data iwarn, iwarn1, iwarn2/3*0/
c-----------------------------------------------------------------------
      bad = .false.
      inv = .false.

      tol = 1d2*zero
c                                 prismatic, need to invert to vertex fractions
      if (lstot(id).lt.mstot(id)) inv = .true.
c                                 choose constraints:
      if (lorder(id)) then
c                                 decompose to stoichiometric equivaluents
         call makepp (id)

         if (inv) then
c                                 prism
            site = .true.
            comp = .false.
c                                 explicit closure definitely helps
            clos = .true.

            if (.not.equimo(id)) 
     *         call errdbg ('unanticipated prism/non-eq molar/py2x')

c                                 get the disordered p's
            call minfxc (gopt,id,.true.)

         else
c                                get sum (needed for non-eq molar case):
            sum = 0d0

            do i = 1, lstot(id)
c DEBUG691
               if (pp(i).lt.-1d-2) then 
                  write (*,*) 'wtf, p2yx 2',fname(id),' pp ',
     *                        pp(1:lstot(id))
                  bad = .true.
                  return
               end if

               if (pp(i).lt.0d0) pp(i) = 0d0

               sum = sum + pp(i)

            end do

            x(1,1,1:lstot(id)) = pp(1:lstot(id))/sum

            if (pop1(id).gt.1) 
     *         call errdbg ('houston we have a problem, p2yx 1')

         end if

      else

         if (inv) then
c                                 reciprocal and/or relict
c                                 equipartition
            comp = .true.
            clos = .false.
            site = .false.

         else

            x(1,1,1:lstot(id)) = pa(1:lstot(id))

            if (pop1(id).gt.1) 
     *         call errdbg ('houston we have a problem, p2yx 1')

         end if

      end if

      if (.not.inv) return

      nvar = mstot(id)
      ncon = 0
c                                 dummy objective function coefficients
c                                 (only 1 feasible point?)
      c(1:nvar) = 1d0
      bl(1:nvar) = 0d0
      bu(1:nvar) = 1d0

      if (site) then 
c                                 get the site fraction constraints
         call p2zind (pa,b,ncon,id)
c                                 load the fractions
         bl(nvar+1:nvar+ncon) = b(1:ncon)
         bu(nvar+1:nvar+ncon) = b(1:ncon)
c                                 load the ayz constraint matrix
         a(1:ncon,1:nvar) = ayz(id,1:ncon,1:nvar)

      end if

      if (comp) then 
c                                 load the ayc constraint matrix
         a(ncon+1:ncon+icp,1:nvar) = ayc(id,1:icp,1:nvar)
c                                 get the bulk 
         call getscp (scp,sum,id,1)
c
         bl(nvar+ncon+1:nvar+ncon+icp) = scp(1:icp)
         bu(nvar+ncon+1:nvar+ncon+icp) = scp(1:icp)
         ncon = ncon + icp

      end if

      if (clos) then 
c                                 add the closure constraint
         ncon = ncon + 1
         a(ncon,1:nvar) = 1d0
         bl(nvar+ncon) = 1d0
         bu(nvar+ncon) = 1d0

      end if
c                                 cold start
      istart = 0
c                                 feasible point
      lpprob = 1

c     if (lopt(28)) call begtim (9)

      call lpsol (nvar,ncon,a,mcon,bl,bu,c,is,y,jter,gopt,ax,
     *            clamda,iw,liw,wrk,lw,idead,istart,tol,lpprob)

c     if (lopt(28)) call endtim (9,.true.,'p2y inversion')

      if (idead.gt.0) then
c                                 really bad inversion result
         if (iwarn.lt.11) then

            write (*,1010) fname(id),idead

            call prtptx

            if (iwarn.eq.10) call warn (49,0d0,202,'P2YX')

            iwarn = iwarn + 1

         end if

         badinv(id,1) = badinv(id,1) + 1

         bad = .true.

         return

      end if
c                                 the inversion is generally weak, take any answer
c                                 within 10% of closure or positivity
      sum = 0d0

      do i = 1, mstot(id)

         sum = sum + y(i)

      end do

      if (sum.gt.1.1.or.sum.lt.0.9) then
c                                 closure violation
         if (iwarn1.lt.11) then

            write (*,1000) fname(id),(sum-1d0)*1d2

            call prtptx

            if (iwarn1.eq.10) call warn (49,0d0,201,'P2YX')
            
            iwarn1 = iwarn1 + 1

         end if

         bad = .true.

         badinv(id,1) = badinv(id,1) + 1

         return

      end if

      sum = 0d0

      do i = 1, mstot(id)

         if (y(i).lt.0d0) then
c                                 could do another inversion without
c                                 positivity constraint to see if the
c                                 answer really is outside the prism.
            if (y(i).lt.-0.05) bad = .true.

            if (iwarn2.lt.11.and.y(i).lt.-tol) then

                write (*,1020) i,y(i),fname(id)

                if (bad) then
                   write (*,1040)
                else
                   write (*,1030) i
                end if

                call prtptx

                if (iwarn2.eq.10) call warn (49,0d0,203,'P2YX')

                iwarn2 = iwarn2 + 1

            end if

            if (bad) then

               badinv(id,1) = badinv(id,1) + 1 

               return

            end if

            y(i) = 0d0

         else 

            sum = sum + y(i)

         end if

      end do
c                                 renormalize
      y(1:mstot(id)) = y(1:mstot(id))/sum

      badinv(id,2) = badinv(id,2) + 1
c                                 convert the y's to x's
      call sety2x (id)

1000  format (/,'**warning ver201** p2y inversion for ',a,' violates ',
     *       'closure by ',f5.1,'%, the result',/,'will not be used t',
     *       'o compute compositional ranges, large violations may ind',
     *       'icate that',/,'the compositional polyhedron for the mode',
     *       'l does not span all possible model compositions.',/)
1010  format (/,'**warning ver202** p2y inversion for ',a,' failed, ',
     *       'idead = ',i2,', the result',/,'will not be used t',
     *       'o compute compositional ranges.',/)
1020  format (/,'**warning ver203** negative vertex fraction y(',i2,
     *       ') = ',g8.1,' for ',a,'.',/,'Large negative values may ',
     *       'indicate that the compositional polyhedron for the model',
     *     /,'does not span all possible model compositions.',/)
1030  format ('y(',i2,') will be zeroed for computing compositional ',
     *       'ranges.',/)
1040  format ('The composition will not be used to compute',
     *       ' compositional ranges.',/)

      end

      subroutine minfxc (gfinal,ids,mxs)
c-----------------------------------------------------------------------
c optimize solution gibbs energy or configurational entropy at constant 
c composition subject to site fraction constraints.

c returns the p0 normalized g for non-equimolar o/d.

c     number of independent endmember fractions -> <j3
c     number of constraints -> < j3*j5 * 2
c     requires that pp has been loaded in cxt7

c ingsol MUST be called prior to minfxc to initialize solution/p-t
c specific properties!

c this version uses only the ordered species proportions as variables.
c the original version used numeric derivatives with all endmember proportions
c as variables, it persisted as xmnfxc until 16/12/20.
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical mxs

      integer ids, i, j, k, nvar, iter, iwork(m22), itic,
     *        istate(m21), nclin, lord

      double precision ggrd(m19), gordp0, g0, 
     *                 bl(m21), bu(m21), gfinal, ppp(m19), 
     *                 clamda(m21),r(m19,m19),work(m23),
     *                 lapz(m20,m19),xp(m14)

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      logical pin
      common/ cyt2 /pin(j3)

      integer ln,lt,lid,jt,jid
      double precision lc, l0c, jc
      common/ cxt29 /lc(j6,j5,j3,h9),l0c(2,j5,j3,h9),lid(j6,j5,j3,h9),
     *               ln(j3,h9),lt(j5,j3,h9),jc(j3,j5,j3,h9),
     *               jid(j3,j5,j3,h9),jt(j5,j3,h9)

      double precision tsum
      common/ cxt31 /tsum(j5,j3)

      integer ideps,icase,nrct
      common/ cxt3i /ideps(j4,j3,h9),icase(h9),nrct(j3,h9)

      logical mus
      double precision mu
      common/ cst330 /mu(k8),mus

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp

      double precision units, r13, r23, r43, r59, zero, one, r1
      common/ cst59 /units, r13, r23, r43, r59, zero, one, r1

      double precision wmach
      common/ cstmch /wmach(10)

      character fname*10, aname*6, lname*22
      common/ csta7 /fname(h9),aname(h9),lname(h9)

      integer itmxnp, lvlder, lverfy
      common/ ngg020 /itmxnp, lvlder, lverfy

      logical fdchk, cntrl, needfd, fdincs
      common/ cstfds /fdchk, cntrl, needfd, fdincs

      logical outrpc, maxs
      common/ ngg015 /outrpc, maxs

      external gsol4, gordp0
c-----------------------------------------------------------------------
c                                 compute the disordered g for bailouts
      g0 = gordp0(ids)
      nvar = nord(ids)
      maxs = mxs

      if (equimo(ids)) then 
c                                 initialize limit expressions from p0
         call p0limt (ids)
c                                 set initial p values and count the
c                                 the number of non-frustrated od
c                                 variables.
         call pinc0 (ids,lord)

         if (icase(ids).eq.0) then 
c                                 o/d reactions are independent and
c                                 pin settings from pinc0 are valid
c                                 regardless if whether p0 is fully 
c                                 disorderd
            if (lord.eq.0) then 
               gfinal = g0
               return
            end if

         else if (maxs) then
c                                 if maxs then p0 is likely partially 
c                                 ordered, the pin settings from pinc0
c                                 can't be relied upon, a routine could 
c                                 be added to check, but given that the 
c                                 maxs inversion is mostly likely to be
c                                 called for a general composition, the
c                                 lazy solution here is to keep everything
c                                 in:
            pin = .true.
            lord = nvar

         else if (icase(ids).eq.1) then 
c                                 p0 for ~maxs will always correspond to
c                                 the disordered limit, in this case 
c                                 pin for uncorrelated o/d reactions can 
c                                 be relied up. currently the only partly
c                                 correlated case (Omph(GHP)) can also be
c                                 relied upon, but this may change. a special
c                                 test for this and fully correlated cases 
c                                 could be made, but since ~maxs calls are
c                                 only for backup from specis the lazy solution
c                                 is adopted here for the fully correlated case.
            pin = .true.
            lord = nvar

         end if
c                                 variable bounds and local (ppp) variable
c                                 initialization
         do k = 1, nord(ids)

            if (pin(k)) then
               bu(k) = 1d0
               bl(k) = -1d0
            else
               bu(k) = pa(lstot(ids)+k)
               bl(k) = pa(lstot(ids)+k)
            end if

         end do
c                                constraints
         nclin = 0

         do k = 1, nord(ids)
c                                for each constraint
            do i = 1, ln(k,ids)

               nclin = nclin + 1
c                                bounds
               bu(nvar+nclin) = -tsum(i,k)
               bl(nvar+nclin) = -tsum(i,k) - l0c(2,i,k,ids)
c                                coefficients
               lapz(nclin,1:nvar) = 0d0

               do j = 1, jt(i,k,ids)

                  lapz(nclin,jid(j,i,k,ids)-lstot(ids)) = jc(j,i,k,ids)

               end do

               lapz(nclin,k) = -1d0

            end do

         end do
c                                 initialize ppp
         ppp(1:nvar) = pa(lstot(ids)+1:lstot(ids)+nvar)

      else
c                                 not equimolar, ok for HP melt models
c                                 as the endmember fractions are generally
c                                 related to a site fraction
         nclin = 0

         call qlim (bl,bu,lord,ids) 

         if (lord.eq.0) then 
            gfinal = g0
            return
         end if
c                                 initialize ppp
         do i = 1, nvar
            ppp(i) = (bl(i)+bu(i))/2d0
         end do
c                                 need to extract sderivs from gpderi
         if (maxs) call errdbg ('oink di oink oink!!')

      end if
c                                 solution model index
      rids = ids

      itic = 0

      xp(1:nvar) = ppp(1:nvar)

c                                 EPSRF, function precision
10    if (itic.lt.2) then
c                                 LVLDER = 3, all derivatives available
         needfd = .false.
c                                 LVERFY = 1, verify derivatives 
         lverfy = itic

      else
c                                 Derivatives not available; or failed once:
c                                 LVERFY = 0, don't verify
         lverfy = 0
c                                 LVLDER = 0, no derivatives
         needfd = .true.

      end if

      call nlpsol (nvar,nclin,m20,m19,lapz,bl,bu,gsol4,iter,
     *            istate,clamda,gfinal,ggrd,r,ppp,iwork,m22,work,m23)
c                                 if nlpsol returns iter = 0
c                                 it's likely failed, make 2 additional 
c                                 attempts, 1st try numerical verification of 
c                                 the derivatives, 2nd try use only numerical 
c                                 derivatives.
      if (iter.eq.0.and.itic.le.1.and.deriv(ids)) then 

         ppp(1:nvar) = xp(1:nvar)
         itic = itic + 1

         goto 10

      else if (iter.gt.0) then
c                                   set pa to correspond to the final 
c                                   values in ppp.
         call ppp2p0 (ppp,ids)

      end if

      if (.not.maxs) then

         if (itic.gt.0) then 
c                                   check for fuck-ups
            ppp(1:nstot(ids)) = p0a(1:nstot(ids))

            p0a(1:nstot(ids)) = pa(1:nstot(ids))

            gfinal = gordp0(ids)

            p0a(1:nstot(ids)) = ppp(1:nstot(ids))

         end if
c                                 need to call gsol1 here to get 
c                                 total g, gsol4 is not computing 
c                                 the mechanical component?
         if (gfinal.gt.g0.or.iter.eq.0) then 
            gfinal = g0
            pa = p0a
         end if

      end if

      end

      subroutine chfd (mode,n,fdnorm,objf,objfun,bl,bu,grad,x,dummy)
c----------------------------------------------------------------------
c     chfd  computes difference intervals for gradients of
c     f(x). intervals are computed using a procedure that
c     usually requires about two function evaluations if the function
c     is well scaled.  central-difference gradients are obtained as a
c     by-product of the algorithm.

c    assumes the function at x (objf) has been computed on entry.
c----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical done, first

      integer n, info, iter, itmax, j, mode

      double precision fdnorm, objf, bl(n), bu(n), dummy(n), 
     *                 grad(n), x(n), cdest, epsa,
     *                 errbnd, errmax, errmin, f1, f2, fdest, fx,
     *                 h, hcd, hfd, hmax, hmin, hopt, hphi,
     *                 sdest, signh, sumeps, sumsd, xj

      external objfun

      integer lfdset, lvldif
      common/ ngg014 /lvldif, lfdset

      integer itmxnp, lvlder, lverfy
      common/ ngg020 /itmxnp, lvlder, lverfy

      double precision cdint, ctol, dxlim, epsrf, eta, fdint, ftol,
     *                 hcndbd
      common/ ngg021 /cdint, ctol, dxlim, epsrf, eta,
     *                fdint, ftol, hcndbd

      double precision epspt3, epspt5, epspt8, epspt9
      common/ ngg006 /epspt3, epspt5, epspt8, epspt9
c----------------------------------------------------------------------
      itmax = 3
      mode = 0
      fdnorm = 0d0

      do j = 1, n

         xj = x(j)

         sumsd = 0d0
         sumeps = 0d0
         hfd = 0d0
         hcd = 0d0
         hmax = 0d0
         hmin = 1d0/epspt3
         errmax = 0d0
         errmin = 0d0
c                                 set step direction away from the nearest
c                                 bound (without regard to other constraints,
c                                 numder may do this better),
         signh = 1d0
         if (bu(j) + bl(j)- 2d0*xj.lt.0d0) signh = -1d0
c                                 get the difference interval for this element.
         fx = objf
         epsa = epsrf*(1d0+abs(fx))
c                                 find a finite-difference interval by iteration.
         iter = 0
         hopt = 2d0*(1d0+abs(xj))*sqrt(epsrf)
         h = signh*1d1*hopt
         cdest = 0d0
         sdest = 0d0
         first = .true.

         do

            x(j) = xj + h
            call objfun (mode,n,x,f1,dummy,fdnorm,bl,bu)
            if (mode.lt.0) go to 200

            x(j) = xj + h + h
            call objfun(mode,n,x,f2,dummy,fdnorm,bl,bu)
            if (mode.lt.0) go to 200

            call chcore (done,first,epsa,epsrf,fx,info,iter,itmax,cdest,
     *                   fdest,sdest,errbnd,f1,f2,h,hopt,hphi)

            if (done) exit

         end do

         grad(j) = cdest

         sumsd = sumsd + abs(sdest)
         sumeps = sumeps + epsa

         if (hopt.gt.hmax) then
            hmax = hopt
            errmax = errbnd
         end if

         if (hopt.lt.hmin) then
            hmin = hopt
            errmin = errbnd
         end if

         if (info.eq.0) hcd = max(hcd,hphi)

         if (hmin.gt.hmax) then
            hmin = hmax
            errmin = errmax
         end if

         if (4d0*sumeps.lt.hmin*hmin*sumsd) then
            hfd = hmin
            errmax = errmin
         else if (4d0*sumeps.gt.hmax*hmax*sumsd) then
            hfd = hmax
         else
            hfd = 2d0*sqrt(sumeps/sumsd)
            errmax = 2d0*sqrt(sumeps*sumsd)
         end if

         if (hcd.eq.0d0) hcd = 1d1*hfd

         fdnorm = max(fdnorm,hfd)
         hfwd(j) = hfd/(1d0+abs(xj))
         hctl(j) = hcd/(1d0+abs(xj))

         x(j) = xj

      end do
c                                 signal individual increments available:
      lfdset = 2

      return
c                                 sommat agly
200   lfdset = 1
c                                 end of chfd
      end
