#!/bin/sh
############################################################################################################################
##		Download and install SubsSupport
##
## Command: wget https://raw.githubusercontent.com/emil237/SubsSupport/main/installer.sh -O - | /bin/sh
##
#######################################################################################################
TMPDIR='/tmp'
VERSION='1.5.8'
MY_URL='https://raw.githubusercontent.com/emil237/SubsSupport/main'
PYTHON_VERSION=$(python -c"import sys; print(sys.version_info.major)")

####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ]; then
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGLIST='opkg list-installed'
elif [ -f /etc/apt/apt.conf ]; then
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    OPKGLIST='apt-get list-installed'
    DPKINSTALL='dpkg -i --force-overwrite'
fi

if [ "$PYTHON_VERSION" -eq 3 ]; then
    echo ":You have Python3 image ..."
    PACKAGE_IPK='enigma2-plugin-extensions-subssupport-py3_1.5.8_all.ipk'
else
    echo ":You have Python2 image ..."
    if [ $OSTYPE = "Opensource" ]; then
        PACKAGE_IPK='enigma2-plugin-extensions-subssupport-py2_1.5.8_all.ipk'
    elif [ $OSTYPE = "DreamOS" ]; then
        PACKAGE_DEB='enigma2-plugin-extensions-subssupport_1.5.8_all.deb'
        PACKAGE="enigma2-plugin-extensions-subssupport"
    fi
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* >/dev/null 2>&1

if [ "$($OPKGLIST $PACKAGE | awk '{ print $3 }')" = $VERSION ]; then
    echo " You are use the laste Version: $VERSION"
    exit 1
elif [ -z "$($OPKGLIST $PACKAGE | awk '{ print $3 }')" ]; then
    echo
    clear
else
    $OPKGREMOV $PACKAGE
fi
$OPKG >/dev/null 2>&1
###################
#  Install Plugin #

echo "Insallling SubsSupport plugin Please Wait ......"

if [ $OSTYPE = "Opensource" ]; then
    wget $MY_URL/${PACKAGE_IPK}_${VERSION}_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE_IPK}_${VERSION}_all.ipk
elif [ $OSTYPE = "DreamOS" ]; then
    wget $MY_URL/${PACKAGE_DEB}_${VERSION}_all.deb -qP $TMPDIR
    $DPKINSTALL $TMPDIR/${PACKAGE_DEB}_${VERSION}.deb
    $OPKGINSTAL -f -y

fi
##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* >/dev/null 2>&1

sleep 2
clear
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       SubsSupport      : $VERSION                        *"
echo "**                       Uploaded by: Emil_Nabil                      *"
sleep 4;
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

exit 0
