FROM registry.access.redhat.com/ubi8/ubi:latest

ENV APP_ROOT=/opt/app-root
ENV PATH="${APP_ROOT}/bin:${PATH}"

WORKDIR ${APP_ROOT}/src

COPY entrypoint /opt/app-root/src/entrypoint

USER 0

RUN yum install -y libicu

RUN curl -O -L https://github.com/actions/runner/releases/download/v2.165.2/actions-runner-linux-x64-2.165.2.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.165.2.tar.gz && rm -rf ./actions-runner-linux-x64-2.165.2.tar.gz && \
	mkdir -p ${APP_ROOT}/bin    && \
    chown -R 1001:0 ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT}      && \
    chmod -R g+rw ${APP_ROOT}   && \
    find ${APP_ROOT} -type d -exec chmod g+x {} +

USER 1001

RUN curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o ${APP_ROOT}/bin/jq && \
	chmod +x ${APP_ROOT}/bin/jq

ENTRYPOINT [ "/opt/app-root/src/entrypoint" ]
