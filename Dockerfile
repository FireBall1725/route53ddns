FROM alpine:3.7
MAINTAINER  FireBall1725 <fireball@fireball1725.ca>

RUN apk add --no-cache bash python3 curl bind-tools

RUN pip3 install --upgrade pip && \
    pip3 install awscli --upgrade --user

ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /root

COPY scripts/* /root

RUN ["chmod", "+x", "/root/entrypoint.sh"]

ENTRYPOINT [ "/root/entrypoint.sh" ]