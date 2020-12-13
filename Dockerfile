FROM debian:buster-slim

LABEL maintainer="Tweakstreet Docker Maintainers <hi@tweakstreet.io>"

ENV TS_GID        101
ENV TS_UID        101
ENV TS_VERSION    1.13.0
ENV TS_HOME       /home/tweakstreet
ENV TS_LOCATION   /opt/tweakstreet
ENV TS_SHA256     dffb47a98adcb77fdf13d0401802b9d2c9ce66b49afc2efed8a623ef2024bf0c

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
