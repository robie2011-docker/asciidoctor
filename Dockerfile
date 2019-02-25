# debian 8.1 codename: jessie
FROM debian:8.1

ENV NODE_VERSION v10.14.2

# https://www.npmjs.com/package/mermaid.cli
ENV MERMAIDCLI_VERSION 0.5.1

# https://packages.debian.org/jessie/asciidoctor
ENV ASCIIDOCTOR_VERSION 0.1.4-3

# https://rubygems.org/gems/asciidoctor-diagram/versions/1.2.1
ENV ASCIIDOCTOR_DIAGRAM_VERSION 1.5.13

# https://rubygems.org/gems/asciidoctor-pdf
ENV ASCIIDOCTOR_PDF_VERSION 1.5.0.alpha.16

# https://rubygems.org/gems/pygments.rb
ENV PYGMENTS_VERSION 1.2.1

ENV CONCURRENT_RUBY 1.1.4

#WARNING: The following packages cannot be authenticated!
#  libcurl3-gnutls
RUN apt-get -qq update && apt-get -qq install curl apt-transport-https --force-yes && \
    apt-get -qq install openssh-client && \
    apt-get -qq install gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget

RUN apt-get -qq update && apt-get -qq install asciidoctor=$ASCIIDOCTOR_VERSION && \
    gem install asciidoctor-diagram:$ASCIIDOCTOR_DIAGRAM_VERSION && \
    gem install asciidoctor-pdf:$ASCIIDOCTOR_PDF_VERSION && \
    gem install pygments.rb:$PYGMENTS_VERSION && \
    gem install concurrent-ruby:$CONCURRENT_RUBY && \
    useradd debian -m
    
RUN apt-get -qq update && \     
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn vim

USER debian

RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && . /home/debian/.bashrc  && \ 
    export NVM_DIR="$HOME/.nvm" &&  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION

# no-sandbox: https://github.com/mermaidjs/mermaid.cli/pull/32
RUN  cd ~/ && export NVM_DIR="$HOME/.nvm" &&  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    yarn add mermaid.cli@$MERMAIDCLI_VERSION &&\
     sed -i "62i puppeteerConfig.args = ['--no-sandbox'];\r\n" ~/node_modules/mermaid.cli/index.bundle.js &&\
     echo export PATH=$PATH:/home/debian/node_modules/.bin >>/home/debian/.bashrc

ENV PATH="/home/debian/.nvm/versions/node/v10.14.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/debian/node_modules/.bin:${PATH}"

# dev testing example:
# docker build . -t tmp
# docker run --rm -it -v/Users/robert.rajakone/repos/2017_paasos/project-doc:/data -w/data/paasos-symmetricds tmp
# asciidoctor -v -r asciidoctor-diagram -a data-uri -b xhtml5 index.adoc
# mermaid command: mmdc 
