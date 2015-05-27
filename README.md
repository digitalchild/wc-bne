# wc-bne
WordCamp Brisbane Sample Code

Variables that need to be modified. 

Open wp-base.sh and update the following variables to suit your needs. 

MYSQLUSER=mysqluser
MYSQLPASS=mysqlpass
WEBROOT='/Path/To/Your/WebRoot' 
BASE_PLUGINS='jetpack wordfence wordpress-seo wordpress-importer contact-form-7 google-sitemap-generator'


# WP-Base 
This will install a local wordpress site in the sitedir location with the date appended to the end 

<code>
Usage: 	./wp-base.sh sitedir sitename 
</code>

<code>
Example: ./wp-base.sh dev "My Local Dev Site"
</code>
