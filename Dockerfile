FROM gitea/gitea:latest AS source-image

FROM scratch
MAINTAINER Giacomo Triggiano "giacomotriggiano@gmail.com"

ENV AWS_ACCESS_KEY_ID **None**
ENV AWS_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION **None**
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV S3_PREFIX **None**
ENV S3_ENCRYPT no
ENV SCHEDULE **None**

ENV GITEA_USER git
ENV GITEA_CUSTOM /data/gitea

COPY --from=source-image / /
ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ADD run.sh run.sh
ADD backup.sh backup.sh

VOLUME ["/data"]
EXPOSE 8080
CMD ["sh", "run.sh"]
