      PROGRAM AVGROT
C     Calculate a weighted average of several (up to 25) rotation-broadened
C     spectra and save the result to an ASCII file (unit 2).
C     The input consists of the number of spectra on the first line
C     and the weights for each spectrum on the next line.
C     Aug2023, SSL
      DIMENSION xmu(20),qmu(40),wledge(200),title(74)
      DIMENSION fluxrl(25), fluxrc(25), residr(25), wgt(25)
      REAL*8 teff,glog,title,wbegin,resolu,xmu,wledge
      REAL*8 qmu, qmul, qmuc, wgt
      CHARACTER*5 rotname(25)
      DATA rotname/'ROT1','ROT2','ROT3','ROT4','ROT5','ROT6','ROT7',
     1'ROT8','ROT9','ROT10','ROT11','ROT12','ROT13','ROT14','ROT15',
     2'ROT16','ROT17','ROT18','ROT19','ROT20','ROT21','ROT22',
     3'ROT23','ROT24','ROT25'/

      read(5,*) nrot
      read(5,*) (wgt(i), i=1,nrot)
      write(6,40) nrot
      write(6,50) (wgt(i), i=1,nrot)

40    format("AVERAGING ", (I2), " SPECTRA WITH WEIGHTS:")
50    format((8F10.4))

      wsum = 0.
      do irot=1,nrot
      wsum  = wsum + wgt(irot)
      write(6,*) rotname(irot)
      open(unit=10+irot, FORM='UNFORMATTED',action='read',
     1STATUS='OLD', file=rotname(irot))
      read(10+irot)teff,glog,title,wbegin,resolu,nwl,ifsurf,nmu,xmu,
     1nedge, wledge

C     This programme will only work if the input files contain a
C     single (flux) spectrum each
      if (nmu.ne.1) then
      write(6,*) "ERROR, NMU IS ", nmu, " BUT SHOULD BE 1"
      stop
      endif

      WRITE(6,1)TEFF,GLOG,TITLE
      if (irot.eq.1) WRITE(2,1)TEFF,GLOG,TITLE
    1 FORMAT(5HTEFF ,F7.0,7HGRAVITY,F7.3/7HTITLE  ,74A1)
      enddo

      do iwl=1,nwl
      niwl=iwl
      wave=wbegin*(1.+1./resolu)**(niwl-1)
      freq=2.997925e17/wave
      wavea=10.*wave

      fluxl = 0.
      fluxc = 0.

      do irot=1,nrot
      read(10+irot) qmul,qmuc
      
      fluxl=fluxl+wgt(irot)*4.*qmul*2.99792458E18/(wavea*wavea)
      fluxc=fluxc+wgt(irot)*4.*qmuc*2.99792458E18/(wavea*wavea)

C      WRITE(6,55)wavea,fluxrl(irot),fluxrc(irot),residr(irot)
      enddo

      resid = fluxl/fluxc
      write(2,55)wavea,fluxl/wsum,fluxc/wsum,resid
55    format(1x,f11.4,1x,1pE12.4,1x,1pE12.4,1x,0PF8.4)
      enddo

      do irot=1,nrot
      close(unit=10+irot)
      enddo
      close(unit=2)

      END
