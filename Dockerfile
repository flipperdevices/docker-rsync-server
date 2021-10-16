FROM alpine:3.14.1

RUN apk add --no-cache bash rssh rsync

RUN echo -e "muchtooeasytoguess\nmuchtooeasytoguess\n" | adduser -u 1000 -h /home/data -s /usr/bin/rssh data

RUN echo -e "PasswordAuthentication no\n" >>/etc/ssh/sshd_config

ENV AUTHORIZED_KEYS_FILE /authorized_keys

RUN echo -e "allowrsync\n" >> /etc/rssh.conf

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
EXPOSE 22
VOLUME /home/data