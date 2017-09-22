#! /bin/sh

set -e

if [ "${AWS_ACCESS_KEY_ID}" == "**None**" ]; then
  echo "Warning: You did not set the AWS_ACCESS_KEY_ID environment variable."
fi

if [ "${AWS_SECRET_ACCESS_KEY}" == "**None**" ]; then
  echo "Warning: You did not set the AWS_SECRET_ACCESS_KEY environment variable."
fi

if [ "${S3_BUCKET}" == "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${S3_REGION}" == "**None**" ]; then
  echo "You need to set the S3_REGION environment variable."
  exit 1
fi

move_to_s3 () {
  SRC_FILE=$1
  DEST_FILE=$2

  if [ "${S3_ENDPOINT}" == "**None**" ]; then
    AWS_ARGS=""
  else
    AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
  fi

  if [ "${S3_ENDPOINT}" == "**None**" ]; then
    AWS_ARGS=""
  else
    AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
  fi

  if [ "${S3_ENCRYPT}" == "yes" ]; then
    AWS_ARGS="${AWS_ARGS}"
  else
    AWS_ARGS="${AWS_ARGS}"
  fi

  echo "Uploading ${DEST_FILE} on S3..."

  cat $SRC_FILE | aws $AWS_ARGS s3 cp - $S3_URI

  if [ $? != 0 ]; then
    >&2 echo "Error uploading ${DEST_FILE} on S3"
  fi

  rm $SRC_FILE
}

export AWS_DEFAULT_REGION=$S3_REGION

BACKUP_START_TIME=$(date +"%Y-%m-%dT%H%M%SZ")
S3_FILE="${BACKUP_START_TIME}.gitea-dump.zip"

cd /backup
echo "Dumping Gitea..."
/app/gitea/gitea dump > /dev/null
echo "Done"

unset -v DUMP_FILE
for FILE in /backup/*; do
  [[ $FILE -nt $DUMP_FILE ]] && DUMP_FILE=$FILE
done

move_to_s3 $DUMP_FILE $S3_FILE

echo "Gitea backup finished"
