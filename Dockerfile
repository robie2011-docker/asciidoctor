FROM debian:8.1
ENV NODE_VERSION 8.11.1-1nodesource1
ENV MERMAIDCLI_VERSION 0.4.6

#WARNING: The following packages cannot be authenticated!
#  libcurl3-gnutls
RUN apt-get -qq update && apt-get -qq install curl apt-transport-https --force-yes

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update && \
    apt-get -qq install openssh-client && \
    apt-get -qq install yarn && \
    apt-get -qq install nodejs=$NODE_VERSION && \
    apt-get -qq install gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget &&\
    apt-get -qq install asciidoctor && \
    gem install asciidoctor-diagram && gem install asciidoctor-pdf --pre &&\
    useradd debian -m

USER debian

# no-sandbox: https://github.com/mermaidjs/mermaid.cli/pull/32
RUN cd ~/ && \
    yarn add mermaid.cli@$MERMAIDCLI_VERSION &&\
    sed -i "62i puppeteerConfig.args = ['--no-sandbox'];\r\n" node_modules/mermaid.cli/index.bundle.js &&\
    export PATH=$PATH:~/node_modules/.bin

#docker exec -it -u debian cc98d34f0835 bash
# node_modules/.bin/mmdc -i flowchart.mmd
