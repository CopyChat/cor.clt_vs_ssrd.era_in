#!/bin/bash - 
#======================================================
#
#          FILE: seasonal.vld.sh
# 
USAGE="./seasonal.vld.sh"
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: --- unknown
#         NOTES: ---
#        AUTHOR: |CHAO.TANG| , |chao.tang.1@gmail.com|
#  ORGANIZATION: 
#       CREATED: 05/15/17 11:04
#      REVISION: 1.0
#=====================================================
set -o nounset           # Treat unset variables as an error
. ~/Code/Shell/functions.sh   # ctang's functions


# input monmean files
ssrd=ERA_In.ssrd.mon.mean.1983-2005.nc
clt=ERA_In.clt.mon.mean.1983-2005.nc

# output cor files
fldcorf=ssrd.clt.season.fldcor.nc
seascorf=ssrd.clt.fld.seascor.nc

function cor_per_season()
{

    # seasonal mean
    cdo seasmean $ssrd ${ssrd%.nc}.season.nc
    cdo seasmean $clt ${clt%.nc}.season.nc

    # sel field

    cordex_SA ${ssrd%.nc}.season.nc ${ssrd%.nc}.season.SA.nc
    cordex_SA ${clt%.nc}.season.nc ${clt%.nc}.season.SA.nc

    # seasonal fldcor
    cdo fldcor ${ssrd%.nc}.season.SA.nc ${clt%.nc}.season.SA.nc $fldcorf

}
function selseas()
{
    # sel seasons
    cdo selmon,1 $fldcorf ${fldcorf%.nc}.DJF.nc
    cdo selmon,7 $fldcorf ${fldcorf%.nc}.JJA.nc
}

cor_per_season
selseas
