#!/bin/csh

set F77 = gfortran
set outdir = ../../gbin

\rm -f *.o
${F77} -o ${outdir}/avgrot.exe avgrot.for

