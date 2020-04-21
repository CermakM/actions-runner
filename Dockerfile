FROM registry.access.redhat.com/ubi8/ubi:latest

ARG RUNNER_VERSION=2.169.0
ENV APP_ROOT=/opt/app-root

WORKDIR ${APP_ROOT}/src

USER 0

RUN yum install -y libicu && \
    curl -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz | tar xzf - && \
	curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq && \
	chmod +x /usr/local/bin/jq

RUN chown -R 1001:0 ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT}      && \
    chmod -R g+rw ${APP_ROOT}   && \
	find ${APP_ROOT}/src -type f -name '*.so' -exec chmod +x {} +

USER 1001

COPY entrypoint /opt/app-root/src/entrypoint

ENTRYPOINT [ "/opt/app-root/src/entrypoint" ]
