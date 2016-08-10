#!/bin/bash

# test_monthly_holds.sh
#
# Script for generating monthly email body text for TEST Library

DATE=$(date '+%A, %B %d, %Y')
REPORT_DATE=$(date --date='-1 month' +'%Y-%m')

echo "Hi,

Attached is your monthly old transit report for "$REPORT_DATE". These transits are over a month old from "$DATE". Please let us know if you have any questions.

Thank you,

Your Sage Help Squad"
