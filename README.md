# Automated Backup and Rotation Script

## Overview

This script automates the backup process for a GitHub project, implementing a rotational backup strategy, and integrates with Google Drive to push backups. Additionally, it provides options for deletion of older backups and sends a cURL request on successful backup.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Rotational Backup Strategy](#rotational-backup-strategy)
- [Output and Notification](#output-and-notification)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- Git
- Google Drive CLI tool (e.g., `rclone`)
- cURL (Webhook.sit)

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/PurushotamSharma/Automated-Backup-Script.git
    cd Automated-Backup-Script
    ```

2. Install the required tools (`rclone`, `curl`).

    ```bash
    # Install rclone: https://rclone.org/install/
    # Install curl: https://curl.se/download.html
    ```

## Configuration

Edit the script (`backup_script.sh`) and set the following variables:

- `GITHUB_REPO`: URL of the GitHub repository.
- `LOCAL_REPO`: Local path to clone the GitHub repository.
- `BACKUP_FOLDER`: Local path to store backups.
- `GOOGLE_DRIVE_REMOTE_NAME`: Name of the rclone remote for Google Drive.
- `GOOGLE_DRIVE_FOLDER_ID`: Google Drive folder ID to store backups.
- `ROTATIONAL_BACKUP_COUNT`: Number of backups to retain in each category.
- `CURL_URL`: cURL endpoint for successful backup notifications(Webhook).

## Usage

Run the script:

```bash
./backup_script.sh
