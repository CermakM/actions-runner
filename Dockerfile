FROM registry.access.redhat.com/ubi8/ubi:latest

ENV APP_ROOT /opt/app-root

WORKDIR ${APP_ROOT}/src

COPY entrypoint /opt/app-root/src/entrypoint

USER 0

RUN yum install -y libicu

RUN curl -O -L https://github.com/actions/runner/releases/download/v2.165.2/actions-runner-linux-x64-2.165.2.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.165.2.tar.gz && rm -rf ./actions-runner-linux-x64-2.165.2.tar.gz && \
    chown -R 1001:0 ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT}      && \
    chmod -R g+rw ${APP_ROOT}   && \
    find ${APP_ROOT} -type d -exec chmod g+x {} +

USER 1001

ENTRYPOINT [ "/opt/app-root/src/entrypoint" ]