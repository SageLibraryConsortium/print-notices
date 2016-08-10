#!/bin/bash

# test_weekly_circ_stats_text.sh
#
# Script for generating weekly email body text for TEST Library

DATE=$(date '+%A, %B %d, %Y')

echo "Hi,

Attached is your weekly circulation statistics report for "$DATE". This report breaks down renewals vs. actual 
circulations. Add the two together for your full circulation count. Please let us know if you have any questions.

Thank you,

Your Sage Help Squad"
