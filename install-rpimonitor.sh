#!/bin/bash

# Install rpimonitor on a pine64 running ubuntu (may work for debian also)
#
# Run latest version directly from github when logged in as root / sudo with
# wget -q -O - https://raw.githubusercontent.com/pfeerick/pine64-scripts/master/install-rpimonitor.sh | /bin/bash
#
# Original code lifted from http://kaiser-edv.de/tmp/4U4tkD/install-rpi-monitor-for-a64.sh
# Original code written by tkaiser, as well as assuggestions for a deriverative work
#
# This modification written by pfeerick

if [ "$(id -u)" != "0" ]; then
        echo "This script must be executed as root. Exiting" >&2
        exit 1
fi

useEncodedPublicKey()
{
    echo -e "\nUsing backup copy of public key for Armbian package list"
    cd /tmp && echo "LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tClZlcnNpb246IFNLUyAxLjEuNgpD
b21tZW50OiBIb3N0bmFtZToga2V5cy5mc3Bwcm9kdWN0aW9ucy5iaXoKCm1RSU5CRlVHOHA0QkVB
REdsc2VHRm1kampmbW9YdEhwWnhxZ1lIR3dlQ25HWjA1TGlHZ0VWZ2J2NVNyVHNKc3lPOEg4UnlC
UAp4Z2JwS0VZK0pDVjFJbFlRUGFFM1RpbDEra3FtUjRYTktidWZqRXVxQVY0VkpXMzI2N3RZUnVK
MzA4RTcwcTdrcFFTc0VBV0wKVlkreFYvbDVzdEF1cHA0L3dGNUJQZEFqVzdnTHVpY1BucW9LSzBq
Y2ZyanV2ZDQ1V0ZocGpMMVNkZDBQbklMZWh6MHRvNlIyCkg5TXNXK1ZZWVBGenRkakJNLzc4VUQ4
Z3JNY0NtLzdNejhFTlJLQ25US3JnajRicFdBMGtQRUhOQmZhb1FRVWs1ZkNKWU5NTAp2TE1JR1pj
V2VHT1BvK3lGbmw0QzZxVEVnczBnNy8wRTU2eWNhUURKK2dCQ0g5WU5hOGozZUgvdDF2TU4wRVJY
aU9RZjZXWGcKUmloT0QxZmNuWkZtY3pRRlQzR0dodjN5Ky9jVXBzVWxtaGhKNnRldGl1WE51VGZy
bDNNKzk5cVVxNS84aWlxMjkyTUNtbjVzCjBCRU9peWZRMmwydVptanlEVU8rNGxMOW8zTVgwVzVY
cDFwdUUycDQyYit3NDU4YURLdXVGdkJ6Vk1pVTUxSnM2RFpuYWh4dQoycytORHp0RGd1dDdwK1A2
MFVCQ2JsdFhFQjBaSXlXVEFrS0N3SWxhcFo5eURpSHFYaU5sdVRkQmlGV0d5VTN4bGI0ZnVRencK
bHd2bVMzeXo0QWs1R0NkRHBpTG1Kb0hPS1Y2cTg1VmFJNFQzZ2l4eDRKd0VmZGluY09HZmVwU1dG
bWJFc0R1Vng1dmJEVjVECndiM29BZzgwenAzVy91TnlYN0c0MXVJR0ROelpMODJwMlh0Z0d6a2po
RWJLQW5OYXZ3QVJBUUFCdEQxSloyOXlJRkJsWTI5MgpibWxySUNoTWFuVmliR3BoYm1Fc0lGTnNi
M1psYm1saEtTQThhV2R2Y2k1d1pXTnZkbTVwYTBCbmJXRnBiQzVqYjIwK2lRSTQKQkJNQkFnQWlC
UUpWQnZLZUFoc0RCZ3NKQ0FjREFnWVZDQUlKQ2dzRUZnSURBUUllQVFJWGdBQUtDUkNUMW9pZm53
NTQxVDZXCkQvMFgrTEQ5R20xTlZnWmhySDM1b1EzenN0RU5yVGpENkxGK2tUK3poZTZRUjliQWRP
bWViN0plNDIzeS9VWTNuU2FKbFMvTwpXc0pzODl0WFV5RTJqYnh0TEFwTjZPTVRac0l4amd5ZzNm
amJIVi9sdy94R3ArY3FIalgrQXk1UVp1ZEpWeEdKTjdXSmFSR3gKeW1qb3A3RVg0Q0hpaWRHWlBa
b0RUMjNXQXJMaWE3RThNTEIvb0szd1c2azlRbGMyU3JobGR6cHVTbU93SFFYOXB4bXk5ZGdmClph
MmE5dzFjRXZrdERucml6UG1meHdZYUMzOEZLUnF6MUk4Q25QTUVTVkorNm1MRVl4V0p2SkFOdVZ2
cmhxT3Rqa1k2eUkwdQpTT0ZIc21nY2krM1gyYzdXV2hsb0t1Yi9QZjdUdE02dGw2UkNIZkt2bnNy
VFpQdnhQMS9DZ3pRaUFJVFdwcEJsb2xuU1JIWHAKM25vdENGMXJWYmdJbndWdUNaQ3VXUEp2SEM2
UjN0OS9VZ0VTYW8wdEV3cjRtdzdqTnd0c3pXb3U0cll6akVBTUUvTy9rQkJXClBiRFVSbS80Ujhs
MFhTbkcwemhlUEt2NWlDemVRYkl6VWVBRDFEY3ZrN2ZhbGdubDlGWDkvTFpDWTFrRXdGTWYyREcw
M2x3Rwo3YzRJQ1NWQXowcE5FUFpkcXB5Q2w4MlZLa0RuZThQQTBSYi91UElPUVkzYUR1OGJnY1BR
dW9rbVJSTDRyd2RuUkNWcjBBRkQKWmhWUW5VamNkeThBdkVQZXllMmZOZExodGUrS1VXaXlGTldw
MnZXMkxiSjlHeFBzdGFGaWhYWkJjQ0VwR1dzTkhlYkRkMUttCk5HeVBLY3F6YUlmekhQTFA4K2Vl
MmRlS0E5NVBWelYzaVRMK09ia0NEUVJWQnZLZUFSQUF2R2FLQ0hER2wwZUM3ZkZvazVzUApxMVdh
dHRwcVE5UUwwQmdaOTVWUUxuKzcvMW5YbUtzRGZDd0N2bkJHcUxYelBReXZXaENiQ1ROOW9Za3Fv
a0JYMkNoMXpPSUEKQnludytVQ00rS3laY21jaVlaSUYyMU9zdFdNTTBuUTA2am5vNUhxMXZTSGxn
VGthYVlXWllvcVhvY01DUzlsbHZJMk5WRzM0CmJjYWsxaEFoOUVrZm1UaFZ0dERlR1pQK29zcXQy
bWVmcENBVklUUDFlUVdVM1JVQnBPS05wdGhwTHhNaHkrbDdtOHRta0xIMwpGdXF3WnZWalkyNDF3
MW80QVdWcEpEL0pkT3VBZkh0ZjcvVURQY2hTWkxlOUVhOFkrYm5raVp4Z1NST3RGclJ6YlZ3UDFJ
ZDQKUktUNDRCd0tNclh1OEdpWkFQdlFxNUN2SU5xWkRNcWlxcTQrakZKUE1Wb3J0dXhYc2tSaDFk
VllPaW9IMW11emVIZjU2MC9CCkxXK21CdUVkK3hFMGdkNlNYUmdQaWZsUk95bHBKQ2I5UXhpOE9m
cTZGRUhCZko4bUh6NDlkNjBxeVhaTmRObHhMaEEzZGZPdgphYWhGQmdYd05Td2phazB6ZjZScHVm
QWtoOFNpNWpjM1FoN2xwdXdzQmVseU51N3RCYkwyeThXblVlei8rYWVYOXNCU3FzNzgKbWZwRGRM
QUduSWxUOVljamtIbDVXMzg1ampoQkFocEFnaUxJc2RTUktjYzJDSTM0VmY3NzVjTExJWXJjQnJq
Vk1MWUJ3RWlaCkhPUE85MExuaXpneDFsNXQxd0cyQWE1T2FyVFRVUElnTWlUVXRLUFE4Qm1jakdN
WmlhdmRKd3FHVXppREQraE1LY3hQVU1qeQpZaXUrbmdrSDFST3VDeE1BRVFFQUFZa0NId1FZQVFJ
QUNRVUNWUWJ5bmdJYkRBQUtDUkNUMW9pZm53NTQxV203RC9zRzBvdU0KNzFjNW1UK2VnZmYrUXhm
RXh5K0pCNC92TDFwTFNIYk1SOEF0QUpMTitZaDZFemVHbVcydGdhMEJrOUF4RWVrUXJhWHJNRmha
ClNwVDk4cUpubkRwZG96ZmVJQXlUd3ppdzlLOW9wQjBkVS8rTTNzVmlka0o1bXY0TFc2Q0phYVkz
cnNvbTBUSWpheEJ2WHFTZQphZEpGNFdHVUh6ZzNldys4YWgwWkc4U0RadTE5a2V0TjJjblRNQXRn
Tys1M0VwanFwazN1TUY1aE5hRUh0OXdWajJ0cS9hbkwKRXNsNFQ1VS9la1FuZHhjVEVzVjJLSVZT
b3llMzV5ZTRhYW0xZ1doVzlKSUZ0U2hoRXRYRC81T3Z0ajcwNllMVFA4NFU4eUhTCnR6TTZMTEdw
cU04YmIxUXNCVVdSVWhJS2lkbHRtTzlLalg2ckpadWh3a2NWSkpZUmRiZXRFWGJpU0l5ZU5aeTdi
QmU0RW4rZgpWY04wZWtCRDM2TGhNY1ZMOEYxTW50cjFMNXhmMGNGRXBGcEVvZFFVdmNheU5ncEky
eTdFSVBqS21LaFZ3VzVkeDM2UTBDc0MKbndjQytLZzZCTnpsaUk5SXMrb0EyQVZJYW5GUHZqdlN3
Zkc5cEgrMi91K0tCNEhUMlV4MUZCYkJpNUdBd28rY3UxZDRYQWM1CmJaSGRQbkFWdG5JTjlkS1J1
c1o4SUdIV0VkOFB3MGtSZXB1TmhTbVNOQUxRa1M2QitwcFFadG1vR3NCQ3FKZU1QeFF4ait5SQov
YkwzZG1BMlVYeG5HSjN2czJ5YkZ5SEczYW9vdktKZldWeXR4T0pmRzdxajFBQ3JPWU9YZWtXbGN3
NWxFaVlGY2NrdWtOcXEKRnYvQ1hoK0JaRmxRVDRERHZKbFkwL0tRRkZLb2dRPT0KPUkvUDgKLS0t
LS1FTkQgUEdQIFBVQkxJQyBLRVkgQkxPQ0stLS0tLQo=" | base64 --decode > keyfile

    if [ -f /tmp/keyfile ]; then
        apt-key add /tmp/keyfile
        local keyAddState=$?

        rm /tmp/keyfile

        if [ $keyAddState -ne 0 ]; then
            echo -e "\033[0;31m\nUnable to add backup public key... exiting\033[0m"

            if [ -f /etc/apt/sources.list.d/armbian.list ]; then
               #remove if not Armbian
               if [ ! -f /etc/armbian-release ]; then rm /etc/apt/sources.list.d/armbian.list; fi
            fi

            exit 2
        fi
    else
        echo -e "\033[0;31m\nUnable to use provided backup public key... exiting\033[0m"

        if [ -f /etc/apt/sources.list.d/armbian.list ]; then
           #remove if not Armbian
           if [ ! -f /etc/armbian-release ]; then rm /etc/apt/sources.list.d/armbian.list; fi
        fi

        exit 1
    fi
} #useEncodedPublicKey

PatchRPiMonitor_for_sun50iw1p1()
{
    echo -e "\nNow patching RPi-Monitor to deal correctly with A64"
    cd /etc/rpimonitor/ && echo "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
1ra2ta1tbWvbfdp/A41zs94AeAAA" | base64 --decode | tar xzf -
   
   which systemctl >/dev/null 2>&1
   case $? in
        0)
            # Jessie
            systemctl restart rpimonitor >/dev/null 2>&1
            ;;
        *)
            # Wheezy|Trusty
            /etc/init.d/rpimonitor stop >/dev/null 2>&1
            /etc/init.d/rpimonitor start >/dev/null 2>&1
            ;;
    esac
} # PatchRPiMonitor_for_sun50iw1p1

cleanupPackageLists()
{
    echo -e "\nCleaning up package lists"

    if [ -f /etc/apt/sources.list.d/armbian.list ]; then
        #remove if not Armbian
        if [ ! -f /etc/armbian-release ]; then 
            rm /etc/apt/sources.list.d/armbian.list
            apt-key del 9F0E78D5 >/dev/null 2>&1
            apt-get update
       fi
    fi
} # cleanupPackageLists

echo -e "$(date) Start RPi-Monitor installation\n"

echo -e "Checking for dpkg lock\c"
while true ; do
    fuser /var/lib/dpkg/lock >/dev/null 2>&1 || break
    sleep 3
    echo -e ".\c"
done

echo -e "\nAdding Armbian package list"
if [ ! -f /etc/apt/sources.list.d/armbian.list ]; then
    echo 'deb http://apt.armbian.com xenial main utils xenial-desktop' > \
    /etc/apt/sources.list.d/armbian.list

    apt-key adv --keyserver keys.gnupg.net --recv-keys 0x93D6889F9F0E78D5 >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        useEncodedPublicKey
    fi
fi

echo -e "\nUpdating package lists"
apt-get update

echo -e "\nInstalling rpimonitor (this may take several minutes)..."
apt-get -f -qq -y install rpimonitor
/usr/share/rpimonitor/scripts/updatePackagesStatus.pl &

cleanupPackageLists

PatchRPiMonitor_for_sun50iw1p1

echo -e "\n$(date) Finished RPi-Monitor installation"
echo -e " \nNow you're able to enjoy RPi-Monitor at http://$((ifconfig -a) | sed -n '/inet addr/s/.*addr.\([^ ]*\) .*/\1/p' | head -1):8888"
