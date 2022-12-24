ARG DS_KTOOLS_VERSION="4.4.0"

FROM dstmodders/ktools:official-${DS_KTOOLS_VERSION}-debian

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /tmp/
RUN rm -Rf /data/ \
  && userdel -r ktools \
  && groupadd --gid 1000 klei-tools \
  && useradd \
    --uid 1000 \
    --gid klei-tools \
    --shell /bin/bash \
    --create-home \
    klei-tools \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates='20210119' \
    python2.7='2.7.18-8' \
    unzip='6.0-26+deb11u1' \
    wget='1.21-1+deb11u1' \
  # pip + packages \
  && wget -q https://bootstrap.pypa.io/pip/2.7/get-pip.py \
  && python2.7 ./get-pip.py \
  && pip install --no-cache-dir pillow=='6.2.2' \
  # clean
  && apt-get remove -y \
    ca-certificates \
    wget \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -Rf \
    /etc/ca-certificates.conf \
    /etc/ssl/ \
    /root/.cache/ \
    /root/.wget-hsts \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log

ARG DS_MOD_TOOLS_VERSION="3fe0cad89848c9d0fca8a4139a0491d188497636"

ENV DS="/opt/dont_starve"
ENV DST="${DS}"
ENV DS_MOD_TOOLS="/opt/klei-tools/mod_tools"
ENV DS_MOD_TOOLS_AUTOCOMPILER="${DS_MOD_TOOLS}/autocompiler"
ENV DS_MOD_TOOLS_PNG="${DS_MOD_TOOLS}/png"
ENV DS_MOD_TOOLS_SCML="${DS_MOD_TOOLS}/scml"
ENV DS_MOD_TOOLS_VERSION="${DS_MOD_TOOLS_VERSION}"
ENV PATH="${PATH}:/opt/klei-tools/mod_tools"

# hadolint ignore=DL3003
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential='12.9' \
    ca-certificates='20210119' \
    git='1:2.30.2-1' \
    premake4='4.3+repack1-2+b1' \
  # klei-tools \
  && git clone https://github.com/kleientertainment/ds_mod_tools.git \
  && cd ./ds_mod_tools/src/ \
  && git reset --hard "${DS_MOD_TOOLS_VERSION}" \
  && git log --no-decorate --oneline -n 10 \
  && ./premake.sh \
  && make -C ../build/proj/ config=release \
  && mv ../build/linux/mod_tools/mod_tools/* ../build/linux/mod_tools/ \
  && mv \
    ../build/linux/mod_tools/buildtools/linux/Python27/Python27/Lib/site-packages/klei/ \
    /usr/lib/python2.7/dist-packages/ \
  && rm -Rf \
    ../build/linux/mod_tools/buildtools/ \
    ../build/linux/mod_tools/dont_starve.sublime-project \
    ../build/linux/mod_tools/mod_tools/ \
  && mkdir -p \
    "${DS_MOD_TOOLS}" \
    /opt/temp/ \
  && mv ../build/linux/mod_tools/* "${DS_MOD_TOOLS}" \
  && mv ../build/dont_starve/ /opt/ \
  && cd "${DS_MOD_TOOLS}" \
  && chown -R klei-tools:klei-tools /opt/temp/ \
  && chmod +x \
    ./autocompiler \
    ./png \
    ./scml \
  # clean
  && apt-get remove -y \
    build-essential \
    ca-certificates \
    git \
    premake4 \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -Rf \
    "${DS:?}/"* \
    /etc/ca-certificates.conf \
    /etc/ssl/ \
    /opt/temp/* \
    /root/.wget-hsts \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log

WORKDIR ${DS_MOD_TOOLS}
CMD ["${DS_MOD_TOOLS}/autocompiler"]
