#!/bin/sh

# Clean Expired Age Protection.sh

# Define our variables

BASEDIR=/home/opensrf/scripts

# Run the SQL

psql -U evergreen -h dbprod -f $BASEDIR/$clean_age_protect/clean_age_p.sql evergreen
