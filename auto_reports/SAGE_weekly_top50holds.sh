#!/bin/sh

# TEST_top50holds.sh
#
# Script for generating top 50 holds for $ORG Library

# Define our variables

BASEDIR=/home/opensrf/scripts
DATE=$(date '+%F')
FOLDER=auto_reports
ORG=SAGE
RECIPIENT=brentwmills@gmail.com
MV_DEST=/openils/var/web/weekly/reports/weekly_top50holds

# Run the SQL report to get csv output

psql -U evergreen -h db -f $BASEDIR/$FOLDER/$ORG'_weekly_top50holds'.sql evergreen

# Insert Title at beginning and Delete the last line from the csv (number of rows)

sed -e '1 i Top 50 Holds in Sage for '$DATE'|' -e '1 i \ |' -e '$d' $BASEDIR/$FOLDER/$ORG'_weekly_top50holds2'.csv > $BASEDIR/$FOLDER/$ORG'_weekly_top50holds'.csv

rm $BASEDIR/$FOLDER/$ORG'_weekly_top50holds2'.csv

# Convert csv to xls

$BASEDIR/$FOLDER/'csv2xlsx'.pl -s '|' -v 1 $ORG'_weekly_top50holds'.csv  -o $BASEDIR/$FOLDER/$DATE'_'$ORG'_weekly_top50holds'.xlsx

# Create email text for the day

$BASEDIR/$FOLDER/$ORG'_weekly_top50holds_text'.sh > $BASEDIR/$FOLDER/$ORG'_email_text_'$DATE.txt

# E-mail out the report

mutt -s "Top 50 Holds in Sage for $DATE" -a $BASEDIR/$FOLDER/$DATE'_'$ORG'_weekly_top50holds'.xlsx -- $RECIPIENT < $BASEDIR/$FOLDER/$ORG'_email_text_'$DATE.txt

# Copy new reports over to web directory

for f in *.xlsx
do
  echo "Moving $f"
  mv $BASEDIR/$FOLDER/$DATE'_'$ORG'_weekly_top50holds'.xlsx $MV_DEST/$DATE'_'$ORG'_weekly_top50holds'.xlsx
done

# Remove leftovers

rm $BASEDIR/$FOLDER/$ORG'_weekly_top50holds'.csv
#rm $BASEDIR/$FOLDER/$ORG'_wkly_hlds_'$DATE.xlsx
rm $BASEDIR/$FOLDER/$ORG'_email_text_'$DATE.txt

#Refresh Web Directory
cd "/openils/var/web/weekly" && ./create-index.sh
