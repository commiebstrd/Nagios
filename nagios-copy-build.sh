#/bin/bash -e

# Spenser Reinhardt - Dec 2013 - v1.0
#
# Used to copy nagios core code from local workstation to virtual machine for compilation tests, specifically works entirely in memory to avoid disk wear.
# Puts code in /tmp/nagios-code
# Puts binaries in /tmp/nagios-bins
# Makes with flags for these directories and 
# Uses etc and libexec from /usr/local/nagios/
# Web dirs are /nagios-dev and /nagios-dev/cgi

# set initial variables
code_dir="/tmp/nagios-code"
bin_dir="/tmp/nagios-bins"
make_opt=""

# if $1 not set use make all
if [[ -z $1 ]]; then
        make_opt="all"
else
        make_opt="$1"
fi


# create dirs
if [[ ! -d $code_dir ]]; then
        mkdir $code_dir
fi

if [[ ! -d $bin_dir ]]; then
        mkdir $bin_dir
fi

# set save IFS and set new one for dirs, create string for dir creation
IFS_temp="$IFS"
IFS=";"
dirs="sbin;bin;share;var;var/archives;var/rw;var/spool;var/spool/checkresults"

for folder in $dirs; do

        if [[ ! -d $bin_dir/$folder ]]; then
                mkdir $bin_dir/$folder
                #chown nagios:nagios $bins_dir/$folder
        fi
done

# reset IFS
IFS="$IFS_temp"

# copy from vbox mount to memory. avoid hdd
cp -rf /media/sf_Code/nagios-core/* $code_dir/

# go to dir and make
cd $code_dir

# make clean just in case
make clean
make distclean

# config to install in /tmp/nagios-bins
./configure --prefix="$bin_dir" --with-htmurl="/nagios-dev" --with-cgiurl="/nagios-dev/cgi"

# make with make_opt
make $make_opt

# copy newly built executables
cp -f $code_dir/base/{nagios,nagiostats} $bin_dir/bin/

# copy newly built cgis
cp -f $code_dir/cgi/{avail.cgi,cmd.cgi,config.cgi,histogram.cgi,history.cgi,notifications.cgi,outages.cgi,showlog.cgi,status.cgi,statusmap.cgi,statuswml.cgi,statuswrl.cgi,summary.cgi,tac.cgi,trends.cgi} $bin_dir/sbin/

# copy newly buily html and php files
cp -rf $code_dir/html/* $bin_dir/share/

# symlink things that dont get created, if they do not exist
if [[ ! -d ${bin_dir}/libexec/ ]]; then
        ln -s /usr/local/nagios/libexec/ ${bin_dir}/libexec
fi

if [[ ! -d ${bin_dir}/etc/ ]]; then
        ln -s /usr/local/nagios/etc/ ${bin_dir}/etc
fi

# set permissions
chown -R nagios:nagios ${bin_dir}/
chmod -R g+s ${bin_dir}/var/rw

echo "Provided no errors, build in $bin_dir should be complete"
echo "Available at: http://$hostname/nagios-test"

