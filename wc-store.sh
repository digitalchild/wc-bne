#!/bin/bash
# Usage: ./wc-store.sh sitedir sitename
# This script will create a local woocommerce installation and install some commonly used plugins. 
# Tested on MAMP. 
# Author: Jamie Madden (https://digitalchild.info / https://github.com/digitalchild )

# This script was created to demonstrate how to use WordPress on the command line. 

BASE_DIR="$(dirname "$0")"

source $BASE_DIR/wp-base.sh "$@"

cd $SITEDIR; 
# install woocommerce
wp plugin install woocommerce --activate 
# install the store front theme 
wp theme install storefront --activate  

# Create the WooCommerce Pages 
wp post create --post_type="page" --post_author=1 --post_status="publish" --post_title="Shop" --post_name="shop" 
wp post create --post_type="page" --post_author=1 --post_status="publish" --post_title="Cart" --post_name="cart" --post_content="[woocommerce_cart]"
wp post create --post_type="page" --post_author=1 --post_status="publish" --post_title="Checkout" --post_name="checkout" --post_content="[woocommerce_checkout]"
wp post create --post_type="page" --post_author=1 --post_status="publish" --post_title="My Account" --post_name="my-account" --post_content="[woocommerce_my_account]"
wp option delete "woocommerce_admin_notices"
echo 'WooCommerce pages created..'; 

# re-write the permalinks - basic permalink
wp rewrite structure /%postname%/ 