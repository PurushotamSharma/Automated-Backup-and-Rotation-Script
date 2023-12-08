# Replace these placeholders with actual values

GITHUB_REPO="https://github.com/PurushotamSharma/Purushotam.github.io.git"

LOCAL_REPO="/home/purushotam/Enacton_Task/GitHub_Project_New"

BACKUP_FOLDER="/home/purushotam/Enacton_Task/Backup"

GOOGLE_DRIVE_REMOTE_NAME="gdrive"  # Replace with your actual rclone remote name

GOOGLE_DRIVE_FOLDER_ID="Backup"

ROTATIONAL_BACKUP_COUNT=7

CURL_URL="https://webhook.site/895161ca-5e11-4458-8329-5dda9c2483a4"



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

        rclone -v copy "${BACKUP_FOLDER}/${BACKUP_NAME}" "${GOOGLE_DRIVE_REMOTE_NAME}:${GOOGLE_DRIVE_FOLDER_ID}/"



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

    # Find and delete backups older than 1 minute locally

    find "${BACKUP_FOLDER}" -type f -name "backup_*.zip" -mmin +1 -exec rm -f {} \;



    # Delete older backups from Google Drive using rclone

    rclone delete "${GOOGLE_DRIVE_REMOTE_NAME}:${GOOGLE_DRIVE_FOLDER_ID}" --min-age 1m --max-depth 1



    # Keep the last 'ROTATIONAL_BACKUP_COUNT' backups locally

    find "${BACKUP_FOLDER}" -type f -name "backup_*.zip" | sort -r | tail -n +$ROTATIONAL_BACKUP_COUNT | xargs rm -f

}



# Function to send cURL request on successful backup

send_curl_request() {

    curl -X POST -H "Content-Type: application/json" -d '{"project": "Automated Backup and Rotation Script", "date": "'"${TIMESTAMP}"'", "test": "BackupSuccessful"}' "${CURL_URL}"

}



# Function to log backup information

log_backup_info() {

    echo "Backup successful for project: $(basename ${LOCAL_REPO}), Date: $(date)" >> "${BACKUP_FOLDER}/backup_log.txt"

}





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

 send_curl_request



echo "Backup process completed."

