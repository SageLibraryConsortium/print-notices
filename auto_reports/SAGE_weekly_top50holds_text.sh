#!/bin/bash

# test_weekly_holds.sh
#
# Script for generating weekly email body text for TEST Library

DATE=$(date '+%A, %B %d, %Y')

echo "Hi,

Attached is your monthly top 50 holds in Sage report for "$DATE". Please let us know if you have any questions.

Thank you,

Your Sage Help Squad"
