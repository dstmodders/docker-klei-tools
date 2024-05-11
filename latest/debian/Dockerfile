ARG KTOOLS_VERSION="4.5.1"

FROM dstmodders/ktools:${KTOOLS_VERSION}-debian

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG OPENSSL_VERSION="1.1.1w"
ARG PYTHON_VERSION="2.7.18"
ARG TARGETPLATFORM

USER root
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN rm -rf /data/ \
  && sed -i 's/ktools/klei-tools/g' /etc/passwd /etc/group \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential='12.9' \
    ca-certificates='20230311' \
    unzip='6.0-28' \
    wget="$(if [[ "${TARGETPLATFORM}" == 'linux/386' ]]; then echo '1.21.3-1+b1'; else echo '1.21.3-1+b2'; fi)" \
  && if [[ "${TARGETPLATFORM}" == 'linux/386' ]]; then \
    apt-get install -y --no-install-recommends gcc-multilib='4:12.2.0-3'; \
  fi \
  # openssl
  && wget -q "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" \
  && tar xzf "openssl-${OPENSSL_VERSION}.tar.gz" \
  && cd "openssl-${OPENSSL_VERSION}" \
  && if [[ "${TARGETPLATFORM}" == 'linux/386' ]]; then \
    setarch i386 ./config; \
  else \
    ./config; \
  fi \
  && make -j "$(nproc)" \
  && make install \
  && cd .. \
  && rm -rf "openssl-${OPENSSL_VERSION}.tar.gz" "openssl-${OPENSSL_VERSION}" \
  && ldconfig \
  # python
  && wget -q "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz" \
  && tar xzf "Python-${PYTHON_VERSION}.tgz" \
  && cd "Python-${PYTHON_VERSION}" \
  && ./configure --enable-shared --prefix=/usr \
  && make -j "$(nproc)" \
  && make install \
  && cd .. \
  && rm -rf "Python-${PYTHON_VERSION}.tgz" "Python-${PYTHON_VERSION}" \
  # pip + packages
  && wget -q "https://bootstrap.pypa.io/pip/$(echo "${PYTHON_VERSION}" | cut -d. -f1,2)/get-pip.py" \
  && python2.7 ./get-pip.py \
  && pip install --no-cache-dir pillow=='6.2.2' \
  && rm ./get-pip.py \
  # clean
  && apt-get remove -y \
    build-essential \
    ca-certificates \
    wget \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf \
    /etc/ca-certificates.conf \
    /etc/ssl/ \
    /root/.cache/ \
    /root/.wget-hsts \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log \
  # smoke tests
  && python2.7 --version \
  && python2.7 -c 'import ssl; print(ssl.OPENSSL_VERSION)' \
  && pip --version \
  && pip list

ARG KLEI_TOOLS_VERSION="1.0.0"
ENV KLEI_TOOLS_VERSION="${KLEI_TOOLS_VERSION}"

ENV DS="/opt/dont_starve"
ENV DST="${DS}"
ENV KLEI_TOOLS_AUTOCOMPILER="/opt/klei-tools/mod_tools/autocompiler"
ENV KLEI_TOOLS_PNG="/opt/klei-tools/mod_tools/png"
ENV KLEI_TOOLS_SCML="/opt/klei-tools/mod_tools/scml"
ENV PATH="${PATH}:/opt/klei-tools/mod_tools"

# hadolint ignore=DL3003
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential='12.9' \
    ca-certificates='20230311' \
    premake4='4.3+repack1-2+b1' \
    wget="$(if [[ "${TARGETPLATFORM}" == 'linux/386' ]]; then echo '1.21.3-1+b1'; else echo '1.21.3-1+b2'; fi)" \
  # klei-tools \
  && wget -q "https://github.com/dstmodders/klei-tools/archive/refs/tags/v${KLEI_TOOLS_VERSION}.tar.gz" \
  && tar xzf "v${KLEI_TOOLS_VERSION}.tar.gz" \
  && cd "klei-tools-${KLEI_TOOLS_VERSION}/src/" \
  && ./premake.sh \
  && make -C ../build/proj/ config=release \
  && mv ../build/linux/mod_tools/mod_tools/* ../build/linux/mod_tools/ \
  && mv \
    ../build/linux/mod_tools/buildtools/linux/Python27/Python27/Lib/site-packages/klei/ \
    /usr/lib/python2.7/site-packages/ \
  && rm -rf \
    ../build/linux/mod_tools/buildtools/ \
    ../build/linux/mod_tools/dont_starve.sublime-project \
    ../build/linux/mod_tools/mod_tools/ \
  && mkdir -p \
    /opt/klei-tools/mod_tools/ \
    /opt/temp/ \
  && mv ../build/linux/mod_tools/* /opt/klei-tools/mod_tools/ \
  && mv ../build/dont_starve/ /opt/ \
  && cd /opt/klei-tools/mod_tools/ \
  && chown -R klei-tools:klei-tools /opt/temp/ \
  && chmod +x \
    ./autocompiler \
    ./png \
    ./scml \
  # clean
  && apt-get remove -y \
    build-essential \
    ca-certificates \
    premake4 \
    wget \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf \
    "${DS:?}/"* \
    /etc/ca-certificates.conf \
    /etc/ssl/ \
    /opt/temp/* \
    /root/.cache/ \
    /root/.wget-hsts \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log

USER klei-tools
WORKDIR /opt/klei-tools/mod_tools/
CMD ["/opt/klei-tools/mod_tools/autocompiler"]
