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
fldcorf=ssrd.clt.seasonal.fldcor.nc
seascorf=ssrd.clt.fld.seascor.nc

function cor_seasonal_mean_series()
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

function seasmean_mon_fldcor()
{

    # sel field
    cordex_SA ${ssrd} ${ssrd%.nc}.SA.nc
    cordex_SA ${clt} ${clt%.nc}.SA.nc

    # fld cor for each month
    cdo fldcor ${ssrd%.nc}.SA.nc ${clt%.nc}.SA.nc ssrd.clt.mon.fldcor.nc.temp

    # seasonal mean
    cdo seasmean ssrd.clt.mon.fldcor.nc.temp $fldcorf
}
function selseas()
{
    # sel seasons
    cdo selmon,1 $fldcorf ${fldcorf%.nc}.DJF.nc
    cdo selmon,7 $fldcorf ${fldcorf%.nc}.JJA.nc
}


#cor_seasonal_mean_series
#selseas
#exit

function cor_per_grid()
{
    # seasonal mean
    cdo seasmean $ssrd ${ssrd%.nc}.season.nc
    cdo seasmean $clt ${clt%.nc}.season.nc

    # sel field
    cordex_SA ${ssrd%.nc}.season.nc ${ssrd%.nc}.season.SA.nc
    cordex_SA ${clt%.nc}.season.nc ${clt%.nc}.season.SA.nc

    # sel season, by sel mon
    cdo selmon,1 ${ssrd%.nc}.season.SA.nc ${ssrd%.nc}.season.SA.DJF.nc
    cdo selmon,7 ${ssrd%.nc}.season.SA.nc ${ssrd%.nc}.season.SA.JJA.nc

    cdo selmon,1 ${clt%.nc}.season.SA.nc ${clt%.nc}.season.SA.DJF.nc
    cdo selmon,7 ${clt%.nc}.season.SA.nc ${clt%.nc}.season.SA.JJA.nc

    # timcor
    cdo timcor ${ssrd%.nc}.season.SA.DJF.nc ${clt%.nc}.season.SA.DJF.nc \
       ssrd.clt.fld.seasoncor.DJF.nc
    cdo timcor ${ssrd%.nc}.season.SA.JJA.nc ${clt%.nc}.season.SA.JJA.nc \
       ssrd.clt.fld.seasoncor.JJA.nc

}

cor_per_grid
