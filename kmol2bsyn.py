import sys
import numpy
import const
from  utils import is_number

# Convert molecular line list from Kurucz's .asc format to the format used by
# TurboSpectrum/bsyn.

lam1, lam2 = 0, 1e10
kfile = sys.argv[1]
pfile = sys.argv[2]
if (len(sys.argv) > 3):
    lam1 = float(sys.argv[3])
    lam2 = float(sys.argv[4])
    print("%f < Lambda < %f" % (lam1, lam2))

print(kfile, ' --> ', pfile)

ofile = open(pfile,'w')

alam, aloggf, axj, achie, axjp, achiep, agu, aiso = [], [], [], [], [], [], [], []
aicode = []
iiso, iicode = [], []
agamr = []

#          1         2         3         4         5         6         7
#01234567890123456789012345678901234567890123456789012345678901234567890123
#aaaaaaaaaabbbbbbbcccccddddddddddeeeeefffffffffffgggghhhhhhhhiiiiiiiijjkkkk
#   WL      GFLOG   XJ      E      XJP    EP     ICODE LABEL LABELP ISO GAM
#  500.0010 -1.505  9.5  4666.690  8.5  24661.070 112X03F2   B03F2   24 

with open(kfile,'r') as f:
  for l in f:
    slam   = l[0:10]
    sloggf = l[10:17]
    sxj    = l[17:22]
    se     = l[22:32]
    sxjp   = l[32:37]
    sep    = l[37:48]
    sicode = l[48:52]
    siso   = l[68:70]
    sgamr  = l[70:74]

    wlam   = float(slam)*10.
    wloggf = float(sloggf)
    wxj    = float(sxj)
    wchie  = abs(100*const.h*const.c*float(se)/const.ev)
    wxjp   = float(sxjp)
    wgu    = 2*wxjp+1
    wchiep = abs(100*const.h*const.c*float(sep)/const.ev)

    if is_number(siso):
        wiso = int(siso)
    else:
        wiso = 0

    if is_number(sgamr):
        wgamr = 10**(float(sgamr)*0.01)
    else:
        wgamr = 0.0

    if (not wiso in iiso): iiso.append(wiso)
    if (not sicode in iicode): iicode.append(sicode)

    if (wlam >= lam1) and (wlam <= lam2):
        alam.append(wlam)
        aloggf.append(wloggf)
        axj.append(wxj)
        achie.append(wchie)
        axjp.append(wxjp)
        achiep.append(wchiep)
        aicode.append(sicode)
        agu.append(wgu)
        aiso.append(wiso)
        agamr.append(wgamr)

#        print("%10.3f%7.3f%7.3f%9.3f%7.1f%10.2e 'X' 'X' 0.0  1.0" % (wlam, wchie, wloggf, 0.0, wgu, 0.0))
    #    , welem, wion

npiso = numpy.array(aiso)
npicode = numpy.array([int(xx) for xx in aicode])
nplam = numpy.array(alam)
npchie = numpy.array(achie)
nploggf = numpy.array(aloggf)
npgu = numpy.array(agu)
npgamr = numpy.array(agamr)

pf = open(pfile,'w')

for jicode in iicode:
    for jiso in iiso:
        ww = numpy.where((npiso == jiso) & (npicode == int(jicode)))

        # The isotope codes can be reconstructed from rmolecasc.for
        # The labels of the conditional GO TO statement correspond to
        # 10*ISO, e.g. iso=18: 
        #   180 IF(CODE.EQ.814.)GO TO 1800
        #       IF(CODE.EQ.608.)GO TO 1810
        #       IF(CODE.EQ.813.)GO TO 1820
        #   ...
        # C SiO
        #  1800 ..
        #       ISO1=28
        #       ISO2=18
        #
        # From this we get
        #  jicode   jiso   iso1  iso2
        #   101       1      1     1
        #   101       2      1     2
        #   106      12      1    12
        #   106      13      1    13
        #   107      14      1    14
        #   107      15      1    15
        #   108      16      1    16
        #   108      18      1    18
        #   111      23      1    23
        #   112      24      1    24
        #   112      25      1    25
        #   112      26      1    26
        #   113      27      1    27
        #   114      28      1    28
        #   114      29      1    29
        #   114      30      1    30
        #   120      40      1    40
        #   606      12     12    12
        #   606      13     12    13
        #   606      33     13    13
        #   607      12     12    14
        #   607      13     13    14
        #   607      15     12    15
        #   608      12     12    16
        #   608      13     13    16 
        #   608      18     12    18
        #   813      16     16    27
        #   813      17     17    27
        #   813      18     18    27
        #   814      18     18    28
        #   814      28     16    28
        #   814      29     16    29
        #   814      30     16    30
        #   820      40     16    40
        #   823      51     16    51

        # The value of fdamp (van der Waals) is ignored for molecular lines,
        # only radiative damping is modelled.
        fdamp = 0.0

        if (jicode == ' 606'):
            if (jiso == 33):
                j1 = 13
                j2 = 13
            else:
                j1 = 12
                j2 = jiso
        elif (jicode == ' 607'):
            if (jiso == 12):
                j1 = 12
                j2 = 14
            if (jiso == 13):
                j1 = 13
                j2 = 14
            if (jiso == 15):
                j1 = 12
                j2 = 15
        elif (jicode == ' 608'):
            if (jiso == 12):
                j1 = 12
                j2 = 16
            if (jiso == 13):
                j1 = 13
                j2 = 16
            if (jiso == 17):
                j1 = 12
                j2 = 17
            if (jiso == 18):
                j1 = 12
                j2 = 18
        elif (jicode == ' 813'):
            if (jiso == 16):
                j1 = 16
                j2 = 27
            if (jiso == 17):
                j1 = 17
                j2 = 27
            if (jiso == 18):
                j1 = 18
                j2 = 27
        elif (jicode == ' 814'):
            if (jiso == 28):
                j1 = 16
                j2 = 28
            if (jiso == 29):
                j1 = 16
                j2 = 29
            if (jiso == 30):
                j1 = 16
                j2 = 30
            if (jiso == 18):
                j1 = 18
                j2 = 28
        else:
            j1 = 0
            j2 = jiso
          

        print("jicode, jiso, j1, j2 = ",jicode, jiso, j1, j2)
        print("'%s.%03d%03d         '    1    %6d" % (jicode, j1, j2, len(ww[0])))

#        if (jicode == ' 106'):   # Masseron line list for CH available from Plez
#                                 # website. Maybe easier to get rid of this
#                                 # exception (here and in turbospec.py).
#            print("Skipping CH")
#        else:
        if (len(ww[0]) > 0):
            pf.write("'%s.%03d%03d         '    1    %6d\n" % (jicode, j1, j2, len(ww[0])))
            pf.write("'%s   '\n" % kfile)
            for iw in ww[0]:
                if (nploggf[iw] > -10):
                    pf.write("%10.3f%7.3f%7.3f%9.3f%7.1f%10.2E 'X' 'X' 0.0  1.0\n" % (nplam[iw], npchie[iw], nploggf[iw], fdamp, npgu[iw], npgamr[iw]))
                else:
                    pf.write("%10.3f%7.3f%7.2f%9.3f%7.1f%10.2E 'X' 'X' 0.0  1.0\n" % (nplam[iw], npchie[iw], nploggf[iw], fdamp, npgu[iw], npgamr[iw]))

pf.close()


