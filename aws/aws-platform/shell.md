**\* grep for Exception in 5 folders deep\*\***

find . -maxdepth 5 -type f -name "\*.log" -exec grep -i "Exception" {} \;
