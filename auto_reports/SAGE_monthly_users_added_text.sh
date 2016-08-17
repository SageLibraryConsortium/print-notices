#!/bin/bash

# test_monthly_users_added_text.sh
#
# Script for generating monthly email body text for TEST Library

DATE=$(date '+%A, %B %d, %Y')

echo "Hi,
Attached is your monthly users added statistics report for "$DATE". This report details users added for the previous month. Please let us know if you have any questions.
Thank you,
Your Sage Help Squad"
