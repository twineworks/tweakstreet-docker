FROM debian:buster-slim

LABEL maintainer="Tweakstreet Docker Maintainers <hi@tweakstreet.io>"

ENV TS_GID        101
ENV TS_UID        101
ENV TS_VERSION    1.10.1
ENV TS_HOME       /home/tweakstreet
ENV TS_LOCATION   /opt/tweakstreet
ENV TS_SHA256     d854b0720a05b075e424423789a4d0dc42c552de208c8274b6721e8bb3e0374b

ENV TERM          xterm-256color

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y bash ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && addgroup --gid "${TS_GID}" tweakstreet \
    && adduser --system --home /home/tweakstreet --ingroup tweakstreet --gecos "tweakstreet user" --shell /bin/bash --uid "${TS_UID}" tweakstreet \
    && mkdir -p "${TS_HOME}/.tweakstreet/drivers" \
    && mkdir -p "${TS_LOCATION}" \
    && chown -R tweakstreet:tweakstreet "${TS_LOCATION}" \
    && mkdir -p "/app" \
    && chown tweakstreet:tweakstreet /app

USER tweakstreet

SHELL ["/bin/bash", "-c"]

RUN curl "https://tweakstreet.io/updates/Tweakstreet-${TS_VERSION}-portable.tar.gz" --output "${TS_LOCATION}/portable.tar.gz" \
    && echo "${TS_SHA256} *portable.tar.gz" > "${TS_LOCATION}/SHA256SUMS" \
    && cd "${TS_LOCATION}" && sha256sum -c SHA256SUMS 2>&1 | grep OK \
    && tar --strip-components=1 -xzf portable.tar.gz Tweakstreet-${TS_VERSION}-portable/bin \
    && rm portable.tar.gz

ENV PATH "${TS_LOCATION}/bin:$PATH"

COPY docker-entrypoint.sh "${TS_LOCATION}/"
ENTRYPOINT ["/opt/tweakstreet/docker-entrypoint.sh"]

CMD ["engine.sh", "--help"]
