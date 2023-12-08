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
- Basic Understanding of Linux

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/PurushotamSharma/Automated-Backup-Script.git
    cd Automated-Backup-Script
    ```

2. Install the required tools (`rclone`).

    ```bash
     sudo apt-get install rclone
    ```

## Configuration

Edit the script (`backup_script.sh`) and set the following variables:

- `repo`: URL of the GitHub repository.
- `local_folder`: Local path to clone the GitHub repository.
- `backup`: Local path to store backups.
- `rclone_server`: Name of the rclone remote for Google Drive.
- `gdrive_folder`: Google Drive folder ID or name to store backups.
- `rotational_count`: Number of backups to retain in each category.
- `curl_url`: cURL endpoint for successful backup notifications(Webhook).

## What is rclone?
Rclone is a command-line program that provides a convenient way to manage files and data on cloud storage services. It allows users to perform various operations, such as copying, syncing, and transferring files between different storage providers. Rclone supports a wide range of cloud storage systems, including Google Drive, Dropbox, Amazon S3, Microsoft OneDrive, and many others.

## How to configure rclone server in linux :

Here are step by step guide:
1. Install the rclone by using command
   
     ```bash
     sudo apt-get install rclone
    ```
2. Now we have to configure the rclone server

   ```bash
     rclone config
    ```
   ![WhatsApp Image 2023-12-08 at 23 50 10_1441a0d7](https://github.com/PurushotamSharma/Automated-Backup-and-Rotation-Script/assets/107574991/0c521b94-3bff-43c2-   a4f7-0c34194b77dd)

   Currently I have a one remote server because I recentaly use for this project you have to create new one by providing command n as a new server
   
    ![WhatsApp Image 2023-12-08 at 23 55 41_0b85d98e](https://github.com/PurushotamSharma/Automated-Backup-and-Rotation-Script/assets/107574991/ee54024b-542f-408f-a597-4215804babff)



  



## Usage

Give the permission to your backup.sh

```bash
chmod +x backup.sh
```

Run the script:

```bash
./backup_script.sh
```

