# gitea-backup-s3

[Gitea](https://gitea.io) git server provides a `dump` command which packages all your repositories, configuration and database in a single .zip file.

Through this image you can schedule periodic dumps and automate the transfer of the resulting files to an S3 bucket.

## Usage

`docker pull gtriggiano/gitea-backup-s3]`

### Volume

In order to ensure persistence of your data using the [Gitea docker image](https://hub.docker.com/r/gitea/gitea/), you are supposed to mount a host's folder or a data-volume on the `/data` directory inside the Gitea container.

To use this serivice just mount the same folder or data-volume into the `/data` directory of the backup serivice container.

### ENV vars
Those marked with `*` are mandatory.

`AWS_ACCESS_KEY_ID`*****

`AWS_SECRET_ACCESS_KEY`*****

`S3_BUCKET`*****

`S3_REGION`*****

`S3_ENDPOINT`: Use this if for Minio, etc..

`S3_S3V4`: Set to `yes` to use a v4 signature. **Note**: you _must_ use v4 to upload in some regions, like `eu-central-1`.

`S3_PREFIX`: Use this (without leading or trailing `/`) if you need to partition data in your bucket.

`S3_ENCRYPT`: Set to `yes` to use S3 server side AES-256 encryption.

`SCHEDULE`: backup schedule time (more info [here](https://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules)). If you don't set this the backup will fire immediately and then the container will exit.
