      subroutine lpsol (n,nclin,a,lda,bl,bu,cvec,istate,x,iter,obj,ax,
     *                  clamda,iw,leniw,w,lenw,ifail,istart,tol,lpprob)
c----------------------------------------------------------------------
c     lpsol solves (may also be called as the fp problem)

c           minimize               c' x

c                                 ( x)
c           subject to    bl  .le.(  ).ge.  bu,
c                                 (ax)

c     where a is a constant nclin by n matrix.
c     the feasible region is defined by a mixture of linear equality or
c     inequality constraints on x.

c     n - the number of variables (dimension of x).
c     nclin - the number of general linear constraints (rows of a).
c----------------------------------------------------------------------
      implicit none

      character prbtyp*2, start*4, msg*6

      logical cold, cset, done, found, halted, hot,
     *        rowerr, rset, unitq, vertex, warm

      integer istart, lpprob, ifail, iter, lda, leniw,
     *        lenw, n, nclin, istate(n+nclin), iw(leniw),
     *        ianrmj, inform, it, itmax, j, jinf, jmax,
     *        lanorm, lcq, ld, ldh, ldr, lfeatu, lgq, litotl,
     *        lkactv, lkx, llptyp, lq, lr, lrlam, lt, lwrk,
     *        lwtinf, lwtotl, minact, minfxd,
     *        nact1, nactiv, nartif, ncnln, nctotl, 
     *        nfree, ngq, nmoved, nrejtd, nrz, numinf, nviol, nz

      double precision a(lda,*), ax(*), bl(n+nclin), bu(n+nclin), tol, 
     *                 clamda(n+nclin), cvec(*), w(lenw), x(n), obj, 
     *                 amin, condmx, errmax, feamax, feamin,
     *                 xnorm, dnrm2

      external dnrm2

      double precision wmach
      common/ cstmch /wmach(10)

      integer loclc
      common/ ngg003 /loclc(20)

      integer ldt, ldq, ncolt
      common/ ngg004 /ldt, ncolt, ldq

      integer itnfix, kdegen, ndegen, nfix
      double precision tolinc, tolx0
      common/ ngg005 /tolx0, tolinc, kdegen, ndegen, itnfix, nfix(2)

      double precision epspt3, epspt5, epspt8, epspt9
      common/ ngg006 /epspt3, epspt5, epspt8, epspt9

      logical prnt
      integer isdel, jadd, jdel
      double precision alfa, trulam
      common/ ngg007 /alfa, trulam, isdel, jdel, jadd, prnt

      double precision asize, dtmax, dtmin
      common/ ngg008 /asize, dtmax, dtmin

      integer itmax1, itmax2, kchk, kcycle, lcrash, lprob, 
     *        maxact, mxfree, maxnz, mm, nn, nnclin
      common/ ngg010 /itmax1, itmax2, kchk, kcycle, lcrash, lprob, 
     *                maxact, mxfree, maxnz, mm, nn, nnclin

      double precision bigbnd, bigdx, bndlow, bndupp, tolact, tolfea, 
     *                 tolrnk
      common/ ngg011 /bigbnd, bigdx, bndlow, bndupp,
     *                tolact, tolfea, tolrnk
c----------------------------------------------------------------------
c                                 parameters set by arguments
c                                 istart - 0 - cold start, 1 - warm start, 2 - hot (no benefit)
      lcrash = istart
c                                 tol - feasibility tolerance
      tolfea = tol
c                                 problem type 1 - fp, 2 - lp
      lprob = lpprob
      llptyp = lprob
c                                 f(n) parameters
      itmax1 = max(50,5*(n+nclin))
      maxact = max(1,min(n,nclin))
      maxnz = n
      mxfree = n
      nctotl = n + nclin

      if (nclin.lt.n) then
         mxfree = nclin + 1
         maxnz = mxfree
      end if

      inform = 0
      iter = 0
      condmx = max(1d0/epspt5,1d2)

c     set parameters determined by the problem type.

      if (llptyp.eq.1) then
         prbtyp = 'fp'
         cset = .false.
      else if (llptyp.eq.2) then
         prbtyp = 'lp'
         cset = .true.
      end if

c     if a linear program is being solved and the matrix of general
c     constraints has fewer rows than columns, i.e.,  nclin.lt.n,
c     a non-zero value is known for minfxd.  note that in this case,
c     vertex must be set .true..

      vertex = nclin.lt.n

      minfxd = n - mxfree
      minact = mxfree - maxnz

      ldt = max(maxnz,maxact)
      ncolt = mxfree
      if (nclin.eq.0) then
         ldq = 1
      else
         ldq = max(1,mxfree)
      end if

      ldr = ldt
      ncnln = 0
      ldh = 1
      mm = 0
c                                 cold start:  x may be provided, but 
c                                 in perplex it isn't and therefore 
c                                 x is initialized below for cold.
c                                 warm start:  initial working set is in istate.
c                                 hot  start:  work arrays iw and w have 
c                                 been the first three elements of iw contain details
c                                 dimensions of the initial working set. in perplex
c                                 warm is set, but the start is hot. warm start is 
c                                 only used for static composition optimizations.
      if (lcrash.eq.0) then
         start = 'cold'
      else if (lcrash.eq.1) then
         lcrash = 1
         start  = 'warm'
      else if (lcrash.eq.2) then
         start = 'hot '
      end if

      cold = lcrash.eq.0
      warm = lcrash.eq.1
      hot = lcrash.eq.2

c     allocate remaining work arrays.

      litotl = 3
      lwtotl = 0
      call lploc (cset,n,nclin,litotl,lwtotl)

      lkactv = loclc(1)
      lkx = loclc(2)

      lfeatu = loclc(3)
      lanorm = loclc(4)
      ld = loclc(7)
      lgq = loclc(8)
      lcq = loclc(9)
      lrlam = loclc(10)
      lr = loclc(11)
      lt = loclc(12)
      lq = loclc(13)
      lwtinf = loclc(14)
      lwrk = loclc(15)

c     define the initial feasibility tolerances in clamda.

      if (tolfea.gt.0d0) call sload (n+nclin,(tolfea),w(lfeatu),1)

      call cmdgen ('i',n,nclin,
     *             nmoved,iter,numinf,istate,bl,bu,clamda,
     *             w(lfeatu),x)

      if (cold .or. warm) then

c                                 initialize istate, x, obj
         if (cold) x(1:n) = 0d0
         ax(1:nclin) = 0d0
         w(loclc(5):loclc(5)+nclin-1) = 0d0
c                                 cold or warm start. just about 
c                                 everything must be initialized.
c        the exception is istate during a warm start.

         ianrmj = lanorm

         do j = 1, nclin
            w(ianrmj) = dnrm2 (n,a(j,1),lda)
            ianrmj = ianrmj + 1
         end do

         if (nclin.gt.0) call scond (nclin,w(lanorm),1,asize,amin)

         call scond (nctotl,w(lfeatu),1,feamax,feamin)
         call dcopy (nctotl,w(lfeatu),1,w(lwtinf),1)
         call dscal (nctotl,1d0/feamin,w(lwtinf),1)

         call cmcrsh (start,vertex,nclin,nctotl,nactiv,nartif,nfree,n,
     *               lda,istate,iw(lkactv),iw(lkx),bigbnd,tolact,a,ax,
     *               bl,bu,clamda,x,w(lgq),w(lwrk))

c        compute the tq factorization of the working set matrix.

         unitq = .true.
         nz = nfree

         if (nactiv.gt.0) then
            it = nactiv + 1
            nact1 = nactiv
            nactiv = 0
            ngq = 0

            call rzadds (unitq,vertex,1,nact1,it,nactiv,nartif,nz,nfree,
     *                   nrejtd,ngq,n,ldq,lda,ldt,istate,iw(lkactv),
     *                   iw(lkx),condmx,a,w(lt),w(lgq),w(lq),w(lwrk),
     *                   w(ld),w(lrlam))
         end if

      else if (hot) then

c        arrays  iw  and  w  have been defined in a previous run.
c        the first three elements of  iw  are  unitq,  nfree and nactiv.

         unitq = iw(1).eq.1
         nfree = iw(2)
         nactiv = iw(3)
         nz = nfree - nactiv

      end if

      if (cset) then

c        install the transformed linear term in cq.

         call dcopy (n,cvec,1,w(lcq),1)
         call cmqmul (6,n,nz,nfree,ldq,unitq,iw(lkx),w(lcq),w(lq),
     *               w(lwrk))
      end if

      rset = .false.
      itmax = itmax2
      jinf = 0

c     +    take your pick when minimizing the sum of infeasibilities:
c     +    nrz    =  nz  implies steepest-descent in the two-norm.
c     +    nrz    =  0   implies steepest-descent in the infinity norm.
      nrz = 0

c     repeat               (until working set residuals are acceptable)

c     move x onto the constraints in the working set.

   40 call cmsetx (rowerr,unitq,nclin,nactiv,nfree,nz,n,ldq,lda,ldt,
     *            istate,iw(lkactv),iw(lkx),jmax,errmax,xnorm,a,ax,bl,
     *            bu,w(lfeatu),w(lt),x,w(lq),w(ld),w(lwrk))

      if (rowerr) then
         msg = 'infeas'
         numinf = 1
         obj = errmax
         go to 60
      end if

      call lpcore (prbtyp,msg,cset,rset,unitq,iter,itmax,
     *             jinf,nviol,n,nclin,lda,nactiv,nfree,nrz,nz,istate,
     *             iw(lkactv),iw(lkx),obj,numinf,xnorm,a,ax,bl,bu,
     *             cvec,clamda,w(lfeatu),x,w)

      found = msg.eq.'feasbl' .or. msg.eq.'optiml' .or. msg .eq.
     *        'weak  ' .or. msg.eq.'unbndd' .or. msg.eq.'infeas'
      halted = msg.eq.'itnlim'

      if (found) call cmdgen ('optimal',n,nclin,nmoved,iter,numinf,
     *                        istate,bl,bu,clamda,w(lfeatu),x)

      done = found .and. nviol.eq.0 .and. nmoved.eq.0

      if (.not. (done .or. halted)) go to 40
c                                 set clamda for hot start
c                                 and or yclos routines 
      call cmprnt (nfree,n,nclin,nctotl,nactiv,iw(lkactv),iw(lkx),
     *             clamda,w(lrlam))
c                                 also set for hot start
      iw(1) = 0
      if (unitq) iw(1) = 1
      iw(2) = nfree
      iw(3) = nactiv

   60 if (msg.eq.'optiml') then
         inform = 0
      else if (msg.eq.'feasbl') then
         inform = 0
      else if (msg.eq.'weak  ') then
         inform = 1
      else if (msg.eq.'unbndd') then
         inform = 2
      else if (msg.eq.'infeas') then
         inform = 3
      else if (msg.eq.'itnlim') then
         inform = 4
      else if (msg.eq.'errors') then
         inform = 6
      else if (msg.eq.'noprob') then
         inform = 7
      end if

      if (inform.ge.0) then

         ifail = inform

         if (ifail.lt.3) ifail = 0

         if (ifail.lt.4) then
            istart = 2
         else
            istart = 0
         end if

      else

         call errdbg ('wanola')

      end if
c                                 end of lpsol
      end

      subroutine cmdgen (job,n,nclin,nmoved,iter,numinf,istate,
     *                   bl,bu,featol,featlu,x)
c----------------------------------------------------------------------
c     cmdgen does most of the manoeuvres associated with degeneracy.
c     the degeneracy-resolving strategy operates in the following way.

c     over a cycle of iterations, the feasibility tolerance featol
c     increases slightly (from tolx0 to tolx1 in steps of tolinc).
c     this ensures that all steps taken will be positive.

c     after kdegen consecutive iterations, variables within
c     featol of their bounds are set exactly on their bounds and x is
c     recomputed to satisfy the general constraints in the working set.
c     featol is then reduced to tolx0 for the next cycle of iterations.

c     featlu  is the array of user-supplied feasibility tolerances.
c     featol  is the array of current feasibility tolerances.

c     if job = 'i', cmdgen initializes the parameters in
c     common block ngg005:

c     tolx0   is the minimum (scaled) feasibility tolerance.
c     tolx1   is the maximum (scaled) feasibility tolerance.
c     tolinc  is the scaled increment to the current featol.
c     kdegen  is the expand frequency (specified by the user).
c             it is the frequency of resetting featol to (scaled) tolx0.
c     ndegen  counts the number of degenerate steps (incremented
c             by cmchzr).
c     itnfix  is the last iteration at which a job = 'e' or 'o' entry
c             caused an x to be put on a constraint.
c     nfix(j) counts the number of times a job = 'o' entry has
c             caused the variables to be placed on the working set,
c             where j=1 if infeasible, j=2 if feasible.

c     tolx0*featlu and tolx1*featlu are both close to the feasibility
c     tolerance featlu specified by the user.  (they must both be less
c     than featlu.)

c     if job = 'e',  cmdgen has been called after a cycle of kdegen
c     iterations.  constraints in the working set are examined to see if
c     any are off their bounds by an amount approaching featol.  nmoved
c     returns how many.  if nmoved is positive,  x  is moved onto the
c     constraints in the working set.  it is assumed that the calling
c     routine will then continue iterations.

c     if job = 'o',  cmdgen is being called after a subproblem has been
c     judged optimal, infeasible or unbounded.  constraint violations
c     are examined as above.
c----------------------------------------------------------------------
      implicit none

      character job

      integer iter, n, nclin, nmoved, numinf, istate(n+nclin), is, j, 
     *        maxfix

      double precision bl(n+nclin), bu(n+nclin), d, epsmch, tolx1, tolz,
     *                 featlu(n+nclin), featol(n+nclin), x(n)

      double precision wmach
      common/ cstmch /wmach(10)

      integer itnfix, kdegen, ndegen, nfix
      double precision tolinc, tolx0
      common/ ngg005 /tolx0, tolinc, kdegen, ndegen, itnfix, nfix(2)

      save              tolz
c----------------------------------------------------------------------
      nmoved = 0
      if (job.eq.'i') then

c        job = 'initialize'.
c        initialize at the start of each linear problem.
c        kdegen is the expand frequency and
c        featlu are the feasibility tolerances.
c        they are not changed.

         epsmch = wmach(3)

         ndegen = 0
         itnfix = 0
         nfix(1) = 0
         nfix(2) = 0
         tolx0 = 0.5d0
         tolx1 = 0.99d0
         tolz = epsmch**0.6d0

         if (kdegen.lt.9999999) then
            tolinc = (tolx1-tolx0)/kdegen
         else
            tolinc = 0d0
         end if

         do j = 1, n + nclin
            featol(j) = tolx0*featlu(j)
         end do

      else

c        job = 'end of cycle' or 'optimal'.
c        initialize local variables maxfix and tolz.

         maxfix = 2

         if (job.eq.'o') then

c           job = 'optimal'.
c           return with nmoved = 0 if the last call was at the same
c           iteration,  or if there have already been maxfix calls with
c           the same state of feasibility.

            if (itnfix.eq.iter) return
            if (numinf.gt.0) then
               j = 1
            else
               j = 2
            end if

            if (nfix(j).ge.maxfix) return
            nfix(j) = nfix(j) + 1
         end if

c        reset featol to its minimum value.

         do 40 j = 1, n + nclin
            featol(j) = tolx0*featlu(j)
   40    continue

c        count the number of times a variable is moved a nontrivial
c        distance onto its bound.

         itnfix = iter

         do 60 j = 1, n
            is = istate(j)
            if (is.gt.0 .and. is.lt.4) then
               if (is.eq.1) then
                  d = abs(x(j)-bl(j))
               else
                  d = abs(x(j)-bu(j))
               end if

               if (d.gt.tolz) nmoved = nmoved + 1
            end if
   60    continue

      end if
c                                 end of cmdgen
      end

      subroutine cmcrsh(start,vertex,nclin,nctotl,nactiv,nartif,nfree,n,
     *                  lda,istate,kactiv,kx,bigbnd,tolact,a,ax,bl,bu,
     *                  featol,x,wx,work)
c-----------------------------------------------------------------------
c     cmcrsh  computes the quantities  istate (optionally),  kactiv,
c     nactiv,  nz  and  nfree  associated with the working set at x.
c
c     the computation depends upon the value of the input parameter
c     start,  as follows...
c
c     start = 'cold'  an initial working set will be selected. first,
c                     nearly-satisfied or violated bounds are added.
c                     next,  general linear constraints are added that
c                     have small residuals.
c
c     start = 'warm'  the quantities kactiv, nactiv and nfree are
c                     initialized from istate,  specified by the user.
c
c     if vertex is true, an artificial vertex is defined by fixing some
c     variables on their bounds.  infeasible variables selected for the
c     artificial vertex are fixed at their nearest bound.  otherwise,
c     the variables are unchanged.
c
c     values of istate(j)....
c
c        - 2         - 1         0           1          2         3
c     a'x lt bl   a'x gt bu   a'x free   a'x = bl   a'x = bu   bl = bu
c-----------------------------------------------------------------------
      implicit none 

      double precision bigbnd, tolact
      integer lda, n, nactiv, nartif, nclin, nctotl, nfree
      logical vertex
      character*4       start

      double precision a(lda,*), ax(*), bl(nctotl), bu(nctotl),
     *                  featol(nctotl), work(n), wx(n), x(n)
      integer istate(nctotl), kactiv(n), kx(n)

      double precision b1, b2, biglow, bigupp, colmin, colsiz, flmax,
     *                  residl, resl, resmin, resu, tol, toobig
      integer i, imin, is, j, jfix, jfree, jmin, k

      double precision ddot
      external ddot

      double precision wmach
      common/ cstmch /wmach(10)
c-----------------------------------------------------------------------
      flmax = wmach(7)
      biglow = -bigbnd
      bigupp = bigbnd

c     move the variables inside their bounds.

      do 20 j = 1, n
         b1 = bl(j)
         b2 = bu(j)
         tol = featol(j)

         if (b1.gt.biglow) then
            if (x(j).lt.b1-tol) x(j) = b1
         end if

         if (b2.lt.bigupp) then
            if (x(j).gt.b2+tol) x(j) = b2
         end if
   20 continue

      call dcopy (n,x,1,wx,1)

      nfree = n
      nactiv = 0
      nartif = 0

      if (start.eq.'cold') then
         do 40 j = 1, nctotl
            istate(j) = 0
            if (bl(j).eq.bu(j)) istate(j) = 3
   40    continue
c
      else if (start.eq.'warm') then
         do 60 j = 1, nctotl
            if (istate(j).gt.3 .or. istate(j).lt.0) istate(j) = 0
            if (bl(j).ne.bu(j) .and. istate(j).eq.3) istate(j) = 0
   60    continue
      end if

c     define nfree and kactiv.
c     ensure that the number of bounds and general constraints in the
c     working set does not exceed n.

      do 80 j = 1, nctotl
         if (nactiv.eq.nfree) istate(j) = 0

         if (istate(j).gt.0) then
            if (j.le.n) then
               nfree = nfree - 1

               if (istate(j).eq.1) then
                  wx(j) = bl(j)
               else if (istate(j).ge.2) then
                  wx(j) = bu(j)
               end if
            else
               nactiv = nactiv + 1
               kactiv(nactiv) = j - n
            end if
         end if
   80 continue

c     if a cold start is required,  attempt to add as many
c     constraints as possible to the working set.

      if (start.eq.'cold') then

c        see if any bounds are violated or nearly satisfied.
c        if so,  add these bounds to the working set and set the
c        variables exactly on their bounds.

         j = n
c        +       while (j .ge. 1  .and.  nactiv.lt.nfree) do
  100    if (j.ge.1 .and. nactiv.lt.nfree) then
            if (istate(j).eq.0) then
               b1 = bl(j)
               b2 = bu(j)
               is = 0
               if (b1.gt.biglow) then
                  if (wx(j)-b1.le.(1d0+abs(b1))*tolact) is = 1
               end if
               if (b2.lt.bigupp) then
                  if (b2-wx(j).le.(1d0+abs(b2))*tolact) is = 2
               end if
               if (is.gt.0) then
                  istate(j) = is
                  if (is.eq.1) wx(j) = b1
                  if (is.eq.2) wx(j) = b2
                  nfree = nfree - 1
               end if
            end if
            j = j - 1
            go to 100
c           +       end while
         end if

c        the following loop finds the linear constraint (if any) with
c        smallest residual less than or equal to tolact  and adds it
c        to the working set.  this is repeated until the working set
c        is complete or all the remaining residuals are too large.

c        first, compute the residuals for all the constraints not in the
c        working set.

         if (nclin.gt.0 .and. nactiv.lt.nfree) then
            do 120 i = 1, nclin
               if (istate(n+i).le.0) ax(i) = ddot (n,a(i,1),lda,wx)
  120       continue

            is = 1
            toobig = tolact + tolact

c           +          while (is.gt.0  .and.  nactiv.lt.nfree) do
  140       if (is.gt.0 .and. nactiv.lt.nfree) then
               is = 0
               resmin = tolact

               do 160 i = 1, nclin
                  j = n + i
                  if (istate(j).eq.0) then
                     b1 = bl(j)
                     b2 = bu(j)
                     resl = toobig
                     resu = toobig
                     if (b1.gt.biglow) resl = abs(ax(i)-b1)/(1d0+abs(b1)
     *                                       )
                     if (b2.lt.bigupp) resu = abs(ax(i)-b2)/(1d0+abs(b2)
     *                                       )
                     residl = min(resl,resu)
                     if (residl.lt.resmin) then
                        resmin = residl
                        imin = i
                        is = 1
                        if (resl.gt.resu) is = 2
                     end if
                  end if
  160          continue
c
               if (is.gt.0) then
                  nactiv = nactiv + 1
                  kactiv(nactiv) = imin
                  j = n + imin
                  istate(j) = is
               end if
               go to 140
c              +          end while
            end if
         end if
      end if

      if (vertex .and. nactiv.lt.nfree) then

c        find an initial vertex by temporarily fixing some variables.

c        compute lengths of columns of selected linear constraints
c        (just the ones corresponding to variables eligible to be
c        temporarily fixed).

         do 200 j = 1, n
            if (istate(j).eq.0) then
               colsiz = 0d0
               do 180 k = 1, nclin
                  if (istate(n+k).gt.0) colsiz = colsiz + abs(a(k,j))
  180          continue
               work(j) = colsiz
            end if
  200    continue
c
c        find the  nartif  smallest such columns.
c        this is an expensive loop.  later we can replace it by a
c        4-pass process (say), accepting the first col that is within
c        t  of  colmin, where  t = 0.0, 0.001, 0.01, 0.1 (say).

c        +       while (nactiv.lt.nfree) do
  220    if (nactiv.lt.nfree) then
            colmin = flmax
            do 240 j = 1, n
               if (istate(j).eq.0) then
                  if (nclin.eq.0) go to 260
                  colsiz = work(j)
                  if (colmin.gt.colsiz) then
                     colmin = colsiz
                     jmin = j
                  end if
               end if
  240       continue
            j = jmin

c           fix x(j) at its current value.

  260       istate(j) = 4
            nartif = nartif + 1
            nfree = nfree - 1
            go to 220
c           +       end while
         end if
      end if

      jfree = 1
      jfix = nfree + 1
      do 280 j = 1, n
         if (istate(j).le.0) then
            kx(jfree) = j
            jfree = jfree + 1
         else
            kx(jfix) = j
            jfix = jfix + 1
         end if
  280 continue
c                                 end of cmcrsh
      end

      subroutine cmsetx (rowerr,unitq,nclin,nactiv,nfree,nz,n,ldq,lda,
     *                  ldt,istate,kactiv,kx,jmax,errmax,xnorm,a,ax,bl,
     *                  bu,featol,t,x,q,p,work)
c----------------------------------------------------------------------
c     cmsetx  computes the point on a working set that is closest in the
c     least-squares sense to the input vector x.
c     if the computed point gives a row error of more than the
c     feasibility tolerance, an extra step of iterative refinement is
c     used.  if  x  is still infeasible,  the logical variable rowerr
c     is set.
c----------------------------------------------------------------------
      implicit none

      double precision errmax, xnorm
      integer jmax, lda, ldq, ldt, n, nactiv, nclin, nfree, nz
      logical rowerr, unitq

      double precision a(lda,*), ax(*), bl(n+nclin), bu(n+nclin),
     *                  featol(n+nclin), p(n), q(ldq,*), t(ldt,*),
     *                  work(n), x(n)
      integer istate(n+nclin), kactiv(n), kx(n)

      double precision bnd
      integer i, is, j, k, ktry

      double precision ddot, dnrm2
      integer idamax
      external ddot, dnrm2, idamax
c----------------------------------------------------------------------
c     move  x  onto the simple bounds in the working set.

      do 20 k = nfree + 1, n
         j = kx(k)
         is = istate(j)
         bnd = bl(j)
         if (is.ge.2) bnd = bu(j)
         if (is.ne.4) x(j) = bnd
   20 continue

c     move  x  onto the general constraints in the working set.
c     ntry  attempts are made to get acceptable row errors.

      ktry = 1
      jmax = 1
      errmax = 0d0

c     repeat
   40 if (nactiv.gt.0) then

c        set work = residuals for constraints in the working set.
c        solve for p, the smallest correction to x that gives a point
c        on the constraints in the working set.  define  p = y*(py),
c        where  py  solves the triangular system  t*(py) = residuals.

         do 60 i = 1, nactiv
            k = kactiv(i)
            j = n + k
            bnd = bl(j)
            if (istate(j).eq.2) bnd = bu(j)
            work(nactiv-i+1) = bnd - ddot (n,a(k,1),lda,x)
   60    continue

         call dtrsv ('u','n','n',nactiv,t(1,nz+1),ldt,work)
         call sload (n,0d0,p,1)
         call dcopy (nactiv,work,1,p(nz+1),1)

         call cmqmul(2,n,nz,nfree,ldq,unitq,kx,p,q,work)
         call daxpy (n,1d0,p,1,x,1)
      end if

c     compute the 2-norm of  x.
c     initialize  ax  for all the general constraints.

      xnorm = dnrm2 (n,x,1)
      if (nclin.gt.0) call dgemv ('n',nclin,n,1d0,a,lda,x,0d0,ax)

c     check the row residuals.

      if (nactiv.gt.0) then
         do 80 k = 1, nactiv
            i = kactiv(k)
            j = n + i
            is = istate(j)
            if (is.eq.1) work(k) = bl(j) - ax(i)
            if (is.ge.2) work(k) = bu(j) - ax(i)
   80    continue

         jmax = idamax(nactiv,work)
         errmax = abs(work(jmax))
      end if

      ktry = ktry + 1
c     until    (errmax .le. featol(jmax) .or. ktry.gt.ntry
      if (.not. (errmax.le.featol(jmax) .or. ktry.gt.5)) go to 40

      rowerr = errmax.gt.featol(jmax)
c                                 end of cmsetx
      end

      subroutine lploc (cset,n,nclin,litotl,lwtotl)
c----------------------------------------------------------------------
c lploc allocates the addresses of the work arrays for lpcore.
c----------------------------------------------------------------------
      implicit none

      logical cset

      integer litotl, lwtotl, n, nclin, lad, lanorm, lcq, ld, 
     *        lencq, lenq, lenrt, lfeatu, lgq, lkactv, lkx, lq, lr, 
     *        lrlam, lt, lwrk, lwtinf, miniw, minw

      integer loclc
      common/ ngg003 /loclc(20)

      integer ldt, ldq, ncolt
      common/ ngg004 /ldt, ncolt, ldq
c----------------------------------------------------------------------
c     refer to the first free space in the work arrays.

      miniw = litotl + 1
      minw = lwtotl + 1

c     integer workspace.

      lkactv = miniw
      lkx = lkactv + n
      miniw = lkx + n

c     real workspace.
c     assign array lengths that depend upon the problem dimensions.

      lenrt = ldt*ncolt
      if (nclin.eq.0) then
         lenq = 0
      else
         lenq = ldq*ldq
      end if
c
      if (cset) then
         lencq = n
      else
         lencq = 0
      end if

c     we start with arrays that can be preloaded by smart users.

      lfeatu = minw
      minw = lfeatu + nclin + n

c     next comes stuff used by  lpcore

      lanorm = minw
      lad = lanorm + nclin
      ld = lad + nclin
      lgq = ld + n
      lcq = lgq + n
      lrlam = lcq + lencq
      lr = lrlam + n
      lt = lr
      lq = lt + lenrt
      lwtinf = lq + lenq
      lwrk = lwtinf + n + nclin
      minw = lwrk + n + nclin

c     load the addresses in loclc.

      loclc(1) = lkactv
      loclc(2) = lkx

      loclc(3) = lfeatu
      loclc(4) = lanorm
      loclc(5) = lad

      loclc(7) = ld
      loclc(8) = lgq
      loclc(9) = lcq
      loclc(10) = lrlam
      loclc(11) = lr
      loclc(12) = lt
      loclc(13) = lq
      loclc(14) = lwtinf
      loclc(15) = lwrk

      litotl = miniw - 1
      lwtotl = minw - 1
c                                 end of lploc
      end

      subroutine lpcore (prbtyp,msg,cset,rset,unitq,iter,
     *                   itmax,jinf,nviol,n,nclin,lda,nactiv,nfree,nrz,
     *                   nz,istate,kactiv,kx,obj,numinf,xnorm,a,
     *                   ax,bl,bu,cvec,featol,featlu,x,w)
c----------------------------------------------------------------------
c     lpcore  is a subroutine for linear programming.
c     on entry, it is assumed that an initial working set of
c     linear constraints and bounds is available.  the arrays  istate,
c     kactiv  and  kx  will have been set accordingly
c     and the arrays  t  and  q  will contain the tq factorization of
c     the matrix whose rows are the gradients of the active linear
c     constraints with the columns corresponding to the active bounds
c     removed.  the tq factorization of the resulting (nactiv by nfree)
c     matrix is  a(free)*q = (0 t),  where q is (nfree by nfree) and t
c     is upper-triangular.

c     over a cycle of iterations, the feasibility tolerance featol
c     increases slightly (from tolx0 to tolx1 in steps of tolinc).
c     this ensures that all steps taken will be positive.

c     after kdegen consecutive iterations, variables within featol of
c     their bounds are set exactly on their bounds and iterative
c     refinement is used to satisfy the constraints in the working set.
c     featol is then reduced to tolx0 for the next cycle of iterations.

c     values of istate(j) for the linear constraints.......

c     istate(j)
c     ---------
c          0    constraint j is not in the working set.
c          1    constraint j is in the working set at its lower bound.
c          2    constraint j is in the working set at its upper bound.
c          3    constraint j is in the working set as an equality.

c     constraint j may be violated by as much as featol(j).
c----------------------------------------------------------------------
      implicit none 

      character empty*6
      parameter (empty='      ')

      double precision obj, xnorm
      integer iter, itmax, jinf, lda, n, nactiv, nclin, nfree,
     *                  nrz, numinf, nviol, nz
      logical cset, rset, unitq
      character*2       prbtyp
      character*6       msg

      double precision a(lda,*), ax(*), bl(n+nclin), bu(n+nclin),
     *                  cvec(*), featlu(n+nclin), featol(n+nclin), w(*),
     *                  x(n)
      integer istate(n+nclin), kactiv(n), kx(n)

      double precision alfap, alfhit, bigalf, biggst, condmx, 
     *                  condt, dinky, dnorm, dzz, errmax, flmax,
     *                  gfnorm, grznrm, gznorm, objsiz, rtmax, smllst,
     *                  suminf, tinyst, trubig, trusml, wssize, zerolm
      integer iadd, ifix, inform, is, it, j, jbigst,
     *                  jmax, jsmlst, jtiny, kbigst, kdel, ksmlst, lad,
     *                  lanorm, lcq, ld, ldr, lgq, lq, lr, lrlam, lt,
     *                  ltmp, lwrk, lwtinf, 
     *                  nctotl, nfixed, ngq, nmoved, notopt, ntfixd
      logical firstv, fp, hitlow, lp, move, onbnd, overfl,
     *                  unbndd

      double precision ddot, dnrm2, sdiv 
      external ddot, dnrm2, sdiv 

      integer loclc
      common/ ngg003 /loclc(20)

      double precision wmach
      common/ cstmch /wmach(10)

      integer ldt, ldq, ncolt
      common/ ngg004 /ldt, ncolt, ldq

      integer itnfix, kdegen, ndegen, nfix
      double precision tolinc, tolx0
      common/ ngg005 /tolx0, tolinc, kdegen, ndegen, itnfix, nfix(2)

      double precision epspt3, epspt5, epspt8, epspt9
      common/ ngg006 /epspt3, epspt5, epspt8, epspt9

      logical prnt
      integer isdel, jadd, jdel
      double precision alfa, trulam
      common/ ngg007 /alfa, trulam, isdel, jdel, jadd, prnt

      double precision asize, dtmax, dtmin
      common/ ngg008 /asize, dtmax, dtmin

      integer itmax1, itmax2, kchk, kcycle, lcrash, lprob, 
     *        maxact, mxfree, maxnz, mm, nn, nnclin
      common/ ngg010 /itmax1, itmax2, kchk, kcycle, lcrash, lprob, 
     *                maxact, mxfree, maxnz, mm, nn, nnclin

      double precision bigbnd, bigdx, bndlow, bndupp, tolact, tolfea, 
     *                 tolrnk
      common/ ngg011 /bigbnd, bigdx, bndlow, bndupp,
     *                tolact, tolfea, tolrnk

      save firstv
c----------------------------------------------------------------------
c     specify the machine-dependent parameters.

      flmax = wmach(7)
      rtmax = wmach(8)

      if (cset) then
         ngq = 2
      else
         ngq = 1
      end if

      lp = prbtyp.eq.'lp'
      fp = .not. lp

      ldr = ldt
      it = 1

      lanorm = loclc(4)
      lad = loclc(5)

      ld = loclc(7)
      lgq = loclc(8)
      lcq = loclc(9)
      lrlam = loclc(10)

      lr = loclc(11)
      lt = loclc(12)
      lq = loclc(13)
      lwtinf = loclc(14)
      lwrk = loclc(15)

c     we need a temporary array when changing the active set.
c     use the multiplier array.

      ltmp = lrlam

      if (iter.eq.0) then

c        first entry.  initialize.

         jadd = 0
         jdel = 0
         isdel = 0
         firstv = .false.

         alfa = 0d0
         dzz = 1d0
      end if

      nctotl = n + nclin
      nviol = 0

      condmx = flmax

      call cmsinf(n,nclin,lda,istate,bigbnd,numinf,suminf,bl,bu,a,
     *            featol,w(lgq),x,w(lwtinf))

      if (numinf.gt.0) then
         call cmqmul(6,n,nz,nfree,ldq,unitq,kx,w(lgq),w(lq),w(lwrk))
      else if (lp) then
         call dcopy (n,w(lcq),1,w(lgq),1)
      end if

      if (numinf.eq.0 .and. lp) then
         obj = ddot (n,cvec,1,x)
      else
         obj = suminf
      end if

      msg = empty

c*    ======================start of main loop==========================
c     +    do while (msg.eq.empty)
   20 if (msg.eq.empty) then

         gznorm = 0d0
         if (nz.gt.0) gznorm = dnrm2 (nz,w(lgq),1)

         if (nrz.eq.nz) then
            grznrm = gznorm
         else
            grznrm = 0d0
            if (nrz.gt.0) grznrm = dnrm2 (nrz,w(lgq),1)
         end if

         gfnorm = gznorm
         if (nfree.gt.0 .and. nactiv.gt.0) gfnorm = dnrm2 (nfree,w(lgq),
     *       1)

c        define small quantities that reflect the size of x, r and
c        the constraints in the working set.

         if (prnt) then
            condt = 1d0
            if (nactiv.gt.0) condt = sdiv (dtmax,dtmin,overfl)
            jdel = 0
            jadd = 0
            alfa = 0d0
         end if

         if (numinf.gt.0) then
            dinky = epspt8*abs(suminf)
         else
            objsiz = 1d0 + abs(obj)
            wssize = 0d0
            if (nactiv.gt.0) wssize = dtmax
            dinky = epspt8*max(wssize,objsiz,gfnorm)
         end if

c        if the reduced gradient z'g is small enough,
c        lagrange multipliers will be computed.

         if (numinf.eq.0 .and. fp) then
            msg = 'feasbl'
            nfixed = n - nfree
            call sload (nactiv+nfixed,0d0,w(lrlam),1)
            go to 20
         end if

         if (grznrm.le.dinky) then

c           the point  x  is a constrained stationary point.
c           compute lagrange multipliers.

c           define what we mean by 'tiny' and non-optimal multipliers.

            notopt = 0
            jdel = 0
            zerolm = -dinky
            smllst = -dinky
            biggst = dinky + 1d0
            tinyst = dinky

            call cmmul1 (n,lda,ldt,nactiv,nfree,nz,istate,
     *                   kactiv,kx,zerolm,notopt,numinf,trusml,smllst,
     *                   jsmlst,ksmlst,tinyst,jtiny,jinf,trubig,biggst,
     *                   jbigst,kbigst,a,w(lanorm),w(lgq),w(lrlam),
     *                   w(lt),w(lwtinf))

            if (nrz.lt.nz) call cmmul2(n,nrz,nz,zerolm,notopt,
     *                                 numinf,trusml,smllst,jsmlst,
     *                                 tinyst,jtiny,w(lgq))

            if (abs(jsmlst).gt.0) then

c              delete a constraint.
c              cmmul1  or  cmmul2  found a non-optimal multiplier.

               trulam = trusml
               jdel = jsmlst

               if (jsmlst.gt.0) then

c                 regular constraint.

                  kdel = ksmlst
                  isdel = istate(jdel)
                  istate(jdel) = 0
               end if
            else
               if (numinf.gt.0 .and. jbigst.gt.0) then

c                 no feasible point exists for the constraints but
c                 the sum of the constraint violations can be reduced
c                 by moving off constraints with multipliers greater
c                 than 1.

                  jdel = jbigst
                  kdel = kbigst
                  isdel = istate(jdel)
                  if (trubig.le.0d0) is = -1
                  if (trubig.gt.0d0) is = -2
                  istate(jdel) = is
                  trulam = trubig
                  firstv = .true.
                  numinf = numinf + 1
               end if
            end if

            if (jdel.eq.0) then
               if (numinf.gt.0) then
                  msg = 'infeas'
               else
                  msg = 'optiml'
               end if
               go to 20
            else 
c debug debug
               if (jdel.gt.0.and.nfree.eq.ldq) then 
c                 write (*,*) 'bugwandita!'
                  msg = 'infeas'
                  goto 20
               end if

            end if

c           constraint  jdel  has been deleted.
c           update the  tq  factorization.

            call rzdel (unitq,it,n,nactiv,nfree,ngq,nz,nrz,lda,ldq,ldt,
     *                  jdel,kdel,kactiv,kx,a,w(lt),w(lgq),w(lq),
     *                  w(ld),w(lrlam))
            if (rset) call lpcolr(nrz,ldr,w(lr),1d0)

            prnt = .false.
         else

c           compute a search direction.

            if (iter.ge.itmax) then
               msg = 'itnlim'
               go to 20
            end if

            prnt = .true.
            iter = iter + 1

            call dcopy (nrz,w(lgq),1,w(ld),1)
            call dscal (nrz,-1d0,w(ld),1)

            dnorm = dnrm2 (nrz,w(ld),1)

            call cmqmul(1,n,nrz,nfree,ldq,unitq,kx,w(ld),w(lq),w(lwrk))
            call dgemv ('no transpose',nclin,n,1d0,a,lda,w(ld),0d0,
     *                 w(lad))

c           find the constraint we bump into along d.
c           update  x  and  ax  if the step alfa is nonzero.

c           alfhit is initialized to bigalf. if it remains that value
c           after the call to  cmchzr, it is regarded as infinite.

            bigalf = sdiv (bigdx,dnorm,overfl)

            call cmchzr(firstv,n,nclin,istate,bigalf,bigbnd,dnorm,
     *                  hitlow,move,onbnd,unbndd,alfhit,alfap,jadd,
     *                  w(lanorm),w(lad),ax,bl,bu,featol,featlu,w(ld),x)

            if (unbndd) then
               msg = 'unbndd'
               go to 20
            end if

            alfa = alfhit
            call daxpy (n,alfa,w(ld),1,x,1)

            if (nclin.gt.0) call daxpy (nclin,alfa,w(lad),1,ax,1)
            xnorm = dnrm2 (n,x,1)

c           add a constraint to the working set.
c           update the  tq  factors of the working set.
c           use  d  as temporary work space.

            if (bl(jadd).eq.bu(jadd)) then
               istate(jadd) = 3
            else if (hitlow) then
               istate(jadd) = 1
            else
               istate(jadd) = 2
            end if

            if (jadd.gt.n) then
               iadd = jadd - n
            else
               if (alfa.ge.0d0) then
                  if (hitlow) then
                     x(jadd) = bl(jadd)
                  else
                     x(jadd) = bu(jadd)
                  end if
               end if
               do 40 ifix = 1, nfree
                  if (kx(ifix).eq.jadd) go to 60
   40          continue
   60       end if

            call rzadd (unitq,rset,inform,ifix,iadd,jadd,it,nactiv,nz,
     *                  nfree,nrz,ngq,n,lda,ldq,ldr,ldt,kx,condmx,dzz,a,
     *                  w(lr),w(lt),w(lgq),w(lq),w(lwrk),w(lrlam),w(ld))

            nz = nz - 1
            nrz = nrz - 1

            if (jadd.le.n) then

c              a simple bound has been added.

               nfree = nfree - 1
            else

c              a general constraint has been added.

               nactiv = nactiv + 1
               kactiv(nactiv) = iadd
            end if

c           increment featol.

            call daxpy (nctotl,tolinc,featlu,1,featol,1)

            if (mod(iter,kchk).eq.0) then

c              check the feasibility of constraints with non-
c              negative istate values.  if some violations have
c              occurred.  set inform to force iterative
c              refinement and a switch to phase 1.

               call cmfeas(n,nclin,istate,bigbnd,nviol,jmax,errmax,ax,
     *                     bl,bu,featol,x)

            end if

            if (mod(iter,kdegen).eq.0) then

c              every  kdegen  iterations, reset  featol  and
c              move  x  on to the working set if it is close.

               call cmdgen('end of cycle',n,nclin,nmoved,iter,
     *                     numinf,istate,bl,bu,featol,featlu,x)

               nviol = nviol + nmoved
            end if

            if (nviol.gt.0) then
               msg = 'resetx'
               go to 20
            end if

            if (numinf.ne.0) then
               call cmsinf(n,nclin,lda,istate,bigbnd,numinf,suminf,bl,
     *                     bu,a,featol,w(lgq),x,w(lwtinf))

               if (numinf.gt.0) then
                  call cmqmul(6,n,nz,nfree,ldq,unitq,kx,w(lgq),w(lq),
     *                        w(lwrk))
               else if (lp) then
                  call dcopy (n,w(lcq),1,w(lgq),1)
               end if
            end if

            if (numinf.eq.0 .and. lp) then
               obj = ddot (n,cvec,1,x)
            else
               obj = suminf
            end if
         end if
         go to 20
c        +    end while
      end if
c     ======================end of main loop============================

      if (msg.eq.'optiml') then
         if (lp) then
            if (nrz.lt.nz) then
               msg = 'weak  '
            else
               ntfixd = 0
               do 80 j = 1, n
                  if (istate(j).eq.4) ntfixd = ntfixd + 1
   80          continue
               if (ntfixd.gt.0) msg = 'weak  '
            end if
            if (abs(jtiny).gt.0) msg = 'weak  '
         end if
      else if (msg.eq.'unbndd' .and. numinf.gt.0) then
         msg = 'infeas'
      end if
c                                 end of lpcore
      end


      subroutine rzadds (unitq,vertex,k1,k2,it,nactiv,nartif,nz,nfree,
     *                   nrejtd,ngq,n,ldq,lda,ldt,istate,kactiv,kx,
     *                   condmx,a,t,gqm,q,w,c,s)
c----------------------------------------------------------------------
c     rzadds  includes general constraints  k1  thru  k2  as new rows of
c     the  tq  factorization:
c              a(free) * q(free)  = ( 0 t)
c                        q(free)  = ( z y)
c     a) the  nactiv x nactiv  upper-triangular matrix  t  is stored
c        with its (1,1) element in position  (it,jt)  of the array  t.
c----------------------------------------------------------------------
      implicit none

      logical unitq, vertex, overfl, rset

      integer it, k1, k2, lda, ldq, ldt, n, nactiv, kx(n), k, l,
     *        nartif, nfree, ngq, nrejtd, nz, istate(*), kactiv(n),
     *        i, iadd, iartif, ifix, inform, iswap, j, jadd, jt, nzadd

      double precision a(lda,*), c(n), gqm(n,*), q(ldq,*), s(n), dnrm2, 
     *                 t(ldt,*), w(n), condmx, cndmax, cond, delta,sdiv,
     *                 drzz, dtnew, rnorm, rowmax, rtmax, tdtmax, tdtmin

      external dnrm2, sdiv 

      double precision wmach
      common/ cstmch /wmach(10)

      double precision epspt3, epspt5, epspt8, epspt9
      common/ ngg006 /epspt3, epspt5, epspt8, epspt9

      double precision asize, dtmax, dtmin
      common/ ngg008 /asize, dtmax, dtmin
c----------------------------------------------------------------------
      rtmax = wmach(8)

      jt = nz + 1

c     estimate the condition number of the constraints already
c     factorized.

      if (nactiv.eq.0) then
         dtmax = 0d0
         dtmin = 1d0
         if (unitq) then

c           first general constraint added.  set  q = i.

            call smload ('general',nfree,nfree,0d0,1d0,q,ldq)
            unitq = .false.
         end if
      else
         call scond (nactiv,t(it,jt),ldt+1,dtmax,dtmin)
      end if

      do 20 k = k1, k2
         iadd = kactiv(k)
         jadd = n + iadd
         if (nactiv.lt.nfree) then

            overfl = .false.

c           transform the incoming row of  a  by  q'.

            call dcopy (n,a(iadd,1),lda,w,1)
            call cmqmul(8,n,nz,nfree,ldq,unitq,kx,w,q,s)

c           check that the incoming row is not dependent upon those
c           already in the working set.

            dtnew = dnrm2 (nz,w,1)
            if (nactiv.eq.0) then

c              this is the first general constraint in the working set.

               cond = sdiv (asize,dtnew,overfl)
               tdtmax = dtnew
               tdtmin = dtnew
            else

c              there are already some general constraints in the working
c              set. update the estimate of the condition number.

               tdtmax = max(dtnew,dtmax)
               tdtmin = min(dtnew,dtmin)
               cond = sdiv (tdtmax,tdtmin,overfl)
            end if

            if (cond.ge.condmx .or. overfl) then

c              this constraint appears to be dependent on those already
c              in the working set.  skip it.

               istate(jadd) = 0
               kactiv(k) = -kactiv(k)
            else
               if (nz.gt.1) then

                  delta = w(nz)
                  call sgrfg (nz-1,delta,w,1,0d0,w(nz))
                  if (w(nz).gt.0d0) then

                     call dgemv ('n',nfree,nz,1d0,q,ldq,w,0d0,s)
                     call dger (nfree,nz,-1d0,s,w,q,ldq)

                     if (ngq.gt.0) then
                        call dgemv ('t',nz,ngq,1d0,gqm,n,w,0d0,s)
                        call dger (nz,ngq,-1d0,w,s,gqm,n)
                     end if
                  end if

                  w(nz) = delta
               end if
               it = it - 1
               jt = jt - 1
               nactiv = nactiv + 1
               nz = nz - 1
               call dcopy (nactiv,w(jt),1,t(it,jt),ldt)
               dtmax = tdtmax
               dtmin = tdtmin
            end if
         end if
   20 continue

      if (nactiv.lt.k2) then

c        some of the constraints were classed as dependent and not
c        included in the factorization.  re-order the part of  kactiv
c        that holds the indices of the general constraints in the
c        working set.  move accepted indices to the front and shift
c        rejected indices (with negative values) to the end.

         l = k1 - 1
         do 40 k = k1, k2
            i = kactiv(k)
            if (i.ge.0) then
               l = l + 1
               if (l.ne.k) then
                  iswap = kactiv(l)
                  kactiv(l) = i
                  kactiv(k) = iswap
               end if
            end if
   40    continue

c        if a vertex is required,  add some temporary bounds.
c        we must accept the resulting condition number of the working
c        set.

         if (vertex) then
            rset = .false.
            cndmax = rtmax
            drzz = 1d0
            nzadd = nz
            do 80 iartif = 1, nzadd
               if (unitq) then
                  ifix = nfree
                  jadd = kx(ifix)
               else
                  rowmax = 0d0
                  do 60 i = 1, nfree
                     rnorm = dnrm2 (nz,q(i,1),ldq)
                     if (rowmax.lt.rnorm) then
                        rowmax = rnorm
                        ifix = i
                     end if
   60             continue
                  jadd = kx(ifix)

                  call rzadd (unitq,rset,inform,ifix,iadd,jadd,it,
     *                        nactiv,nz,nfree,nz,ngq,n,lda,ldq,ldt,ldt,
     *                        kx,cndmax,drzz,a,t,t,gqm,q,w,c,s)
               end if
               nfree = nfree - 1
               nz = nz - 1
               nartif = nartif + 1
               istate(jadd) = 4
   80       continue
         end if

         if (it.gt.1) then

c           if some dependent constraints were rejected,  move  t  to
c           the top of the array  t.

            do 120 k = 1, nactiv
               j = nz + k
               do 100 i = 1, k
                  t(i,j) = t(it+i-1,j)
  100          continue
  120       continue
         end if
      end if

      nrejtd = k2 - nactiv
c                                 end of rzadds
      end
