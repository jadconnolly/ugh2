      subroutine dummy
      end 

      subroutine minfrc
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

      logical tic, zbad, swap, quit, xref

      integer i, j, nvar, iter, iwork(m22), itic, idif,
     *        ivars(13), istate(m21), idead, nclin, ntot

      double precision ggrd(m19), lapz(m20,m19),gsol1, pinc,
     *                 bl(m21), bu(m21), gfinal, ppp(m19), fac,
     *                 clamda(m21),r(m19,m19),work(m23),rvars(9)
c DEBUG691                    dummies for NCNLN > 0
     *                 ,c(1),cjac(1,1),yt(m4),
     *                 zsite(m10,m11), sum

      external gsol2, gsol1, dummy

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

      data fac/1d-2/

      save fac
c-----------------------------------------------------------------------
      yt = pa

      tic = .true.

      nclin = nz(rids)
      ntot = nstot(rids)

      if (equimo(rids)) then
         nvar = ntot - 1
      else 
         nvar = ntot
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

      itic = 0

10    idead = -1
c                                 EPSRF, function precision
      rvars(1) = (wmach(3))**(0.9)
c                                 FTOL, optimality tolerance
      rvars(2) = (wmach(3))**(0.8)
c                                 CTOL,feasibility tolerance
      rvars(3) = zero
c                                 DXLIM, step limit < nopt(5) leads to bad results
      rvars(4) = 0.05d0
c                                 ETA, linesearch tolerance, low values -> more accurate search 
c                                 -> more function calls, 0.05-.4 seem best
      rvars(5) = 0.225d0
c                                 FDINT, finite difference interval, forward.
      rvars(6) = nopt(49)
c                                 ---------------------------------------------
c                                 ivars(1:10) reserved for flags, counters used by GSOL2
c                                 ---------------------------------------------
c                                 obj call counter
      ivars(3) = 0
c                                 LVLDER, derivative level, default all derivatives available
      ivars(13) = 3

      if (deriv(rids).and.itic.lt.2) then
c                                 LVLDER = 3, all derivatives available
         ivars(13) = 3
c                                 LVERFY = 1, verify derivatives 
         ivars(11) = itic
c                                 flag (if ~0) to force numerical
c                                 finite differences even when 
c                                 derivatives are available
         ivars(6) = 0

      else
c                                 Derivatives not available; or failed once:
c                                 LVERFY = 0, don't verify
         ivars(11) = 0
c                                 LVLDER = 0, no derivatives
         ivars(13) = 0
c                                 Set flag to prevent GSOL2 from returning
c                                 derivatives.
         ivars(6) = 1

      end if

      call nlpsol (nvar,nclin,0,m20,1,m19,lapz,bl,bu,dummy,gsol2,iter,
     *            istate,c,cjac,clamda,gfinal,ggrd,r,ppp,iwork,m22,work,
     *            m23,ivars,rvars,idead)

      if (iter.eq.0.and.idead.eq.0.and.itic.le.1.and.deriv(rids)) then

         pa = yt
c                                 error counter
         itic = itic + 1

         goto 10

      else if (idead.ne.0) then 
    
         write (*,*) 'woana woaba, wanka?'

      else

         if (iter.eq.0) return

      end if
c--------------------------
      sum = 0d0
      do i = 1, nvar
         sum = sum + ppp(i)
         pa(i) = ppp(i)
      end do

      if (nvar.lt.ntot) pa(ntot) = 1d0 - sum
c                                 reject bad site populations
      if (zbad(pa,rids,zsite,fname(rids),.false.,fname(rids))) return

      yt = pa
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
         return
      end if
c                                 save the final QP result
      call savrpc (gfinal,0d0,idif,swap)
c---------------
      if (lopt(54).and..not.swap) then
c                                 scatter in only for nstot-1 gradients
         pinc = 1d0 + nopt(48)
c                                 in case on 1st iteration set refine to 
c                                 to true and then reset to old value on 
c                                 exit
         xref = refine
         refine = .true.

         do i = 1, lstot(rids)

            pa = yt/pinc

            pa(i) = pa(i) + (1d0 - 1d0/pinc)

            if (zbad(pa,rids,zsite,fname(rids),.false.,fname(rids))) 
     *                                                            cycle 
            call makepp (rids)
c                                 if the system is chemically degenerate do
c                                 not allow non-degenerate scatter points
            if (idegen.gt.1000) then

               call getscp (rcp,rsum,rids,1)

               quit = .false.

               do j = 1, idegen
                  if (rcp(idg(j)).ne.0d0) then
                     quit = .true.
                     exit
                  end if
               end do

               if (quit) cycle

            end if
c                                 if logical arg = T use implicit ordering
            gfinal = gsol1 (rids,.true.)
c                                 increment the counter
            call savrpc (gfinal,nopt(48)/2d0,idif,swap)

         end do
c                                 reset refine
         refine = xref

      end if

      end

      subroutine gsol2 (mode,nvar,ppp,gval,dgdp,istart,ivars,rvars)
c-----------------------------------------------------------------------
c function to evaluate gibbs energy of a solution for minfrc. can call 
c either gsol1 with order true or false, true seems to give better results
c presumably because it's using analytical gradients.
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical zbad, saved

      integer i, j, nvar, mode, ivars(*), istart, idif

      double precision ppp(*), gval, dgdp(*), rvars(*),
     *                 gsol1, g, sum1, zsite(m10,m11)

      external gsol1, zbad

      logical mus
      double precision mu
      common/ cst330 /mu(k8),mus

      double precision units, r13, r23, r43, r59, zero, one, r1
      common/ cst59 /units, r13, r23, r43, r59, zero, one, r1

      double precision z, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),z(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      character fname*10, aname*6, lname*22
      common/ csta7 /fname(h9),aname(h9),lname(h9)

      integer jphct
      double precision g2, cp2, c2tot
      common/ cxt12 /g2(k21),cp2(k5,k21),c2tot(k21),jphct

      integer icomp,istct,iphct,icp
      common/ cst6  /icomp,istct,iphct,icp
c-----------------------------------------------------------------------

      integer count
      common/ cstcnt /count

      count = count + 1


      if (lopt(61)) call begtim (2)

      sum1 = 0d0

      do i = 1, nvar
         sum1 = sum1 + ppp(i)
         pa(i) = ppp(i)
      end do

      if (nvar.lt.nstot(rids)) pa(nstot(rids)) = 1d0 - sum1

      if (ksmod(rids).eq.3999) then

         do i = 1, nstot(rids)

            if (pa(i).gt.1d0.or.pa(i).lt.0d0) then

               if (pa(i).gt.1d0.and.pa(i).lt.1d0+zero) then 
                  pa(i) = 1d0
               else if (pa(i).lt.0d0.and.dabs(pa(i)).lt.zero) then
                  pa(i) = 0d0
               else
                  mode = -1
                  return
               end if

            end if

         end do

      end if

      call makepp (rids)

      if (deriv(rids).and.ivars(6).eq.0) then

         call getder (g,dgdp,rids)
c                                 get the bulk composition from pa
         call getscp (rcp,rsum,rids,rids)
c                                 convert dgdp to dg'dp

         do j = 1, icp
c                                 degenerate sys, mu undefined:
            if (isnan(mu(j))) cycle

            do i = 1, nvar
               dgdp(i) = dgdp(i) - dcdp(j,i,rids)*mu(j)
            end do

         end do

      else
c                                 if logical arg = T use implicit ordering
         g = gsol1 (rids,.false.)

      end if

      gval = g

      do i = 1, icp
         if (isnan(mu(i))) cycle
         gval = gval - rcp(i)*mu(i)
      end do

      if (lopt(57).and.ivars(2).ne.0.and.(nvar.lt.nstot(rids).or.
     *    sum1.ge.one.and.sum1.le.1d0+zero).and.rsum.gt.zero) then

         if (zbad(pa,rids,zsite,fname(rids),.false.,fname(rids))) return
c                                 save the composition
         call savrpc (g,nopt(37),idif,saved)

      end if

      if (lopt(61)) call endtim (2,.false.,'Dynamic G')

      end

      subroutine savrpc (g,tol,idif,swap)
c-----------------------------------------------------------------------
c save a dynamic composition/g for the lp solver
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical swap, swapit

      integer i, j, ntot, idif

      double precision g, diff, tol, mindif

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

      if (tol.eq.0d0) then
         swapit = .true.
      else
         swapit = .false.
      end if

      swap = .false.
c                                 degenerate bulk, only 
c                                 save degenerate results:
      if (idegen.gt.1000) then 
      do j = 1, idegen
         if (rcp(idg(j)).gt.0d0.and..not.dispro(idg(j))) then
            if (rcp(idg(j)).lt.zero) then 
               write (*,*) 'wonka ',rcp(idg(j))
            end if
            return
         end if
      end do
      end if

      mindif = 0d0
      idif = 0
c                                 check if duplicate
      do i = jpoint + 1, jphct

         if (jkp(i).eq.rids) then

            diff = 0d0

            do j = 1, ntot
               diff = diff + dabs(pa(j) - zco(icoz(i)+j))
            end do

            if (diff.eq.0d0) then 
c                                 swap if lower g
               swap = .true.

               idif = i

              if (g2(i).gt.g/rsum) then
                  exit
               else
                  return
               end if

            end if

            if (.not.swapit) then

               if (diff.lt.tol) return

            else
c                                 swap non-identical comps
               if (diff.lt.zero) return

            end if

         end if

      end do

      if (.not.swap) then
c                                 increment counters
         jphct = jphct + 1
         icoz(jphct) = zcoct
         zcoct = zcoct + ntot
         idif = jphct

      end if
c                                 lagged speciation quack flag
      quack(idif) = rkwak
c                                 normalize and save the composition
      cp2(1:icomp,idif) = rcp(1:icomp)/rsum
c                                 the solution model pointer
      jkp(idif) = rids
c                                 the refinement point pointer
      hkp(idif) = rkds
c                                 save the normalized g
      g2(idif) = g/rsum
c                                 sum scp(1:icp)
      if (ksmod(rids).eq.39.and.lopt(32).and..not.rkwak) then
c                                 this will renormalize the bulk to a 
c                                 mole of solvent, it's no longer clear to 
c                                 me why this is desireable.
         c2tot(idif) = rsum/rsmo
      else
         c2tot(idif) = rsum
      end if

      quack(idif) = rkwak
c                                 save the endmember fractions
      zco(icoz(idif)+1:icoz(idif)+ntot) = pa(1:ntot)

      end 

      subroutine gsol4 (mode,nvar,ppp,gval,dgdp,istart,ivars,rvars)
c-----------------------------------------------------------------------
c gsol4 - a shell to call gsol1 from minfxc, ingsol must be called
c         prior to minfxc to initialize solution specific paramters. only
c         called for implicit o/d models. 

c         returns the p0 normalized g for non-equimolar o/d.
c-----------------------------------------------------------------------
      implicit none

      include 'perplex_parameters.h'

      logical error 

      integer ids, i, nvar, istart, mode, ivars(*)

      double precision ppp(*), gval, dgdp(*), rvars(*), d2s(j3,j3), 
     *                 gord, ddq(j3), norm

      double precision zz, pa, p0a, x, w, y, wl, pp
      common/ cxt7 /y(m4),zz(m4),pa(m4),p0a(m4),x(h4,mst,msp),w(m1),
     *              wl(m17,m18),pp(m4)

      external gord
c-----------------------------------------------------------------------
      ids = ivars(1)
c                                   ppp(1:nord) contains the 
c                                   proportions of the ordered species
c                                   pa(lstot+1:nstot).
c                                   -----------------------------------
c                                   set the remaining proportions
      call ppp2pa (ppp,ids)

      if (ivars(3).eq.0) then

        if (ivars(6).eq.1) then 
c                                   numerical derivatives
           gval = gord(ids) 

           if (.not.equimo(ids)) then

              norm = 1d0

              do i = 1, nvar
                 norm = norm +  dnu(i,ids) * (ppp(i)-p0a(lstot(ids)+i))
              end do

              gval = gval * norm

           end if

        else if (equimo(ids)) then
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

      subroutine ppp2pa (ppp,ids)
c-----------------------------------------------------------------------
c set pa from p0a given current proportions of the ordered species in
c ppp
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

      integer liw, lw, mvar, mcon, nvar, i, jter, iprint, iwarn,
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
      idead = -1
      iprint = 0
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

      subroutine minfxc (gfinal,ids,maxs)
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

      logical maxs

      integer ids, i, j, k, nvar, iter, iwork(m22), iprint, itic,
     *        ivars(15),istate(m21), idead, nclin, lord

      double precision ggrd(m19), gordp0, g0, fac,
     *                 bl(m21), bu(m21), gfinal, ppp(m19), 
     *                 clamda(m21),r(m19,m19),work(m23),rvars(6),
     *                 lapz(m20,m19)
c DEBUG691                    dummies for NCNLN > 0
     *                 ,c(1),cjac(1,1),xp(m14)

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

      external gsol4, gordp0, dummy
c-----------------------------------------------------------------------
c                                 compute the disordered g for bailouts
      g0 = gordp0(ids)

      fac = 1d-2
      nvar = nord(ids)

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
            fac = 1d0
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
      ivars(1) = ids
c                                 ivars(2) is set by NLP and is
c                                 irrelevant.
c                                 ivars(3) = 1 min g, 0 max entropy
      if (maxs) then 
         ivars(3) = 1
      else 
         ivars(3) = 0
      end if
c                                 flag (if ~0) to force numerical
c                                 finite differences even when 
c                                 derivatives are available
      ivars(6) = 0

      itic = 0

      iprint = 0

      xp(1:nvar) = ppp(1:nvar)

10    idead = -1
c                                 EPSRF, function precision
      rvars(1) = (wmach(3)*fac)**(0.9)
c                                 FTOL, optimality tolerance
      rvars(2) = (wmach(3)*fac)**(0.8)
c                                 CTOL,feasibility tolerance
      rvars(3) = zero
c                                 ETA, step limit < nopt(5) leads to bad results
      rvars(4) = 0.5d0
c                                 DXLIM, linesearch tolerance, low values -> more accurate search 
c                                 -> more function calls, 0.05-.4 seem best
      rvars(5) = 0.225
c                                 FDINT, finite difference interval, forward.
      rvars(6) = nopt(49)
c                                 ---------------------------------------------
c                                 ivars(1:10) reserved for flags, counters used by GSOL2
c                                 ---------------------------------------------
c                                 LVLDER, derivative level, default all derivatives available
      ivars(13) = 3

      if (itic.lt.2) then
c                                 LVLDER = 3, all derivatives available
         ivars(13) = 3
c                                 LVERFY = 1, verify derivatives 
         ivars(11) = itic

      else
c                                 Derivatives not available; or failed once:
c                                 LVERFY = 0, don't verify
         ivars(11) = 0
c                                 LVLDER = 0, no derivatives
         ivars(13) = 0

         ivars(6) = 1

      end if

      call nlpsol (nvar,nclin,0,m20,1,m19,lapz,bl,bu,dummy,gsol4,iter,
     *            istate,c,cjac,clamda,gfinal,ggrd,r,ppp,iwork,m22,work,
     *            m23,ivars,rvars,idead)
c                                 if nlpsol returns iter = 0 and idead 
c                                 = 0, it's likely failed, make 2 additional 
c                                 attempts, 1st try numerical verification of 
c                                 the derivatives, 2nd try use only numerical 
c                                 derivatives.
      if (iter.eq.0.and.idead.eq.0.and.itic.le.1.and.deriv(ids)) then 

         ppp(1:nvar) = xp(1:nvar)
         itic = itic + 1

         goto 10

      else if (iter.gt.0) then
c                                   set pa to correspond to the final 
c                                   values in ppp.
         call ppp2pa (ppp,ids)

      end if

      if (idead.eq.2) then 
         write (*,*) 'minfxc infeasible initial conditions'
      else if (idead.eq.7) then
         write (*,*) 'weak solution'
      else if (idead.eq.7) then
         write (*,*) 'bad derivatives'
      else if (idead.ne.0) then 
         write (*,*) 'sommat else bad',idead
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

      subroutine npchkd (inform,nstate,lvlder,nfun,ngrad,ldcj,
     *                   ldcju,n,ncnln,confun,objfun,needc,bigbnd,epsrf,
     *                   cdint,fdint,fdchk,fdnorm,objf,xnorm,bl,bu,c,c1,
     *                   cjac,cjacu,cjdx,dx,grad,gradu,hforwd,hcntrl,x,
     *                   wrk1,wrk2,iuser,user)
c----------------------------------------------------------------------
c     npchkd  does the following...
c     (1)  computes the objective and constraint values objf and c.
c     (2)  evaluates the user-provided gradients in cjacu and gradu.
c     (3)  counts the missing gradients.
c     (4)  loads the known gradients into grad and cjac.
c     (5)  checks that the known gradients are programmed correctly.
c     (6)  computes the missing gradient elements.
c----------------------------------------------------------------------
      implicit none

      logical centrl, needfd

      integer inform, ldcj, ldcju, lvlder, n,
     *        ncnln, nfun, ngrad, nstate, iuser(*), needc(*),
     *        i, infog, infoj, j, mode, ncset

      double precision bl(n), bu(n), c(*), c1(*), cjac(ldcj,*),
     *                 cjacu(ldcju,*), cjdx(*), dx(n), grad(n),
     *                 gradu(n), hcntrl(*), hforwd(*), user(*),
     *                 wrk1(n+ncnln), wrk2(n+ncnln), x(n), 
     *                 bigbnd, cdint, epsrf, fdchk, fdint, fdnorm,
     *                 objf, xnorm

      external confun, objfun

      integer lfdset, lvldif, ncdiff, nfdiff
      common/ ngg014 /lvldif, ncdiff, nfdiff, lfdset

      double precision epspt3, epspt5, epspt8, epspt9
      common/ ngg006 /epspt3, epspt5, epspt8, epspt9

      integer lvrfyc, jverfy
      common/ ngg015 /lvrfyc, jverfy(4)
c----------------------------------------------------------------------
      infog = 0
      infoj = 0
      nfdiff = 0
      ncdiff = 0
      ncset = n*ncnln

      needfd = lvlder.eq.0 .or. lvlder.eq.2

      if (needfd) call sload (n,-11111d0,gradu,1)
c                                 output the initial value
      iuser(2) = 1

      mode = 2
      call objfun (mode,n,x,objf,gradu,nstate,iuser,user)
      if (mode.lt.0) go to 80

      call dcopy (n,gradu,1,grad,1)
c                                 shut off output for derivative
c                                 evaluation
      iuser(2) = 0

      if (needfd) then

c        count the number of missing gradient elements.

         do 60 j = 1, n
            if (gradu(j).eq.-11111d0) nfdiff = nfdiff + 1
   60    continue

         if (nstate.eq.1) then
            if (nfdiff.eq.0) then
               if (lvlder.eq.0) lvlder = 1
               if (lvlder.eq.2) lvlder = 3
            end if
         end if
      end if

      nfun = nfun + 1
      ngrad = ngrad + 1

c     check whatever gradient elements have been provided.

      if (lvrfyc.ge.0) then

         if (nfdiff.lt.n) then
            call chkgrd (mode,n,bigbnd,epsrf,epspt3,fdchk,objf,
     *                   xnorm,objfun,bl,bu,grad,gradu,dx,x,wrk1,iuser,
     *                   user)
            if (mode.lt.0) go to 80
            infog = mode
         end if
      end if

      needfd = ncdiff.gt.0 .or. nfdiff.gt.0
      if (needfd) then

c        compute the missing gradient elements.

         call chfd (mode,lvlder,n,ncnln,ldcj,ldcju,bigbnd,epsrf,
     *             fdnorm,objf,confun,objfun,needc,bl,bu,c,c1,cjdx,
     *             cjac,cjacu,grad,gradu,hforwd,hcntrl,x,dx,iuser,
     *             user)

         if (mode.lt.0) go to 80

         if (lfdset.gt.0) then
            centrl = lvldif.eq.2
            call npfd (centrl,mode,ldcj,ldcju,n,ncnln,bigbnd,cdint,
     *                fdint,fdnorm,objf,confun,objfun,needc,bl,bu,c,
     *                c1,cjdx,cjac,cjacu,grad,gradu,hforwd,hcntrl,x,
     *                iuser,user)

            if (mode.lt.0) go to 80
         end if
      end if

      inform = infoj + infog
      return

c     the user requested termination.

   80 inform = mode
c                                 end of npchkd
      end


      subroutine chfd (inform,lvlder,n,ncnln,ldcj,ldcju,bigbnd,
     *                 epsrf,fdnorm,objf,confun,objfun,needc,bl,bu,c,
     *                 c1,c2,cjac,cjacu,grad,gradu,hforwd,hcntrl,x,y,
     *                 iuser,user)
c----------------------------------------------------------------------
c     chfd  computes difference intervals for the missing gradients of
c     f(x) and c(x). intervals are computed using a procedure that
c     usually requires about two function evaluations if the function
c     is well scaled.  central-difference gradients are obtained as a
c     by-product of the algorithm.

c     on entry...
c     objf and c contain the problem functions at the point x.
c     an element of cjac or grad not equal to rdummy signifies a known
c     gradient value.  such values are not estimated by differencing.
c     cjacu and gradu have dummy elements in the same positions as
c     cjac and gradu.

c     on exit...
c     cjac and grad contain central-difference derivative estimates.
c     elements of cjacu and gradu are unaltered except for those
c     corresponding to constant derivatives, which are given the same
c     values as cjac or grad.
c----------------------------------------------------------------------
      implicit none

      logical done, first, headng, needed

      integer inform, ldcj, ldcju, lvlder, n, ncnln, iuser(*), needc(*),
     *        i, info, irow1, irow2, iter, itmax, j, mode,
     *        nccnst, ncolj, nfcnst, nstate

      double precision bigbnd, epsrf, fdnorm, objf, bl(n), bu(n), c(*),
     *                 c1(*), c2(*), cjac(ldcj,*),
     *                 cjacu(ldcju,*), grad(n), gradu(n), hcntrl(*),
     *                 hforwd(*), user(*), x(n), y(n),
     *                 biglow, bigupp, cdest, cjdiff, d, dx, epsa,
     *                 errbnd, errmax, errmin, f1, f2, fdest, fx,
     *                 gdiff, h, hcd, hfd, hmax, hmin, hopt, hphi,
     *                 objf2, sdest, signh, stepbl, stepbu, sumeps,
     *                 sumsd, test, xj, yj

      external confun, objfun

      integer lfdset, lvldif, ncdiff, nfdiff
      common/ ngg014 /lvldif, ncdiff, nfdiff, lfdset

      double precision epspt3, epspt5, epspt8, epspt9
      common/ ngg006 /epspt3, epspt5, epspt8, epspt9
c----------------------------------------------------------------------
      inform = 0
      needed = lvlder.eq.0 .or. lvlder.eq.2 .or. lvlder.eq.1 .and.
     *         ncnln.gt.0
      if (.not. needed) return

      if (lfdset.eq.0) then

         nstate = 0
         itmax = 3
         mode = 0

         nccnst = 0
         nfcnst = 0
         headng = .true.

         fdnorm = 0d0

c        for each column of the jacobian augmented by the transpose of
c        the objective gradient, rows irow1 thru irow2 are searched for
c        missing elements.

         irow1 = 1
         irow2 = ncnln + 1
         if (lvlder.eq.1) irow2 = ncnln
         if (lvlder.eq.2) irow1 = ncnln + 1

         biglow = -bigbnd
         bigupp = bigbnd

         if (ncnln.gt.0) call iload (ncnln,0,needc,1)

         do 60 j = 1, n
            xj = x(j)
            ncolj = 0
            sumsd = 0d0
            sumeps = 0d0
            hfd = 0d0
            hcd = 0d0
            hmax = 0d0
            hmin = 1d0/epspt3
            errmax = 0d0
            errmin = 0d0

            stepbl = biglow
            stepbu = bigupp
            if (bl(j).gt.biglow) stepbl = bl(j) - xj
            if (bu(j).lt.bigupp) stepbu = bu(j) - xj

            signh = 1d0
            if (stepbl+stepbu.lt.0d0) signh = -1d0

            do 40 i = irow1, irow2

               if (i.le.ncnln) then
                  test = cjacu(i,j)
               else
                  test = gradu(j)
               end if

               if (test.eq.-11111d0) then

c                 get the difference interval for this element.

                  ncolj = ncolj + 1

                  if (i.le.ncnln) then
                     needc(i) = 1
                     fx = c(i)
                     epsa = epsrf*(1d0+abs(c(i)))
                  else
                     fx = objf
                     epsa = epsrf*(1d0+abs(fx))
                  end if

c                 find a finite-difference interval by iteration.

                  iter = 0
                  hopt = 2d0*(1d0+abs(xj))*sqrt(epsrf)
                  h = signh*1d1*hopt
                  cdest = 0d0
                  sdest = 0d0
                  first = .true.
c                 +                repeat
   20             x(j) = xj + h
                  if (i.le.ncnln) then
                     call confun(mode,ncnln,n,ldcju,needc,x,c1,cjacu,
     *                           nstate,iuser,user)
                     if (mode.lt.0) go to 200
                     f1 = c1(i)
                  else
                     call objfun(mode,n,x,f1,gradu,nstate,iuser,user)
                     if (mode.lt.0) go to 200
                  end if

                  x(j) = xj + h + h
                  if (i.le.ncnln) then
                     call confun(mode,ncnln,n,ldcju,needc,x,c1,cjacu,
     *                           nstate,iuser,user)
                     if (mode.lt.0) go to 200
                     f2 = c1(i)
                  else
                     call objfun(mode,n,x,f2,gradu,nstate,iuser,user)
                     if (mode.lt.0) go to 200
                  end if

                  call chcore (done,first,epsa,epsrf,fx,info,iter,
     *                         itmax,cdest,fdest,sdest,errbnd,f1,f2,h,
     *                         hopt,hphi)
c                 +                until     done
                  if (.not. done) go to 20

                  if (i.le.ncnln) then
                     cjac(i,j) = cdest
                     if (info.eq.1 .or. info.eq.2) then
                        nccnst = nccnst + 1
                        ncdiff = ncdiff - 1
                        cjacu(i,j) = 11111d0
                     end if
                  else
                     grad(j) = cdest
                     if (info.eq.1 .or. info.eq.2) then
                        nfcnst = nfcnst + 1
                        nfdiff = nfdiff - 1
                        gradu(j) = 11111d0
                     end if
                  end if

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
               end if
   40       continue

            if (ncolj.gt.0) then
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
               hforwd(j) = hfd/(1d0+abs(xj))
               hcntrl(j) = hcd/(1d0+abs(xj))
            end if
            x(j) = xj
   60    continue

         if (nccnst+nfcnst.gt.0) then

c           check that the constants have been set properly by
c           evaluating the gradients at a strange (but feasible) point.

            d = 1d0/n

            do 80 j = 1, n
               xj = x(j)
               stepbl = -1d0
               stepbu = 1d0
               if (bl(j).gt.biglow) stepbl = max(stepbl,bl(j)-xj)
               if (bu(j).lt.bigupp .and. bu(j).gt.bl(j))
     *             stepbu = min(stepbu,bu(j)-xj)

               if (stepbl+stepbu.lt.0d0) then
                  y(j) = xj + d*stepbl
               else
                  y(j) = xj + d*stepbu
               end if

               d = 0.97d0 * d
   80       continue

            if (ncnln.gt.0) then
               call iload (ncnln,1,needc,1)
               call confun (mode,ncnln,n,ldcju,needc,y,c2,cjacu,nstate,
     *                     iuser,user)
               if (mode.lt.0) go to 200
            end if

            call objfun (mode,n,y,objf2,gradu,nstate,iuser,user)
            if (mode.lt.0) go to 200

c           loop over each of the elements of  x.

            do 140 j = 1, n
               yj = y(j)
               dx = (x(j)-yj)/2d0
               y(j) = yj + dx

               if (ncnln.gt.0) then
                  ncolj = 0
                  do 100 i = 1, ncnln
                     if (cjacu(i,j).eq.11111d0) then
                        needc(i) = 1
                        ncolj = ncolj + 1
                     else
                        needc(i) = 0
                     end if
  100             continue

                  if (ncolj.gt.0) then
                     call confun (mode,ncnln,n,ldcju,needc,y,c1,cjacu,
     *                           nstate,iuser,user)
                     if (mode.lt.0) go to 200

                     do 120 i = 1, ncnln
                        if (needc(i).eq.1) then
                           cjdiff = (c1(i)-c2(i))/dx
                           if (cjdiff.eq.cjac(i,j)) then
                              cjacu(i,j) = cjdiff
                           else
                              cjacu(i,j) = -11111d0
                              nccnst = nccnst - 1
                              ncdiff = ncdiff + 1
                           end if
                        end if
  120                continue
                  end if
               end if

c              check the objective gradient element.

               if (gradu(j).eq.11111d0) then

                  call objfun (mode,n,y,f1,gradu,nstate,iuser,user)
                  if (mode.lt.0) go to 200

                  gdiff = (f1-objf2)/dx
                  if (gdiff.eq.grad(j)) then
                     gradu(j) = gdiff
                  else
                     gradu(j) = -11111d0
                     nfdiff = nfdiff + 1
                     nfcnst = nfcnst - 1
                  end if
               end if

               y(j) = yj
  140       continue

            if (ncdiff.eq.0 .and. lvlder.lt.2) then
               if (lvlder.eq.0) lvlder = 2
               if (lvlder.eq.1) lvlder = 3
            end if

            if (nfdiff.eq.0 .and. lvlder.ne.1) then
               if (lvlder.eq.0) lvlder = 1
               if (lvlder.eq.2) lvlder = 3
            end if
         end if
      else if (lfdset.eq.2) then

c        the user has supplied hforwd and hcntrl.
c        check for wild values.

         do 160 j = 1, n
            if (hforwd(j).le.0d0) then
               hforwd(j) = epspt5
            end if
  160    continue
         do 180 j = 1, n
            if (hcntrl(j).le.0d0) then
               hcntrl(j) = epspt3
            end if
  180    continue
      end if

      return

  200 inform = mode
c                                 end of chfd
      end
