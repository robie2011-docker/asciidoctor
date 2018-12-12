# debian 8.1 codename: jessie
FROM debian:8.1

ENV NODE_VERSION 8.12.*

# https://www.npmjs.com/package/mermaid.cli
ENV MERMAIDCLI_VERSION 0.5.1

# https://packages.debian.org/jessie/asciidoctor
ENV ASCIIDOCTOR_VERSION 0.1.4-3

# https://rubygems.org/gems/asciidoctor-diagram/versions/1.2.1
ENV ASCIIDOCTOR_DIAGRAM_VERSION 1.5.10

# https://rubygems.org/gems/asciidoctor-pdf
ENV ASCIIDOCTOR_PDF_VERSION 1.5.0.alpha.16

# https://rubygems.org/gems/pygments.rb
ENV PYGMENTS_VERSION 1.2.1

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
    apt-get -qq install asciidoctor=$ASCIIDOCTOR_VERSION && \
    gem install asciidoctor-diagram:$ASCIIDOCTOR_DIAGRAM_VERSION && \
    gem install asciidoctor-pdf:$ASCIIDOCTOR_PDF_VERSION && \
    gem install pygments.rb:$PYGMENTS_VERSION && \
    useradd debian -m

USER debian

# no-sandbox: https://github.com/mermaidjs/mermaid.cli/pull/32
RUN cd ~/ && \
    yarn add mermaid.cli@$MERMAIDCLI_VERSION &&\
     sed -i "62i puppeteerConfig.args = ['--no-sandbox'];\r\n" ~/node_modules/mermaid.cli/index.bundle.js &&\
     export PATH=$PATH:~/node_modules/.bin

