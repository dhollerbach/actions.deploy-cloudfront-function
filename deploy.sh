#!/bin/sh

set -e  # Exit on error

FUNCTION_NAME=$1
COMMENT="$2"
SOURCE_FILE="$3"
RUNTIME="${4:-cloudfront-js-2.0}" # Default to 'cloudfront-js-2.0' if not provided
WAIT_FOR_PUBLISH="${5:-false}"    # Default to 'false' if not provided

# Fetch CloudFront Function ETag
fetch_etag() {
    echo "⏳ Fetching ETag for $FUNCTION_NAME..."
    CURRENT_ETAG=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --query 'ETag' --output text)
    echo "✅ Successfully fetched ETag: $CURRENT_ETAG"
}

# Update CloudFront Function
update_function() {
    echo "⏳ Updating $FUNCTION_NAME..."
    NEW_ETAG=$(aws cloudfront update-function \
      --name "$FUNCTION_NAME" \
      --function-config "{\"Comment\": \"$COMMENT\", \"Runtime\": \"$RUNTIME\"}" \
      --function-code fileb://"$SOURCE_FILE" \
      --if-match "$CURRENT_ETAG" \
      --query 'ETag' --output text)
    echo "✅ Successfully updated $FUNCTION_NAME. New ETag: $NEW_ETAG"
}

# Publish CloudFront Function
publish_function() {
    echo "⏳ Publishing $FUNCTION_NAME with ETag: $NEW_ETAG..."
    aws cloudfront publish-function --name "$FUNCTION_NAME" --if-match "$NEW_ETAG"
    echo "✅ Successfully published $FUNCTION_NAME"
}

# Wait for the function to be fully published
wait_for_publish() {
    echo "Waiting for $FUNCTION_NAME to be published..."
    while true; do
        status=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --query 'FunctionSummary.Status' --output text)
        echo "Current status: $status"

        if [ "$status" = "DEPLOYED" ]; then
            echo "✅ $FUNCTION_NAME is now published and deployed."
            break
        fi

        echo "⏳ Still deploying... Checking again in 5 seconds..."
        sleep 5
    done
}

# 1️⃣ Fetch the **current** ETag
fetch_etag

# 2️⃣ Update the function using the **current** ETag and get the **new** ETag from the updated function
update_function

# 3️⃣ Publish the updated function using the **new** ETag
publish_function

# 4️⃣ Wait for the published function to be fully deployed
if [ "$WAIT_FOR_PUBLISH" = "true" ]; then
    wait_for_publish
fi
