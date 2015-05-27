#!/bin/bash
# Usage: ./wc-base.sh sitedir sitename
# This script will create a local wordpress installation and install some commonly used plugins. 
# Tested on MAMP. 
# Author: Jamie Madden (https://digitalchild.info / https://github.com/digitalchild )

# This script was created to demonstrate how to use WordPress on the command line. 

# Change these variables to suit your environment 
MYSQLUSER='wordpress'
MYSQLPASS='wordpress'
WPADMINUSER='devadmin'
WPADMINEMAIL='test@test.com'
WEBROOT='/Users/jamie/Sites' 
BASE_PLUGINS='jetpack wordfence wordpress-seo wordpress-importer contact-form-7 google-sitemap-generator'

##### DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING !!!! #####

EXPECTED_ARGS=2
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: $0 sitedir sitename"
  exit $E_BADARGS
fi

# Generate a Password 
genpasswd() {
	local l=$1
       	[ "$l" == "" ] && l=16
      	openssl rand -base64 $l
}

#check that wordpress-cli is installed 
# asssumes you have installed wp-cli into your path and renamed it to wp and it is in your $PATH
checkwpcli() {
    if hash wp 2>/dev/null; then
        echo 'wp-cli installed.'; 
    else
        echo 'wp-cli is required. Download and install available from http://wp-cli.org/'; 
        exit 0; 
    fi
}

# Generate a database name or user 
gendbdetails(){ 
local l=$1
       	[ "$l" == "" ] && l='development'
	DATE=`date +"%Y-%m-%d"`
	echo $l'-'$DATE
}

# Create the database and user, grant privileges. 
createdb() { 
	# Does the database already exist?
	RESULT=`mysqlshow --user=$4 --password=$5 $1 > /dev/null 2>&1 && echo $1`
	if [ "$RESULT" == "$1" ]; then
	    echo "Database already exists, exiting."
	    exit 0; 
	fi
	MYSQL=`which mysql`
	Q1="CREATE DATABASE IF NOT EXISTS  \`$1\`;"
	Q2="GRANT USAGE ON *.* TO \`$2\`@localhost IDENTIFIED BY '$3';"
	Q3="GRANT ALL PRIVILEGES ON \`$1\`.* TO \`$2\`@localhost;"
	Q4="FLUSH PRIVILEGES;"
	SQL="${Q1}${Q2}${Q3}${Q4}"
	$MYSQL -u$4 -p$5 -e "$SQL"
}

DBUSER=`gendbdetails dev`
DBPASS=`genpasswd 8`
DBNAME=`gendbdetails $1`
THEDATE=`date +"%Y-%m-%d"`
INSTALLDIR=$1'-'$THEDATE
SITEURL='http://localhost/'$INSTALLDIR
SITENAME=$2
SITEDIR=$WEBROOT/$INSTALLDIR
ADMINUSER=$WPADMINUSER
ADMINEMAIL=$WPADMINEMAIL
ADMINPASS=`genpasswd 8`

echo '---------------------------------------------'
echo 'Creating new site.....'
echo '---------------------------------------------'

# Does the directory already exist? 
if [[ -d "${SITEDIR}" && ! -L "${SITEDIR}" ]] ; then
    echo "This sites directory already exists, exiting..."
    exit 0;
fi

mkdir -p $SITEDIR; 
echo "Site directory created in $WEBROOT"; 

createdb $DBNAME $DBUSER $DBPASS $MYSQLUSER $MYSQLPASS
echo "Database $DBNAME created...."

cd $SITEDIR; 

wp core download
rm -rf wp-config-sample.php
wp core config --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASS --dbhost=localhost
IFS='%'
wp core install --url=""$SITEURL"" --title="$SITENAME" --admin_user="$ADMINUSER" --admin_password="$ADMINPASS" --admin_email="$ADMINEMAIL"
unset IFS
echo 'Base Wordpress configuration completed....'

wp plugin install --activate $BASE_PLUGINS
echo 'Common plugins install completed....'

# Create base pages Home, contact, about, privacy policy, terms


echo "---------------------------------------------"
echo "New site created."
echo "Link $SITEURL"
echo "Username: $ADMINUSER"
echo "Password: $ADMINPASS"
echo "---------------------------------------------"
open $SITEURL