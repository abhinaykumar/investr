#!/bin/bash -e

echo `scp ubuntu@40.65.110.22:"/home/ubuntu/videoken/shared/config/database.yml /home/ubuntu/videoken/shared/config/application.yml" ./`

if [ $? -eq 0 ];
then
    echo "===> database and application config files have been copied successfully <==="
else
  echo `scp ubuntu@52.191.161.90:"/home/ubuntu/videoken/shared/config/database.yml /home/ubuntu/videoken/shared/config/application.yml" ./`
fi

if [ $? -ne 0 ];
then
  echo "===> could not download database and application files!!! <==="
fi
