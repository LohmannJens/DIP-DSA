FROM rocker/shiny:latest

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get purge -y dirmngr && \
    apt-get install -y dirmngr=2.4.4-2ubuntu17.4 gnupg2 && \
    apt-get install -y libcurl4-openssl-dev libssl-dev xz-utils wget npm && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://nodejs.org/dist/v25.8.2/node-v25.8.2-linux-x64.tar.xz \
    && tar -xf node-v25.8.2-linux-x64.tar.xz \
    && cp node-v25.8.2-linux-x64/bin/node /opt/shiny-server/bin/node \
    && cp node-v25.8.2-linux-x64/bin/node /opt/shiny-server/ext/node/bin/node \
    && rm -rf node-v25.8.2-linux-x64*

WORKDIR /opt/shiny-server
RUN npm install --no-cache \
    handlebars@4.7.9 flatted@3.4.2 underscore@1.13.8 \
    tar@7.5.11 qs@6.14.2 minimatch@10.2.3 \
    glob@11.1.0 cross-spawn@7.0.5 brace-expansion@5.0.5

RUN wget https://registry.npmjs.org/tar/-/tar-7.5.11.tgz -O /tmp/tar.tgz && \
    wget https://registry.npmjs.org/minimatch/-/minimatch-10.2.3.tgz -O /tmp/mini.tgz && \
    wget https://registry.npmjs.org/qs/-/qs-6.14.2.tgz -O /tmp/qs.tgz && \
    wget https://registry.npmjs.org/glob/-/glob-11.1.0.tgz -O /tmp/glob.tgz && \
    wget https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.6.tgz -O /tmp/spawn.tgz && \
    wget https://registry.npmjs.org/brace-expansion/-/brace-expansion-5.0.5.tgz -O /tmp/brace.tgz

RUN mkdir -p /tmp/ex-tar /tmp/ex-mini /tmp/ex-qs /tmp/ex-glob /tmp/ex-spawn /tmp/ex-brace && \
    tar -xzf /tmp/tar.tgz -C /tmp/ex-tar && \
    tar -xzf /tmp/mini.tgz -C /tmp/ex-mini && \
    tar -xzf /tmp/qs.tgz -C /tmp/ex-qs && \
    tar -xzf /tmp/glob.tgz -C /tmp/ex-glob && \
    tar -xzf /tmp/spawn.tgz -C /tmp/ex-spawn && \
    tar -xzf /tmp/brace.tgz -C /tmp/ex-brace && \
    find /opt/shiny-server -name "tar" -type d -path "*/node_modules/tar" -exec cp -R /tmp/ex-tar/package/* {}/ \; && \
    find /opt/shiny-server -name "minimatch" -type d -path "*/node_modules/minimatch" -exec cp -R /tmp/ex-mini/package/* {}/ \; && \
    find /opt/shiny-server -name "qs" -type d -path "*/node_modules/qs" -exec cp -R /tmp/ex-qs/package/* {}/ \; && \
    find /opt/shiny-server -name "glob" -type d -path "*/node_modules/glob" -exec cp -R /tmp/ex-glob/package/* {}/ \; && \
    find /opt/shiny-server -name "cross-spawn" -type d -path "*/node_modules/cross-spawn" -exec cp -R /tmp/ex-spawn/package/* {}/ \; && \
    find /opt/shiny-server -name "brace-expansion" -type d -path "*/node_modules/brace-expansion" -exec cp -R /tmp/ex-brace/package/* {}/ \; && \
    rm -rf /tmp/ex-* /tmp/*.tgz


RUN install2.r --error --skipinstalled \
    shiny shinydashboard ggplot2 DT stringr dplyr \
    hash plotly plyr jsonlite shinyvalidate BiocManager \
    && R -e "BiocManager::install(c('Biostrings', 'ComplexHeatmap'), ask=FALSE)" \
    && rm -rf /tmp/downloaded_packages

COPY ./app/ /srv/shiny-server/dipdsa
COPY ./shiny-server.conf /etc/shiny-server/shiny-server.conf

RUN chmod -R 777 /srv/shiny-server/ \
    && sed -i -e 's/\blisten 3838\b/listen 8161/g' /etc/shiny-server/shiny-server.conf

USER shiny

EXPOSE 8161
CMD ["/usr/bin/shiny-server"]
