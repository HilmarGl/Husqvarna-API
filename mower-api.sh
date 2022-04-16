#!/bin/bash
userdb=DFDFDF
dburl='http://'

#if (state = NULL)                                                                                                             
tokeninput=$(curl -s -X POST -d "grant_type=password&client_id=DFDFDF&username=DFDFDF&password=DFDFDF"  https://api.authentication.husqvarnagroup.dev/v1/oauth2/token)
export token=$(jq -r '.access_token' <<< $tokeninput)


input=$(curl -s -X GET https://api.amc.husqvarna.dev/v1/mowers/DFDFDFAPI -H 'Authorization: Bearer '$token -H 'Authorization-Provider: husqvarna' -H 'Content-Type: application/vnd.api+json' -H 'X-Api-Key: DFDFDF')


#echo $input


###Auswertung
activity=$(jq -r '.data.attributes.mower.activity' <<< $input)
state=$(jq -r '.data.attributes.mower.state' <<< $input)
batt=$(jq -r '.data.attributes.battery.batteryPercent' <<< $input)
#latitude=$(jq -r '.data.attributes.mower.errorCode' <<< $input)
#longitude=$(jq -r '.data.attributes.mower.errorCode' <<< $input)

#0-199 =red
#200-499=yellow
#500-999=good!



###CASE Error
case $state in
  IN_OPERATION)
    ;;

  PAUSED)
    statecode=200
    ;;

  RESTRICTED)
    statecode=202
    ;;
  OFF)
    statecode=201
    ;;
  STOPPED)
    statecode=202
    ;;
#  ERROR_AT_POWER_UP)
#    ;;

  *)
statecode=$(jq -r '.data.attributes.mower.errorCode' <<< $input)
    ;;
esac

###CASE Error 500-999
case $activity in
  MOWING)
    statecode=500
    ;;
  GOING_HOME)
    statecode=501
    ;;
  STOPPED_IN_GARDEN )
    statecode=203
    ;;
  CHARGING)
    statecode=502
    ;;
  LEAVING)
    statecode=503
    ;;
  PARKED_IN_CS )
    statecode=300
    ;;
  *)
    ;;
esac







###Senden
curl -s -X POST -u USER:PW $DBURL --data-binary 'mower value='$statecode''
curl -s -X POST -u USER:PW $DBURL --data-binary 'mowerbatt value='$batt''
