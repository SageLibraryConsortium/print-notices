#!/bin/sh

# TEST_monthly_cancelled_holds.sh
#
# Script for generating monthly cancelled holds stats for $ORG Library

# Define our variables

BASEDIR=/home/opensrf/scripts
DATE=$(date '+%Y-%m')
REPORT_DATE=$(date --date='-1 month' +'%Y-%m')
FOLDER=auto_reports
ORG=SAGE
RECIPIENT=brentwmills@gmail.com
MV_DEST=/openils/var/web/weekly/reports/monthly_cancelled_holds

# Run the SQL report to get csv output

psql -U evergreen -h db -f $BASEDIR/$FOLDER/$ORG'_monthly_cancelled_holds'.sql evergreen

# Insert Title at beginning and Delete the last line from the csv (number of rows)

sed -e '1 i Monthly Cancelled Holds Report for the month of '$REPORT_DATE'|' -e '1 i \ |' -e '$d' $BASEDIR/$FOLDER/$ORG'_monthly_cancelled_holds2'.csv > $BASEDIR/$FOLDER/$ORG'_monthly_cancelled_holds'.csv

rm $BASEDIR/$FOLDER/$ORG'_monthly_cancelled_holds2'.csv

# Convert csv to xls

$BASEDIR/$FOLDER/'csv2xlsx'.pl -s '|' -v 1 $ORG'_monthly_cancelled_holds'.csv  -o $BASEDIR/$FOLDER/$REPORT_DATE'_'$ORG'_monthly_cancelled_holds'.xlsx

# Create email text for the day

$BASEDIR/$FOLDER/$ORG'_monthly_cancelled_holds_text'.sh > $BASEDIR/$FOLDER/$ORG'_email_text_'$REPORT_DATE.txt

# E-mail out the report

mutt -s "$REPORT_DATE - Monthly Sage Cancelled Holds Report" -a $BASEDIR/$FOLDER/$REPORT_DATE'_'$ORG'_monthly_cancelled_holds'.xlsx -- $RECIPIENT < $BASEDIR/$FOLDER/$ORG'_email_text_'$REPORT_DATE.txt

# Copy new reports over to web directory

for f in *.xlsx
do
  echo "Moving $f"
  mv $BASEDIR/$FOLDER/$REPORT_DATE'_'$ORG'_monthly_cancelled_holds'.xlsx $MV_DEST/$REPORT_DATE'_'$ORG'_monthly_cancelled_holds'.xlsx
done

# Remove leftovers

rm $BASEDIR/$FOLDER/$ORG'_monthly_cancelled_holds'.csv
#rm $BASEDIR/$FOLDER/$ORG'_wkly_hlds_'$DATE.xlsx
rm $BASEDIR/$FOLDER/$ORG'_email_text_'$REPORT_DATE.txt

#Refresh Web Directory
cd "/openils/var/web/weekly" && ./create-index.sh
