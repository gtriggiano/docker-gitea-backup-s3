#! /bin/sh

set -e

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

if [ "${SCHEDULE}" = "**None**" ]; then
  bash /backup.sh
else
  exec go-cron -s "$SCHEDULE" -p 8080 -- /bin/bash /backup.sh
fi
