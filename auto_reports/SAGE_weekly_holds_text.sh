#!/bin/bash

# test_weekly_holds.sh
#
# Script for generating weekly email body text for TEST Library

DATE=$(date '+%A, %B %d, %Y')

echo "Hi,

Attached is your weekly hold report for "$DATE". Please let us know if you have any questions.

Thank you,

Your Sage Help Squad"
