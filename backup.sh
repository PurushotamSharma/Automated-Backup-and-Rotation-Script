# Provide all the necessary paths



repo="https://github.com/PurushotamSharma/Shell-Script-Testing.git"



local_folder="/home/purushotam/Desktop/Enacton/Github"



backup="/home/purushotam/Desktop/Enacton/Backup"



backup_daily="$backup/daily"



backup_weekly="$backup/weekly"



backup_monthly="$backup/monthly"



rclone_server="Enacton"



gdrive_daily="Backup/daily"



gdrive_weekly="Backup/weekly"



gdrive_monthly="Backup/monthly"



log_file="$backup/log_file.txt"



curl_url="https://webhook.site/e9968d6e-3304-48e8-8687-c3f69f031bc5"



daily_rotation_count=7



weekly_rotation_count=4



monthly_rotation_count=3







enable_curl=true 







log_message() {



    local message="$1"



    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")



    echo "[${timestamp}] ${message}" >> "$log_file"



}











github_clone() {



    git clone "${repo}" "${local_folder}"



    log_message "GitHub repo cloned to ${local_folder}"



}







daily_backup() {



    TIMESTAMP=$(date +"%Y%m%d%H%M%S")



    backup_name="backup_${TIMESTAMP}.zip"



    zip -r "${backup_daily}/${backup_name}" "${local_folder}"



    log_message "Daily backup completed: ${backup_name}"



}











weekly_backup() {



    if [ "$(date +%u)" -eq 7 ]; then



        log_message "Today is Sunday. Performing weekly backup..."



        latest_file=$(find "${backup_daily}" -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d ' ' -f 2)



        if [ -n "${latest_file}" ]; then



            file_name=$(basename "${latest_file}")



            cp "${latest_file}" "${backup_weekly}/${file_name}"



            log_message "Latest file '${file_name}' copied from daily to weekly folder."



        else



            log_message "No files found in the daily folder."



        fi



        log_message "Weekly backup completed."



    else



        log_message "Today is not Sunday. No weekly backup needed."



    fi



}







monthly_backup() {



    current_day=$(date +"%d")



    last_day=$(date -d "$(date -d "$current_day/1 + 1 month" +"%Y-%m-01") - 1 day" +"%d")



    if [ "$current_day" -eq "$last_day" ]; then



        log_message "Today is the last day of the month. Starting monthly backup..."



        latest_file=$(ls -1t "${backup_daily}" | head -n 1)



        if [ -n "${latest_file}" ]; then



            log_message "Latest file in daily folder: ${latest_file}"



            cp "${backup_daily}/${latest_file}" "${backup_monthly}/"



            log_message "File copied to monthly folder."



        else



            log_message "No files found in the daily folder."



        fi



        log_message "Monthly backup completed."



    else



        log_message "Today is not the last day of the month. Skipping monthly backup."



    fi



}







push() {



   # local gdrive="$1"



    local frequency="$2"



    case "$frequency" in



        daily) rclone -v copy "${backup_daily}/${backup_name}" "${rclone_server}:${gdrive_daily}" ;;



        weekly) rclone -v copy "${backup_weekly}/${backup_name}" "${rclone_server}:${gdrive_weekly}" ;;



        monthly) rclone -v copy "${backup_monthly}/${backup_name}" "${rclone_server}:${gdrive_monthly}" ;;



        *) echo "Invalid frequency. Please use 'daily', 'weekly', or 'monthly'." ;;



    esac



}







daily_rotation() {

    # Delete local rotation files

    find "${backup_daily}" -type f -name "backup_*.zip" -exec ls -1t {} + | awk -v threshold="${daily_rotation_count}" 'NR>threshold' | xargs -I {} rm -f {}



    # Get the list of rotation files from the remote server

    rotation_files=$(rclone ls "${rclone_server}:${gdrive_daily}" --max-depth 1 --dry-run | sort -k 6,7 -r | awk -v threshold="${daily_rotation_count}" 'NR>threshold' | awk '{print $2}')



    echo "$rotation_files"



    if [ -n "$rotation_files" ]; then

        for file in $rotation_files; do

            # Attempt to delete the file

            rclone delete "${rclone_server}:${gdrive_daily}/${file}" >> "$log_file" 2>&1



            # Check the exit status of the last command

            if [ $? -ne 0 ]; then

                echo "Error deleting file: ${file}" >> "$log_file"

            fi

        done

    fi



    echo "Daily rotation completed."

}









weekly_rotation() {



    log_message "Starting weekly rotation..."







    # Local rotation



    find "${backup_weekly}" -type f -name "backup_*.zip" -exec ls -1t {} + | awk 'NR>4' | xargs -I {} rm -f {}



    log_message "Local rotation completed."







    # Remote rotation



rclone -v  ls "Enacton:Backup/weekly" --include "backup_*.zip"  | sort -k 6,7 -r | awk 'NR>4' | awk '{print $2}' | xargs -I {} rclone delete "Enacton:Backup/weekly"











    log_message "Remote rotation completed."







    log_message "Weekly rotation completed."



}







monthly_rotation(){







    # Keep the last backups locally



 find "${backup}" -type f -name "backup_*.zip" | sort -r | tail -n "${monthly_rotation_count}" | xargs rm -f



 



  files_to_delete=$(rclone ls "${rclone_server}:${gdrive_monthly}" --include "backup_*.zip" --max-depth 1 | sort -k 6,7 -r | awk -v threshold="${monthly_rotation_count}" 'NR>threshold' | awk '{print $2}')







    if [ -n "$files_to_delete" ]; then



        # Delete older files



        rclone delete "${rclone_server}:${files_to_delete}"



        log_message "Successfully performed monthly rotation on ${rclone_server}:${remote_folder}"



    else



        log_message "No backup files found on ${rclone_server}:${gdrive_monthly} for rotation."



    fi







    log_message "Monthly rotation completed."



}











curl_request() {



    if [ "${enable_curl}" = true ]; then



        curl -X POST -H "Content-Type: application/json" -d '{"project": "Automated Backup and Rotation Script", "date": "'"${timestamp}"'", "test": "Backup_Successful"}' "${curl_url}"



    else



        echo "Dry run: cURL request not sent."



    fi



}





# Main execution



log_message "Script started."



github_clone



daily_backup



weekly_backup



monthly_backup



push "${gdrive_daily}" "daily"



sleep 10s



push "${gdrive_weekly}" "weekly"



sleep 10s



#push "${gdrive_monthly}" "monthly"



daily_rotation



sleep 10s



weekly_rotation



sleep 10s



monthly_rotation



sleep 10s



curl_request
