#!/bin/sh
# You must have /bin/sh, don't have that, we don't have anything
# -- -- --- --
## funcs 
did_pass()
{
  if [ $1 -eq 0 ]; then
    echo "$2"
  else 
    echo "Something went wrong, sorry."
    exit 0
  fi
}

# The different pkg managers we support
# start them off as zero length strings
YUM=""
APT=""
RPM=""
LSB=""
PKGR=""

# We expect these to be in standard places, but frequently they're not... to much sadness
for name in '/bin' '/usr/bin' '/usr/local/bin' '/sbin' '/usr/sbin' '/usr/local/sbin'
do
 if [ -e "${name}/rpm" ]; then
   echo "found rpm at ${name}/rpm"
   RPM="${name}/rpm"
   PKGR=$RPM
 fi 

 if [ -e "${name}/yum" ]; then
   echo "found yum at ${name}/${YUM}"
   YUM="${name}/yum"
   PKGR=$YUM
 fi 

 if [ -e "${name}/apt-get" ]; then
   echo "found apt at ${name}/apt-get"
   APT="${name}/apt-get"
   PKGR=$APT
 fi 

 if [ -e "${name}/lsb_release" ]; then
   echo "found lsb_release at ${name}/lsb_release"
   LSB="${name}/lsb_release"
   REL=`$LSB --description`
 fi 
done

echo "System $REL"

## Installing Erlang section XXX pull into func
echo "Installing Erlang"
$PKGR -y install erlang

did_pass $? "Erlang installed"

## Argh, we need unzip as well and fricking wget
$PKGR -y install wget
$PKGR -y install unzip

## Installing the Elixir section XXX pull into func
echo "Grabbing Elixir..."
TMPDIR="/tmp/elixir$$"
mkdir $TMPDIR
cd $TMPDIR
wget https://github.com/elixir-lang/elixir/releases/download/v1.0.2/Precompiled.zip
unzip Precompiled.zip

# Install the BEAM binaries in the right spot
# we need to check if /usr/local/bin exists
cp -v bin/* /usr/local/bin
cd lib
cp -v -R * /usr/local/lib

did_pass $? "Elixir installed"

elixir -e 'IO.puts "hello from Elixir"'
did_pass $? "Elixir works"

exit 0
