#!/bin/bash

# Function to display an error message and exit the script
display_error() {
    echo "Error: $1"
    exit 1
}

# Function to display a success message
display_success() {
    echo "File upload completed successfully."
}

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    display_error "Usage: $0 <bucket_name> <file1> [file2 ... fileN] [target_directory]"
fi

# Parse command-line arguments
BUCKET_NAME=$1
shift
FILES=("$@")

# Ensure at least one file is provided
if [ ${#FILES[@]} -eq 0 ]; then
    display_error "No files provided for upload."
fi

# Use the last argument as the target directory (if provided)
TARGET_DIR=""
if [ ${#FILES[@]} -gt 1 ]; then
    TARGET_DIR=${FILES[-1]}
    unset 'FILES[${#FILES[@]}-1]'
fi

# Loop through files and upload them to S3
for FILENAME in "${FILES[@]}"; do
    # Check if the specified file exists
    if [ ! -f "$FILENAME" ]; then
        display_error "File not found: $FILENAME"
    fi

    # Display a message indicating that the script is processing
    echo "Uploading file: $FILENAME to bucket: $BUCKET_NAME, target directory: $TARGET_DIR"

    # Use the AWS CLI to upload the file
    aws s3 --profile antznette cp "$FILENAME" "s3://$BUCKET_NAME/$TARGET_DIR/$(basename "$FILENAME")"

    # Check the exit status of the last command
    if [ $? -ne 0 ]; then
        display_error "Upload failed for $FILENAME. Please check the error message above."
    fi
done

# Display success message
display_success
