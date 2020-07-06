# JBrowse
#  Alternative JBrowse setup needed if you use plugins
#   https://jbrowse.org/docs/installation.html#alternative-jbrowse-setup-needed-if-you-use-plugins

FROM centos:centos7 
ENV DEBIAN_FRONTEND=noninteractive

RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y epel-release && \
    yum install -y zlib-devel perl-ExtUtils-MakeMaker nginx which && \
    yum install -y https://rpm.nodesource.com/pub_11.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm nodejs

WORKDIR /usr/share/nginx/html/

RUN git config --global http.sslverify false && \
    git clone --recursive https://github.com/togovar/jbrowse 

RUN cd jbrowse && ./setup.sh 

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
