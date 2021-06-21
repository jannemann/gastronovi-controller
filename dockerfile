FROM adoptopenjdk:8-jre

ARG user=gastronovi
ARG group=gastronovi
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/bash --create-home ${user}

USER ${uid}:${gid}
COPY --chown=${user}:${group} entry.sh /home/${user}/.

WORKDIR /home/${user}
ENTRYPOINT ["./entry.sh"]