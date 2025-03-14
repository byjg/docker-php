#!/bin/bash

REPO="byjg/php"
PAGE_SIZE=100
URL="https://hub.docker.com/v2/repositories/$REPO/tags/?page_size=$PAGE_SIZE"
TAGS=()

# Function to fetch and process tags
fetch_tags() {
    local next_url="$URL"

    while [[ -n "$next_url" ]]; do
        echo "Fetching: $next_url"

        # Fetch the data
        RESPONSE=$(curl -s "$next_url")

        # Extract tag names and append to array
        TAGS+=($(echo "$RESPONSE" | jq -r '.results[].name'))

        # Get next page URL (if available)
        next_url=$(echo "$RESPONSE" | jq -r '.next')

        # If next_url is "null", break the loop
        if [[ "$next_url" == "null" ]]; then
            break
        fi
    done
}

# Fetch all tags
fetch_tags

# Sort and print the tags
echo "Sorted Tags:"
printf "%s\n" "${TAGS[@]}" | sort -V
