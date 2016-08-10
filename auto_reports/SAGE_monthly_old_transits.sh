#!/bin/sh

# TEST_monthly_old_transits.sh
#
# Script for generating monthly old transit reports for $ORG Library

# Define our variables

BASEDIR=/home/opensrf/scripts
DATE=$(date '+%Y-%m')
REPORT_DATE=$(date --date='-1 month' +'%Y-%m')
FOLDER=auto_reports
ORG=SAGE
RECIPIENT=brentwmills@gmail.com
MV_DEST=/openils/var/web/weekly/reports/monthly_old_transits

# Run the SQL report to get csv output

psql -U evergreen -h db -f $BASEDIR/$FOLDER/$ORG'_monthly_old_transits'.sql evergreen

# Insert Title at beginning and Delete the last line from the csv (number of rows)

sed -e '1 i Old Transits Report for '$REPORT_DATE'|' -e '1 i \ |' -e '$d' $BASEDIR/$FOLDER/$ORG'_monthly_old_transits2'.csv > $BASEDIR/$FOLDER/$ORG'_monthly_old_transits'.csv

rm $BASEDIR/$FOLDER/$ORG'_monthly_old_transits2'.csv

# Convert csv to xls

$BASEDIR/$FOLDER/'csv2xlsx'.pl -s '|' -v 1 $ORG'_monthly_old_transits'.csv  -o $BASEDIR/$FOLDER/$REPORT_DATE'_'$ORG'_monthly_old_transits'.xlsx

# Create email text for the day

$BASEDIR/$FOLDER/$ORG'_monthly_old_transits_text'.sh > $BASEDIR/$FOLDER/$ORG'_email_text_'$REPORT_DATE.txt

# E-mail out the report

mutt -s "Monthly Old Transits for $REPORT_DATE" -a $BASEDIR/$FOLDER/$REPORT_DATE'_'$ORG'_monthly_old_transits'.xlsx -- $RECIPIENT < $BASEDIR/$FOLDER/$ORG'_email_text_'$REPORT_DATE.txt

# Copy new reports over to web directory

for f in *.xlsx
do
  echo "Moving $f"
  mv $BASEDIR/$FOLDER/$REPORT_DATE'_'$ORG'_monthly_old_transits'.xlsx $MV_DEST/$REPORT_DATE'_'$ORG'_monthly_old_transits'.xlsx
done

# Remove leftovers

rm $BASEDIR/$FOLDER/$ORG'_monthly_old_transits'.csv
#rm $BASEDIR/$FOLDER/$ORG'_wkly_hlds_'$DATE.xlsx
rm $BASEDIR/$FOLDER/$ORG'_email_text_'$REPORT_DATE.txt

#Refresh Web Directory
cd "/openils/var/web/weekly" && ./create-index.sh
