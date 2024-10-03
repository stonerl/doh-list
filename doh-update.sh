#!/bin/bash

# Define the file path for the DNS-over-HTTPS markdown file
FILE="curl.wiki/DNS-over-HTTPS.md"

# Initialize FULL_URLS_FILE as an empty string
FULL_URLS_FILE=""

# Check if the file exists and is readable
if [ -r "$FILE" ]; then
	# Extract full URLs from the "Base URL" column of the table in the markdown file
	FULL_URLS_FILE=$(awk '
		BEGIN { capture = 0; }
		/^# Publicly available servers/ { capture = 1; }
		/^# Private DNS Server with DoH setup examples/ { capture = 0; exit; }
		capture && /^\|/ {
			split($0, columns, "|");
			print columns[3];
		}
	' "$FILE" | grep -oP 'https://[a-zA-Z0-9./?=_%:-]+')
else
	echo "Warning: File $FILE not found or not readable. Proceeding with AdGuard data only."
fi

# Get the current date for the "Last modified" entry
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Fetch AdGuard DNS providers page content
ADGUARD_PAGE_CONTENT=$(curl -s "https://adguard-dns.io/kb/general/dns-providers/")

# Extract DNS-over-HTTPS URLs from the AdGuard page if content is available
FULL_URLS_ADGUARD=""
if [ -n "$ADGUARD_PAGE_CONTENT" ]; then
	FULL_URLS_ADGUARD=$(echo "$ADGUARD_PAGE_CONTENT" |
		awk 'BEGIN { RS = "<tr>"; FS = "<td>"; OFS = "" }
			 /DNS-over-HTTPS/ {
				 for (i = 1; i <= NF; i++) {
					 if ($i ~ /https:\/\/[a-zA-Z0-9./?=_%:-]+/) {
						 match($i, /https:\/\/[a-zA-Z0-9./?=_%:-]+/, arr)
						 print arr[0]
					 }
				 }
			 }' | sort -u)
else
	echo "Warning: Unable to fetch content from AdGuard's DNS providers page. Proceeding with markdown data only."
fi

# Combine URLs from both sources and remove duplicates
FULL_URLS=$(echo -e "$FULL_URLS_FILE\n$FULL_URLS_ADGUARD" | sort -u)

# Check if any URLs were extracted
if [ -z "$FULL_URLS" ]; then
	echo "Error: No URLs could be extracted from either source. Exiting without creating lists."
	exit 1
fi

# Extract only domains from the URLs and remove duplicates
DOMAINS=$(echo "$FULL_URLS" | awk -F/ '{print $3}' | sort -u)

# Generate the doh-list.txt file with the header and full URLs
{
	echo "! Title: DoH DNS Block Filter With Full URLs"
	echo "! Description: Filter to block the publicly available DoH servers."
	echo "! Homepage: https://github.com/stonerl/doh-list"
	echo "! License: https://github.com/stonerl/doh-list/blob/master/LICENSE"
	echo "! Forked from: https://github.com/MohamedElashri/doh-list"
	echo "! Last modified: $CURRENT_DATE"
	echo "$FULL_URLS"
} >doh-list.txt

# Generate the doh-servers.list file with the header and only the domains
{
	echo "! Title: DoH DNS Block Filter With Domains"
	echo "! Description: Filter to block the publicly available DoH servers."
	echo "! Homepage: https://github.com/stonerl/doh-list"
	echo "! License: https://github.com/stonerl/doh-list/blob/master/LICENSE"
	echo "! Forked from: https://github.com/MohamedElashri/doh-list"
	echo "! Last modified: $CURRENT_DATE"
	echo "$DOMAINS"
} >doh-servers.list
