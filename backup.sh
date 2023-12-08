# Replace these placeholders with actual values
GITHUB_REPO="https://github.com/PurushotamSharma/Purushotam.github.io.git"
LOCAL_REPO="/home/purushotam/Enacton_Task/GitHub_Project_New"
BACKUP_FOLDER="/home/purushotam/Enacton_Task/Backup"
GOOGLE_DRIVE_REMOTE_NAME="gdrive"  # Replace with your actual rclone remote name
GOOGLE_DRIVE_FOLDER_ID="1KBgDX8c3Au9liEUDLbEsb9xbhgVpK_Z9"
ROTATIONAL_BACKUP_COUNT=7
# CURL_URL="http://your-curl-endpoint.com"

# Function to clone the GitHub repository
clone_github_repo() {
    git clone "${GITHUB_REPO}" "${LOCAL_REPO}"
}

# Function to create a backup
create_backup() {
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    BACKUP_NAME="backup_${TIMESTAMP}.zip"
    zip -r "${BACKUP_FOLDER}/${BACKUP_NAME}" "${LOCAL_REPO}"
}

# Function to push backup to Google Drive using rclone with retry
push_to_google_drive() {
    MAX_RETRIES=3
    RETRY_COUNT=0

    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        rclone -v  copy "${BACKUP_FOLDER}/${BACKUP_NAME}" "${GOOGLE_DRIVE_REMOTE_NAME}:${GOOGLE_DRIVE_FOLDER_ID}"

        # Check if the previous rclone command was successful
        if [ $? -eq 0 ]; then
            break  # Exit the loop if successful
        else
            RETRY_COUNT=$((RETRY_COUNT + 1))
            sleep 60  # Wait for 60 seconds before retrying
        fi
    done
}

# Function to perform rotational backup
rotational_backup() {
    find "${BACKUP_FOLDER}" -type f -name "backup_*.zip" | sort -r | tail -n +$ROTATIONAL_BACKUP_COUNT | xargs rm -f
}

# Function to send cURL request on successful backup
# send_curl_request() {
#     curl -X POST -d "Backup successful for project: $(basename ${LOCAL_REPO}), Date: $(date)" "${CURL_URL}"
# }

# Main script
echo "Starting backup process..."

# Step 1: Clone the GitHub repository
clone_github_repo

# Step 2: Create a backup
create_backup

# Step 3: Push backup to Google Drive using rclone
push_to_google_drive

# Step 4: Perform rotational backup
rotational_backup

# Step 5: Send cURL request on successful backup
# send_curl_request

echo "Backup process completed."

