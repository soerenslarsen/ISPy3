      program inpwidth
C       Modified by SL 
C        Assume line data are in a single file (fort.10)
C        Ask for the line matching tolerance (wltol)
      character*10 label,labelp,other1,other2
      character*80 card,star,end,stop,mol1,mol2,hlin,begin
      character*80 modfile,c,linefile
      character*4 ref
      character*5 modcard
      integer unit
      dimension vts(3),angle(20)
      data end/'END'/
      data stop/'STOP'/
      data mol1/'MOLECULES ON'/
      data mol2/'READ MOLECULES'/
      data hlin/'OPACITY ON HLINES'/
      data begin/'BEGIN'/
      data label/'          '/
      data labelp/'          '/
      data other1/'          '/
      data other2/'          '/
      nblo=0
      npup=0
      iso1=0
      x1=0.
      iso2=0
      x2=0.
      open(unit=2,file='inplines.dat',status='unknown')
      open(unit=1,status='unknown')
c      open(unit=10,status='old',action='read',recl=160)
      open(unit=10,status='old',action='read')
C	open(unit=11,status='old',readonly,shared,recl=160)
C	open(unit=12,status='old',readonly,shared,recl=160)
C	open(unit=13,status='old',readonly,shared,recl=160)
C	open(unit=14,status='old',readonly,shared,recl=160)
C	open(unit=15,status='old',readonly,shared,recl=160)
C	open(unit=16,status='old',readonly,shared,recl=160)
C	open(unit=17,status='old',readonly,shared,recl=160)
C	open(unit=18,status='old',readonly,shared,recl=160)

C       type 311
C 311   format(3x,'star name  ',$)
C       accept 90,star
      write(*, '(A)', advance='no') 'star name  '
      read (*,*) star

C       type 1
C 1     format(3x,'VTUR(bulence)? (yes=1/no=0)  ',$)
C       accept*,iturb
      write(*, '(A)', advance='no') 'VTUR(bulence)? (yes=1/no=0)  '
      read (*,*) iturb
      if(iturb.eq.1) go to 10

C 100   type 2
C 2     format(3x,'PROF(ile)? (yes=1/no=0)   ',$)
C       accept*,iprof
100   write(*, '(A)', advance='no') 'PROF(ile)? (yes=1/no=0)   '
      read(*,*) irprof
      if(iprof.eq.1) go to 20

C 200   type 3
C 3     format(3x,'AVER(age)? (yes=1/no=0)  ',$)
C       accept*, iaver
200   write(*, '(A)', advance='no') 'AVER(age)? (yes=1/no=0)  '
      read(*,*) iaver
      if (iaver.eq.1) go to 30

C 300   type 4
C 4     format(3x,'CURV(e)? (yes=1/no=0)   ',$)
C       accept*,icurv
300   write(*, '(A)', advance='no') 'CURV(e)? (yes=1/no=0)   '
      read(*,*) icurv
      if(icurv.eq.1) go to 40

C 400   type 5
C 5     format(3x,'end of data for the lines? (yes=1/no=0)  ',$)
C       accept*,iend
400   write(*, '(A)', advance='no') 
     1 'end of data for the lines? (yes=1/no=0)  '
      read(*,*) iend
      if(iend.eq.1) go to 500

C 600   type 6
C 6     format(3x,'stop ? (yes=1/no=0)  ',$)
C       accept*, istop
600   write(*, '(A)', advance='no') 'stop ? (yes=1/no=0)  '
      read(*,*) istop
      if(istop.eq.1) go to 60

10    card='VTUR'
      write (1,90) card
90    format(a)

C       type 11
C 11    format(3x,'Number N of the microturb. velocities (NMAX=3):  ',$)
C       accept*,nvt
      write(*, '(A)', advance='no')
     1 'Number N of the microturb. velocities (NMAX=3):  '
      read(*,*) nvt

C       type 12
C 12    format(3x,'Type the values of the N microturb. velocities ',$)
C       accept*,(vts(ivt),ivt=1,nvt)
      write(*, '(A)', advance='no')
     1 'Type the values of the N microturb. velocities '
      read(*,*) (vts(ivt), ivt=1,nvt)

      write(1,91) nvt,(vts(ivt),ivt=1,nvt)
91    format(i5,3f5.2)
      iwhat=1

C       type 14
C 14    format(3x,'Is some line file already existing?(yes=1/no=0) ',$)
C       accept*,iold
      write(*, '(A)', advance='no')
     1 'Is some line file already existing?(yes=1/no=0) '
      read(*,*) iold
      if(iold.eq.0) go to 66

 667  read(2,190,end=66)card
 190  format(a4)
      if(card.eq.'AVER')then
      write(1,190)card
      go to 667
      endif
      if(card.eq.'LINE')then
      read(2,874)wlobs
      read(2,874)wltol
      read(2,874)ew
      write(1,9)card,ew,wlobs,star
      read(2,874)gflog
      read(2,911)ref
      read(2,874)xj
      read(2,8745)e
      read(2,874)xjp
      read(2,8745)ep
      read(2,874)code
8745  format(1x,f12.3)
      wl=wlobs
      write(1,444)wl,gflog,xj,e,xjp,ep,code,label,labelp
      read(2,875)nelion
      read(2,874)gammar
      read(2,874)gammas
      read(2,874)gammaw
      read(2,873)alpha
 873  format(f6.3)
      write(1,445)wl,nelion,gammar,gammas,gammaw,ref,nblo,nbup,iso1,
     1 x1,iso2,x2,other1,other2,alpha
      go to 667
      endif

C 66    type 13
C 13    format(3x,'LINE ? (yes=1/no=0)   ',$)
C       accept*,iline
66    write(*, '(A)', advance='no') 'LINE ? (yes=1/no=0)   '
      read(*,*) iline

      if(iline.eq.1) go to 50
      if(iwhat.eq.3) GO TO 200
      go to (100,200,300,400),iwhat
20    card='PROF'
      write(1,90) card
      write(2,90)card
      iwhat=2
      go to 66
30    card='AVER'
      write(1,90) card
      write(2,90)card
      iwhat=3
      go to 66
40    card='CURV'
      write(1,90) card
      write(2,90)card

C       type 41
C 41    format(3x,'type nablog,minlog,dablog'/3x,$)
C       accept*,nablog,fminlog,dablog
      write(*, '(A)', advance='no') 'type nablog,minlog,dablog   '  
      read(*,*) nablog,fminlog,dablog

      write(1,171) nablog,fminlog,dablog
171   format(i5,2f8.2)
      iwhat=4
      go to 66
 50   card='LINE'
      write(2,190)card

C       type 31
C 31    format(3x,'wavelength (in Nm: es. 4000A=400.0 Nm):  ', $)
C       accept*,wlobs
      write(*, '(A)', advance='no')
     1 'wavelength (in Nm: es. 4000A=400.0 Nm):  '
      read(*,*) wlobs
      write(2,874) wlobs
874   format(1x,f10.4)

C       type 35
C 35    format(3x,'matching tolerance (in Nm):  ', $)
C       accept*,wltol
      write(*, '(A)', advance='no') 
     1 'matching tolerance (in Nm):  '
      read(*,*) wltol
      write(2,874) wltol

C       type 131
C 131   format(3x,'equivalent width (in Pm: es. 200 mA=20.0 Pm):  ',$)
C       accept*,ew
      write(*, '(A)', advance='no')
     1 'equivalent width (in Pm: es. 200 mA=20.0 Pm):  '
      read(*,*) ew
      write(2,874)ew
      card='LINE'
      write(1,9) card,ew,wlobs,star
9     format(a4,f10.2,f10.4,1x,a56)

C       type 3227
C 3227  format(3x,'code   ',$)
C       accept*,code1
      write(*, '(A)', advance='no') 'code   '
      read(*,*) code1

      unit=10

C	if(wlobs.lt.100)unit=10
C	if(wlobs.ge.100.and.wlobs.lt.150.)unit=11
C	if(wlobs.ge.150.and.wlobs.lt.200.)unit=12
C	if(wlobs.ge.200.and.wlobs.lt.300.)unit=13
C	if(wlobs.ge.300.and.wlobs.lt.400.)unit=14
C	if(wlobs.ge.400.and.wlobs.lt.500.)unit=15
C	if(wlobs.ge.500.and.wlobs.lt.600.)unit=16
C	if(wlobs.ge.600.and.wlobs.lt.800.)unit=17
C	if(wlobs.ge.800.)unit=18
      do 900 iline=1,50000000
      read(unit,140,end=500)wl,gflog,code,e,xj,label,ep,xjp,labelp,
     1 gammar,gammas,gammaw,ref,nblo,nbup,iso1,x1,iso2,x2,other1,
     2 other2,lande,landeg,isoshift,alpha
 140  format(f11.4,f7.3,f6.2,f12.3,f5.1,1x,a10,f12.3,f5.1,1x,a10,
     1 f6.2,f6.2,f6.2,a4,i2,i2,i3,f6.3,i3,f6.3,a10,a10,2i5,i6,f6.3)
c
      write(*,*) wl, wlobs, wltol, code, code1
      if(abs(wl-wlobs).le.wltol.and.code.eq.code1)then
      write(1,444) wl,gflog,xj,e,xjp,ep,code,label,labelp
444   format(f10.4,f7.3,f5.1,f12.3,f5.1,f12.3,f9.2,a10,a10)
      nelem=code
      icharge=(code-float(nelem))*100+0.1
      zeff=icharge+1
      nelion=nelem*6-6+ifix(zeff)
      write(1,445)wl,nelion,gammar,gammas,gammaw,ref,nblo,nbup,iso1,
     1 x1,iso2,x2,other1,other2,alpha
445   format(f10.4,i4,f6.2,f6.2,f6.2,a4,i2,i2,i3,f7.3,i3,f7.3,
     1 a10,a10,f6.3)
      write(2,874)gflog
      write(2,911)ref
911   format(a4)
      write(2,874)xj
      write(2,8745)e
      write(2,874)xjp
      write(2,8745)ep
      write(2,874)code
9011  format(a10)
      write(2,875)nelion
875   format(1x,i5)
      write(2,874)gammar
      write(2,874) gammas
      write(2,874)gammaw
      write(2,873)alpha
      rewind(unit)
      go to 66
      endif
 900  continue
500   write(1,90) end

C 83    type 503
C 503   format(///,3x,'type the name of the model file ',$)
C       accept 90,modfile
      write(*, '(A)', advance='no')
     1 'type the name of the model file '
      read(*,*) modfile

      open(unit=3,file=modfile,status='old')
      do 993 i=1,500
      read (3,90,end=999) c
      write(modcard,'(a5)')c(1:5)
c	type 342, modcard
 342  format(1x,a5)
      if (modcard.ne.begin)write (1,90)c
993   continue
 999  close (unit=3)
      write(1,90)mol1
      write(1,90)mol2
      write(1,90)hlin
      write(1,90)begin
60    write(1,90)end
      write(1,90)stop
      close(unit=1)
      stop
      end
