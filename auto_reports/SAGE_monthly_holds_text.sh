#!/bin/bash

# monthly_holds.sh
#
# Script for generating monthly email body text for TEST Library

DATE=$(date '+%A, %B %d, %Y')

echo "Hi,

Attached is your monthly hold report run on "$DATE". Please let us know if you have any questions.

Thank you,

Your Sage Help Squad"
