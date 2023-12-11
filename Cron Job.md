# Cron Jobs

# Understanding Cron Jobs and How to Create/Execute Them

## What is a Cron Job?

A **Cron Job** is a scheduled task or job on Unix-like operating systems. It allows users to automate repetitive tasks by scheduling them to run periodically at specified intervals. These tasks can range from simple commands to complex scripts and can be scheduled to run every minute, hour, day, week, or month.

## Creating and Executing a Cron Job

### 1. **Understanding the Cron Syntax**

The cron syntax consists of five fields that determine the schedule of the job:

# Cron Syntax

The cron syntax consists of five fields that determine the schedule of the job:

- `* * * * *`
  - `*`: Minute (0 - 59)
  - `*`: Hour (0 - 23)
  - `*`: Day of the month (1 - 31)
  - `*`: Month (1 - 12)
  - `*`: Day of the week (0 - 6) (Sunday is 0, Monday is 1, and so on)



### 2. **Accessing the Crontab Configuration**

To create and edit cron jobs, you can use the crontab command. Open the crontab configuration for editing:

```bash
crontab -e
```

##Adding a Cron Job for a Specific Function


## Daily Backup

Schedule the `daily_backup` function every day at 7 PM:

```bash
0 19 * * * /home/purushotam/Enacton_Task/Shell_Script/enacton.sh daily_backup
```


## Weekly Backup

Schedule the weekly_backup function every Sunday at 8 PM:

```bash
0 20 * * 0 /home/purushotam/Enacton_Task/Shell_Script/enacton.sh weekly_backup
```


## Monthly Backup

Schedule the monthly_backup function on the last day of the month:

```bash
0 0 28-31 * * [ "$(date +\%d -d tomorrow)" == "01" ] && /home/purushotam/Enacton_Task/Shell_Script/enacton.sh monthly_backup
```

## Daily Execution

Execute the script every day at 7 PM:

```bash
0 19 * * * /home/purushotam/Enacton_Task/Shell_Script/enacton.sh
```






