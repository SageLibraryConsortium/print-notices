#!/bin/bash

# Delete all xlsx files in the reports directory ## Use for testings

find ./openils/var/web/weekly/reports/monthly*/ -name "*xlsx" -type f -exec rm {} \;
find ./openils/var/web/weekly/reports/weekly*/ -name "*xlsx" -type f -exec rm {} \;
