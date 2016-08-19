#!/bin/bash

# test_monthly_cancelled_holds_text.sh
#
# Script for generating monthly email body text for TEST Library

DATE=$(date '+%A, %B %d, %Y')

echo "Hi,
Attached is your monthly cancelled holds report for "$DATE". This report breaks down hold cancellations for the prior month and their reason for the cancellation.
Please let us know if you have any questions.

Thank you,
Your Sage Help Squad"
