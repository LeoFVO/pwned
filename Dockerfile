FROM quickwit/quickwit:latest

COPY ./config /quickwit/config
EXPOSE 7280
ENV QW_S3_ENDPOINT=http://127.0.0.1:9000
ENV AWS_ACCESS_KEY_ID=minio
ENV AWS_SECRET_ACCESS_KEY=minio123
ENV QW_S3_FORCE_PATH_STYLE_ACCESS=true
ENV AWS_REGION=us-east-1

CMD [ "run" ]