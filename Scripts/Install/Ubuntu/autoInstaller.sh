#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2013 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Options
# instance = name of instance
# used http://rsalveti.wordpress.com/2007/04/03/bash-parsing-arguments-with-getopts/
# for guidance

usage()
{
    cat << EOF
    usage: $0 options

    This script will automatically create a VistA instance for GT.M on Ubuntu

    DEFAULTS:
      Alternate VistA-M repo = https://github.com/OSEHRA/VistA-M.git
      Install EWD.js = false
      Install CWF = false
      Install dEWDrop globals = false
      Create Development Directories = false
      Instance Name = OSEHRA
      Post Install hook = none
      Skip Testing = false
      Running under Vagrant = false

    OPTIONS:
      -h    Show this message
      -a    Alternate VistA-M repo (Must be in OSEHRA format)
      -c    Install CareWeb Framework (assumes development directories)
      -e    Install EWD.js (assumes development directories)
      -d    Create development directories (s & p)
      -g    Install dEWDrop globals
      -i    Instance name
      -p    Post install hook (path to script)
      -s    Skip testing
      -v    Running under Vagrant

EOF
}

while getopts ":ha:cedgi:p:sv" option
do
    case $option in
        h)
            usage
            exit 1
            ;;
        a)
            repoPath=$OPTARG
            ;;
        d)
            developmentDirectories=true
            ;;
        c)
            installCWF=true
            developmentDirectories=true
            ;;
        e)
            installEWD=true
            developmentDirectories=true
            ;;
        g)
            installDDG=true
            ;;
        i)
            instance=$(echo $OPTARG |tr '[:upper:]' '[:lower:]')
            ;;
        p)
            postInstall=true
            postInstallScript=$OPTARG
            ;;
        s)
            skipTests=true
            ;;
        v)
            isVagrant=true
            ;;
    esac
done

# Set defaults for options
if [[ -z $repoPath ]]; then
    repoPath="https://github.com/OSEHRA/VistA-M.git"
fi

if [[ -z $developmentDirectories ]]; then
    developmentDirectories=false
fi

if [[ -z $installCWF ]]; then
    installCWF=false
fi

if [[ -z $installEWD ]]; then
    installEWD=false
fi

if [[ -z $installDDG ]]; then
    installDDG=false
fi

if [[ -z $instance ]]; then
    instance=osehra
fi

if [[ -z $postInstall ]]; then
    postInstall=false
fi

if [ -z $skipTests ]; then
    skipTests=false
fi

if [ -z $isVagrant ]; then
    isVagrant=false
fi

# Summarize options
echo "Using $repoPath for routines and globals"
echo "Create development directories: $developmentDirectories"
echo "Installing an instance named: $instance"
echo "Installing CWF: $installCWF"
echo "Installing EWD.js: $installEWD"
echo "Installing dEWDrop globals: $installDDG"
echo "Post install hook: $postInstall"
echo "Skip Testing: $skipTests"
echo "Running under Vagrant: $isVagrant"

# Get primary username if using sudo, default to $username if not sudo'd
if [[ -n "$SUDO_USER" ]]; then
    primaryuser=$SUDO_USER
elif [[ -n "$USERNAME" ]]; then
    primaryuser=$USERNAME
else
    echo Cannot find a suitable username to add to VistA group
    exit 1
fi

echo This script will add $primaryuser to the VistA group

# Abort provisioning if it appears that an instance is already installed.
test -d /home/$instance/g &&
{ echo "VistA already Installed. Aborting."; exit 0; }

# control interactivity of debian tools
export DEBIAN_FRONTEND="noninteractive"

# extra utils - used for cmake and dashboards and initial clones
# Note: Amazon EC2 requires two apt-get update commands to get everything
echo "Updating operating system"
apt-get update -qq > /dev/null
apt-get update -qq > /dev/null
apt-get install -qq -y build-essential cmake-curses-gui git dos2unix daemon > /dev/null

# Clone repos
cd /usr/local/src
git clone -q https://github.com/OSEHRA/VistA -b dashboard VistA-Dashboard

# If running under Vagrant, fix line endings. if it doesn't clone the repo
if $isVagrant; then
    scriptdir=/vagrant/Scripts/Install

    # Fix line endings
    find /vagrant -name \"*.sh\" -type f -print0 | xargs -0 dos2unix > /dev/null 2>&1
    find /vagrant -name \"*.kid\" -type f -print0 | xargs -0 dos2unix > /dev/null 2>&1
    find /vagrant -name \"*.rsa\" -type f -print0 | xargs -0 dos2unix > /dev/null 2>&1
    find /vagrant -name \"*.xml\" -type f -print0 | xargs -0 dos2unix > /dev/null 2>&1
    dos2unix $scriptdir/EWD/etc/init.d/ewdjs > /dev/null 2>&1
    dos2unix $scriptdir/GTM/etc/init.d/vista > /dev/null 2>&1
    dos2unix $scriptdir/GTM/etc/xinetd.d/vista-rpcbroker > /dev/null 2>&1
    dos2unix $scriptdir/GTM/etc/xinetd.d/vista-vistalink > /dev/null 2>&1
    dos2unix $scriptdir/GTM/gtminstall_SHA1 > /dev/null 2>&1
else
    scriptdir=/usr/local/src/VistA/Scripts/Install
    if [ ! -d "$scriptdir" ] then
    	git clone -q https://github.com/mdgeek/VistA-FHIR-CWF.git /usr/local/src/VistA
    fi
fi

# bootstrap the system
cd $scriptdir
./Ubuntu/bootstrapUbuntuServer.sh

# Ensure scripts know if we are RHEL like or Ubuntu like
export ubuntu=true;

# Install GTM
cd GTM
./install.sh

# Create the VistA instance
./createVistaInstance.sh -i $instance

# Modify the primary user to be able to use the VistA instance
usermod -a -G $instance $primaryuser
chmod g+x /home/$instance

# Setup environment variables so the dashboard can build
# have to assume $basedir since this sourcing of this script will provide it in
# future commands
source /home/$instance/etc/env

# Get running user's home directory
# http://stackoverflow.com/questions/7358611/bash-get-users-home-directory-when-they-run-a-script-as-root
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

# source env script during running user's login
echo "source $basedir/etc/env" >> $USER_HOME/.bashrc

# Build a dashboard and run the tests to verify installation
# These use the Dashboard branch of the VistA repository
# The dashboard will clone VistA and VistA-M repos
# run this as the $instance user
if $skipTests; then
    # Clone VistA-M repo
    cd /usr/local/src
    git clone --depth 1 $repoPath VistA-Source

    # Go back to the $basedir
    cd $basedir

    # Perform the import
    su $instance -c "source $basedir/etc/env && $scriptdir/GTM/importVistA.sh"
else
    # create random string for build identification
    # source: http://ubuntuforums.org/showthread.php?t=1775099&p=10901169#post10901169
    export buildid=`tr -dc "[:alpha:]" < /dev/urandom | head -c 8`

    # Import VistA and run tests using OSEHRA automated testing framework
    su $instance -c "source $basedir/etc/env && ctest -S $scriptdir/Ubuntu/test.cmake -V"
    # Tell users of their build id
    echo "Your build id is: $buildid you will need this to identify your build on the VistA dashboard"
fi

# Enable journaling
su $instance -c "source $basedir/etc/env && $basedir/bin/enableJournal.sh"

# Restart xinetd
service xinetd restart

# Add p and s directories to gtmroutines environment variable
if $developmentDirectories; then
    su $instance -c "mkdir $basedir/{p,p/$gtmver,s,s/$gtmver}"
    perl -pi -e 's#export gtmroutines=\"#export gtmroutines=\"\$basedir/p/\$gtmver\(\$basedir/p\) \$basedir/s/\$gtmver\(\$basedir/s\) #' $basedir/etc/env
fi

# Install dEWDrop globals
if $installDDG; then
    cd $scriptdir/DDG
    ./ddg.sh
    cd $basedir
fi

# Install CWF
if $installCWF; then
    cd $scriptdir/CWF
    ./cwf.sh
    cd $basedir
fi

# Install EWD.js
if $installEWD; then
    cd $scriptdir/EWD
    ./ewdjs.sh
    cd $basedir
fi

# Post install hook
if $postInstall; then
    su $instance -c "source $basedir/etc/env && $postInstallScript"
fi

# Ensure group permissions are correct
chmod -R g+rw /home/$instance
