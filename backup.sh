# Firstly we will provide all the path of local as well as remote

# We have to create a script for a project  that is  hosted on the Github , so we need the github repo link for that we create one variable that store the github repo link

repo="https://github.com/PurushotamSharma/Purushotam.github.io.git"

# Now we have to create one folder that store the github code for the backup

local_folder="/home/purushotam/DevOps/Task/Github_Project"

# for storing the Backup zip file we have to create one backup folder 

backup="/home/purushotam/DevOps/Task/Backup"

# for push the code to gdrive we will be using the rclone server

rclone_server="gdrive"

# give the name to gdrive folder that store your all backup files

gdrive_folder="Backup"

# for the rotational backup we have to give the argument as a variable , for this script i will be giving as 7

rotational_count=7

# for output and notification we will be using the curl url from webhook site

curl_url="https://webhook.site/895161ca-5e11-4458-8329-5dda9c2483a4"

enable_curl=true  # Set to false to disable cURL request for testing

# For clonning the github repo we have to create onne function

github_clone(){
    # after git clone command we give the source and after that we will have the destination
    git clone "${repo}" "${local_folder}"

}

# now we declare the backup function

backup() {
    # for the backup folder name we will use timestamp 
    timestamp=$(date +"%Y%m%d-%H%M%S")

    backup_name="backup(date +"%Y%m%d-%H%M%S").zip"

    # here we create the zip archive
    zip -r "${backup}/${backup_name}"  "${local_folder}"
}
  
  # we also have create function  to push the backup to the gdrive for that we will be using the rclone server

push(){

    rclone -v copy "${backup}/${backup_name}" "${rclone_server}:${gdrive_folder}"
}
  # for rotational backup we have to create one function
   
   rotational_backup() {
     # Keep the last 7 daily backups locally
    find "${backup}" -type f -name "backup_*.zip" -mtime -7 | xargs -I {} mv {} "${backup}"

    # Keep the last 4 backups of Sundays (weekly)
    find "${backup}" -type f -name "backup_*.zip" -mtime -28 -exec date -d {} '+%u' \; | grep '^7' | xargs -I {} mv "${backup}/backup_{}.zip" "${backup}"

    # Keep the last 3 monthly backups
    find "${backup}" -type f -name "backup_*.zip" -mtime -91 | xargs -I {} mv {} "${backup}"

    # Delete older backups beyond the specified retention periods locally (with --dry-run for testing)
    if [ "${enable_curl}" = true ]; then
        find "${backup}" -type f -name "backup_*.zip" ! -mtime -91 -exec rm -f {} \;
        # Delete older backups beyond the specified retention periods on Google Drive (with --dry-run for testing)
        rclone delete "${rclone_server}:${gdrive_folder}" --min-age 91 --max-depth 1
    else
        echo "Dry run: Older backups not deleted locally and on Google Drive."
    fi
   }

   # Function to send cURL request on successful backup
curl_request() {
    if [ "${enable_curl}" = true ]; then
        curl -X POST -H "Content-Type: application/json" -d '{"project": "Automated Backup and Rotation Script", "date": "'"${timestamp}"'", "test": "Backup_Successful"}' "${curl_url}"
    else
        echo "Dry run: cURL request not sent."
    fi
}

# Function to log backup 

log_backup() {

    echo "Backup successful for project: $(basename ${local_folder}), Date: $(date)" >> "${backup}/backup_log.txt"

}

# Main script
echo "Starting backup process..."

# Step 1: Clone the GitHub repository

github_clone

# Step 2: Create a backup

backup

# Step 3: Push backup to Google Drive using rclone

push

# Step 4: Perform rotational backup

rotational_backup

# Step 5: Send cURL request on successful backup

curl_request

echo "Backup process completed."
