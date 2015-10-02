#!/bin/bash
BACKUP_PATH="/root/Dropbox/db_backups/"
DBPASS="Database Password Here"
DBUSER="Database Username Here"

SITES=`ls -l /var/www/ --time-style="long-iso" $MYDIR | egrep '^d' | awk '{print $8}'`
WEBDIR="/var/www"
for SITE in $SITES
 do
  FOLDER_DATE=$(date +"%Y-%m-%d_%H:%M:%S")

  # Obtain the web's root folder
  if [ -d "${WEBDIR}/${SITE}/public_html" ] && [ ! -f "${WEBDIR}/${SITE}/scripts/.dont-backup" ]; then
     # Check if site folder exists in the backup folder
     if [ ! -d "${BACKUP_PATH}${SITE}" ]; then
      mkdir -p ${BACKUP_PATH}${SITE}
     fi
     # Make directory for NOW (time)
     mkdir -p ${BACKUP_PATH}${SITE}/${FOLDER_DATE}
     # Backup site database
     source ${WEBDIR}/${SITE}/scripts/.information
     mysqldump -u ${DBUSER} --pass=${DBPASS} ${DBNAME} > ${BACKUP_PATH}${SITE}/${FOLDER_DATE}/database.sql
     # Compress website public_html
     tar -zcvpf ${BACKUP_PATH}${SITE}/${FOLDER_DATE}/backup.tar.gz ${WEBDIR}/${SITE}/public_html
  fi
done