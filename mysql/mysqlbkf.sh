#!/bin/bash
#steps to configure mysql backup
#1-create output directory
#2-save script to sever
#3-chmod 755 scriptfile
#4-add script to crontab
#crontab -e
#00 20 * * * /path/to/backup.sh   to run the backup job at 8 pm everyday


USER="db username"
PASSWORD="db password"
OUTPUT="/opt/mysqlbkf"
 
rm "$OUTPUTDIR/*gz" > /dev/null 2>&1
 
databases=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
 
for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump --force --opt --user=$USER --password=$PASSWORD --databases $db > $OUTPUT/`date +%Y%m%d`.$db.sql
        gzip $OUTPUT/`date +%Y%m%d`.$db.sql
    fi
done