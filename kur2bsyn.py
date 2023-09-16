from ispy3 import absetup
import sys
import numpy
import const
from  utils import is_number

lam1, lam2 = 0, 1e10
kfile = sys.argv[1]
pfile = sys.argv[2]
if (len(sys.argv) > 3):
    lam1 = float(sys.argv[3])
    lam2 = float(sys.argv[4])
    print("%f < Lambda < %f" % (lam1, lam2))

print(kfile, ' --> ', pfile)

ofile = open(pfile,'w')

alam, achil, awup, aloggf, aelem, aion, agVdW, agrad = [], [], [], [], [], [], [], []
alab1, alab2 = [], []
aflogfhfs = []
aflogfiso = []

with open(kfile,'r') as f:
    for l in f:
# for l in file(kfile):
        slam   = l[0:11]
        sloggf = l[11:18]
    #    selem  = l[18:24]
        selem  = l[18:21]
        sion   = l[23:24]
        sE1    = l[24:36]
        sJ1    = l[36:41]
        slab1  = l[42:52]
        sE2    = l[52:64]
        sJ2    = l[64:69]
        slab2  = l[70:80]
        sgammarad = l[80:86]
        sgammastark = l[86:92]
        sgammaVdW = l[92:98]
        slogfhfs  = l[109:115]
        slogfiso  = l[118:124]

        if (is_number(slam) and is_number(sloggf) and is_number(selem) and \
            is_number(sgammaVdW) and is_number(sgammarad) and is_number(sE1) and \
            is_number(sE2) and is_number(sJ1) and is_number(sJ2)):

            wlam = float(slam)*10.
            wloggf = float(sloggf)
    #       welem  = int(float(selem))
    #       wion   = int((float(selem) - welem)*100 + 1)
            welem  = int(selem)
            wion   = int(sion)+1
            if (sgammaVdW == '  0.00'):
                wgammaVdW = 2.5
            else:
                wgammaVdW = float(sgammaVdW)
            wgammarad = 10**float(sgammarad)
            if (wgammarad < 1e5): wgammarad = 1e5

            if is_number(slogfhfs):
                wlogfhfs = float(slogfhfs)
            else:
                wlogfhfs = 0.0

            if is_number(slogfiso):
                wlogfiso = float(slogfiso)
            else:
                wlogfiso = 0.0

            if (float(sE1) < float(sE2)):
                wchil = 100*const.h*const.c*float(sE1)/const.ev
                wwup = 2*float(sJ2)+1
                wlab1 = slab1
                wlab2 = slab2
            else:
                wchil = 100*const.h*const.c*float(sE2)/const.ev
                wwup = 2*float(sJ1)+1
                wlab1 = slab2
                wlab2 = slab1


    #	if ((sgammarad != '  0.00') and (sgammaVdW != '  0.00') and (wchil<100) and
            if (wlam >= lam1) and (wlam <= lam2):
#                if ((sgammaVdW != '  0.00') and (wchil<100)):
                if (wchil<100):
                    alam.append(wlam)
                    achil.append(wchil)
                    awup.append(wwup)
                    aloggf.append(wloggf)
                    aelem.append(welem)
                    aion.append(wion)
                    agVdW.append(wgammaVdW)
                    agrad.append(wgammarad)
                    alab1.append(wlab1)
                    alab2.append(wlab2)
                    aflogfhfs.append(wlogfhfs)
                    aflogfiso.append(wlogfiso)
                else:
                    print('REJ (Chi_l=%0.2f, >100): %s' % (wchil, l[:-2]))

    #	print slam, sloggf, selem, sE1, sJ1, sE2, sJ2, sgammarad, sgammastark, sgammaVdW
    #	print("%10.3f%7.3f%7.3f%9.3f%7.1f%10.2e 'X' 'X' %s %s" % (wlam, wchil, wloggf, wgammaVdW, wwup, wgammarad, slab1, slab2))
        #    , welem, wion

aelem = numpy.array(aelem)
aion  = numpy.array(aion)

# for elem in [('H',1), ('He',2)] + absetup.stdabun:
for elem in absetup.stdabun:
    for ion in range(1, 4):
        ww = numpy.where((aelem == elem[1]) & (aion == ion))
        if (len(ww[0]) > 1):
            sion = ''
            for i in range(ion): sion = sion +'I'
            ofile.write("'%8.3f            '%5d%10d\n" % (elem[1], ion, len(ww[0])))
            sout = elem[0] + ' ' + sion
            ofile.write("'%-7s'\n" % sout)
            for j in ww[0]:
                if (aloggf[j]+aflogfhfs[j]+aflogfiso[j] > -9.999):
                    ofile.write("%10.3f%7.3f%7.3f%9.3f%7.1f%10.2e 'X' 'X'   0.0    1.0 '%s %s %s'\n" % (alam[j], achil[j], aloggf[j]+aflogfhfs[j]+aflogfiso[j], agVdW[j], awup[j], agrad[j], sout, alab1[j], alab2[j]))
                else:
                    ofile.write("%10.3f%7.3f%7.2f%9.3f%7.1f%10.2e 'X' 'X'   0.0    1.0 '%s %s %s'\n" % (alam[j], achil[j], aloggf[j]+aflogfhfs[j]+aflogfiso[j], agVdW[j], awup[j], agrad[j], sout, alab1[j], alab2[j]))


ofile.close()
