#!/bin/sh

# TEST_weekly_holds.sh
#
# Script for generating weekly hold stats for $ORG Library

# Define our variables

BASEDIR=/home/opensrf/scripts
DATE=$(date '+%F')
REPORT_DATE=$(date --date='-1 week' +'%Y-%m-%d')
FOLDER=auto_reports
ORG=SAGE
RECIPIENT=brentwmills@gmail.com
MV_DEST=/openils/var/web/weekly/reports/weekly_holds

# Run the SQL report to get csv output

psql -U evergreen -h db -f $BASEDIR/$FOLDER/$ORG'_weekly_holds'.sql evergreen

# Insert Title at beginning and Delete the last line from the csv (number of rows)

sed -e '1 i Holds Report for '$REPORT_DATE'|' -e '1 i \ |' -e '$d' $BASEDIR/$FOLDER/$ORG'_wkly_hlds2'.csv > $BASEDIR/$FOLDER/$ORG'_wkly_hlds'.csv

rm $BASEDIR/$FOLDER/$ORG'_wkly_hlds2'.csv

# Convert csv to xls

$BASEDIR/$FOLDER/'csv2xlsx'.pl -s '|' -v 1 $ORG'_wkly_hlds'.csv  -o $BASEDIR/$FOLDER/$REPORT_DATE'_'$ORG'_wkly_hlds'.xlsx

# Create email text for the day

$BASEDIR/$FOLDER/$ORG'_weekly_holds_text'.sh > $BASEDIR/$FOLDER/$ORG'_email_text_'$REPORT_DATE.txt

# E-mail out the report

mutt -s "$REPORT_DATE - Weekly Holds Fulfillment Report" -a $BASEDIR/$FOLDER/$REPORT_DATE'_'$ORG'_wkly_hlds'.xlsx -- $RECIPIENT < $BASEDIR/$FOLDER/$ORG'_email_text_'$REPORT_DATE.txt

# Copy new reports over to web directory

for f in *.xlsx
do
  echo "Moving $f"
  mv $BASEDIR/$FOLDER/$REPORT_DATE'_'$ORG'_wkly_hlds'.xlsx $MV_DEST/$REPORT_DATE'_'$ORG'_weekly_holds'.xlsx
done

# Remove leftovers

rm $BASEDIR/$FOLDER/$ORG'_wkly_hlds'.csv
#rm $BASEDIR/$FOLDER/$ORG'_wkly_hlds_'$DATE.xlsx
rm $BASEDIR/$FOLDER/$ORG'_email_text_'$REPORT_DATE.txt

# Refresh Web Directory
cd "/openils/var/web/weekly" && ./create-index.sh
