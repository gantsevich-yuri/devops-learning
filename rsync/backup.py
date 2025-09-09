#!/usr/bin/python3
import os
import subprocess

base_dir = "/home/yuri/task2/"
base_bkp_dir = "/tmp/backup/"
bkp_logfile = "/var/log/backup.log"

result = subprocess.run(["date", "+'%Y-%m-%d-%H-%M'"], capture_output=True, text=True, check=True)
date = result.stdout.strip()

cur_bkp_dir = base_bkp_dir + date
backup_cmd = f"rsync -a --delete {base_dir} {cur_bkp_dir}"

os.system(f"mkdir -p {base_bkp_dir}")
check = os.system(f"{backup_cmd}")
if check == 0:
    os.system(f"echo '{date} Succesful backup' >> {bkp_logfile}")
else:
    os.system(f"echo '{date} Error backup' >> {bkp_logfile}")