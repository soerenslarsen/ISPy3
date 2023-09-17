#!/bin/csh

set F77 = gfortran
set OPTIONS = '-std=legacy -fno-automatic -w -O3'

${F77} -o avgrot.exe avgrot.for
${F77} ${OPTIONS} -o width9sl.exe width9sl.for
${F77} -o inpw_sl.exe inpw_sl.for
${F77} ${OPTIONS} -o rmolecasc.exe rmolecasc_sl.for
