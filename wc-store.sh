#!/bin/bash
# Usage: ./wc-store.sh sitedir sitename
# This script will create a local woocommerce installation and install some commonly used plugins. 
# Tested on MAMP. 
# Author: Jamie Madden (https://digitalchild.info / https://github.com/digitalchild )
# This script was created to demonstrate how to use WordPress on the command line. 

SCRIPT_DIR=`pwd`

source $SCRIPT_DIR/wp-base.sh "$@"

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

# Create base pages contact, about, privacy policy, terms
wp post create --post_type="page" --post_author=1 --post_status="publish" --post_title="About" --post_name="about" --post_content="About this awesome site goes here."

# Add the contact page & form 
FORMID=`wp post list --post_type="wpcf7_contact_form" --field="ID"`
wp post create --post_type="page" --post_author=1 --post_status="publish" --post_title="Contact" --post_name="contact" --post_content="[contact-form-7 id=\"$FORMID\" title=\"Contact form 1\"]"

# Add the terms and conditions page 
TERMS=`cat $SCRIPT_DIR/terms.txt` 
wp post create --post_type="page" --post_author=1 --post_status="publish" --post_title="Terms & Conditions" --post_name="terms-and-conditions" --post_content="$TERMS"

# Add the privacy page 
PRIVACYPOLICY=`cat $SCRIPT_DIR/privacy.txt` 
wp post create --post_type="page" --post_author=1 --post_status="publish" --post_title="Privacy Policy" --post_name="privacy-policy" --post_content="$PRIVACYPOLICY"

# Create the menu & assign it 
wp menu create "Primary Navigation" 
wp menu location assign "primary-navigation" primary 
wp menu location assign "primary-navigation" handheld 
wp menu item add-custom "primary-navigation" "Home" "$SITEURL"
wp menu item add-custom "primary-navigation" "Shop" "$SITEURL/shop/"
wp menu item add-custom "primary-navigation" "About" "$SITEURL/about/"
wp menu item add-custom "primary-navigation" "Terms & Conditions" "$SITEURL/terms-and-conditions/"
wp menu item add-custom "primary-navigation" "Privacy Policy" "$SITEURL/privacy-policy/"
wp menu item add-custom "primary-navigation" "Contact" "$SITEURL/contact/"

# Create secondary menu & assign it
wp menu create "Secondary Navigation" 
wp menu location assign "secondary-navigation" secondary 

wp menu item add-custom "secondary-navigation" "My Account" "$SITEURL/my-account/"

# Import all the content
wp import wp-content/plugins/woocommerce/dummy-data/dummy-data.xml --authors=create

# re-write the permalinks - basic permalink
wp rewrite structure /%postname%/ 
wp rewrite flush --hard

# Added the site details again just so you don't have to scroll up 
echo "---------------------------------------------"
echo "New site created."
echo "Link $SITEURL"
echo "Username: $ADMINUSER"
echo "Password: $ADMINPASS"
echo "---------------------------------------------"

open $SITEURL