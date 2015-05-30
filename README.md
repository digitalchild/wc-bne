# WordCamp Brisbane Sample Code #

The following scripts utilise [WP-ClI](http://wp-cli.org) to create local [WordPress](http://wordpress.org) test/development environments. The first is a base script that will install a simple site with some common plugins. The second script will install and configure a [WooCommerce](http://www.woocommerce.com) store. 

These scripts were developed as apart of the demo for my talk at [WordCamp Brisbane 2015](https://brisbane.wordcamp.org/2015/). 

## wp-base.sh
This will install a local wordpress site in the sitedir location with the date appended to the end 

Variables that need to be modified. 

Open wp-base.sh and update the following variables to suit your needs. 

MYSQLUSER=mysqluser <br />
MYSQLPASS=mysqlpass  <br />
WEBROOT='/Path/To/Your/WebRoot'  <br />
BASE_PLUGINS='jetpack wordfence wordpress-seo wordpress-importer contact-form-7 google-sitemap-generator' <br />

<code>
Usage: 	./wp-base.sh sitedir sitename 
</code>

<code>
Example: ./wp-base.sh dev "My Local Dev Site"
</code>

This will create a directory called wcbne-YYYY-MM-DD (where the date is the current date) and will have a site called "My Local Dev Site" this will be located in the WEBROOT location. 

## wc-store.sh 

This script relays on the wp-base.sh script above and for this reason you will need to change your plugin list above. This will install and configure WooCommerce and install and configure the free [Storefront](https://wordpress.org/themes/storefront/) theme 

## Tested On

This has been tested on a MAMP stack but should also work on a linux/unix host. 