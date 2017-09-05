# Master image
FROM centos:7
MAINTAINER sawada@stanfoot.com

# Base package
RUN df -h
RUN yum -y update
RUN yum -y install libxml2 libxml2-devel libcurl-devel libjpeg-turbo-devel libpng-devel libmcrypt-devel readline-devel libtidy-devel libxslt-devel gcc make
RUN yum install -y git zip unzip openssl-devel curl-devel vim-enhanced wget

WORKDIR /root

# Install Nginx
RUN rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum -y update nginx-release-centos
RUN yum -y --enablerepo=nginx install nginx
RUN systemctl enable nginx
COPY vhost.conf /etc/nginx/conf.d/default.conf

# Install PHP7.1
RUN rpm --import https://rpms.remirepo.net/RPM-GPG-KEY-remi
RUN yum install yum-utils https://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
RUN yum-config-manager --enable remi-php71
RUN yum -y install php php-fpm php-intl php-mbstring php-xml php-pdo php-mysqlnd php-opcache php-mcrypt php-gd php-devel php-zip

COPY ./www.conf /etc/php-fpm.d/www.conf
RUN systemctl enable php-fpm

# Install Laravel newest version
RUN curl -s http://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Set date JST
RUN cp /etc/localtime /etc/localtime.org
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# alias
RUN echo 'alias artisan="php artisan"' >> ~/.bashrc
RUN echo 'alias g="git"' >> ~/.bashrc
RUN echo 'alias ls="ls -la"' >> ~/.bashrc
RUN echo 'alias rm="rm -r"' >> ~/.bashrc
RUN echo 'alias sb="source ~/.bashrc"' >> ~/.bashrc
RUN echo 'alias app="cd /var/www/html/app"' >> ~/.bashrc

## php-timecop
#WORKDIR /root/dl
#RUN git clone https://github.com/hnw/php-timecop.git
#WORKDIR /root/dl/php-timecop
#RUN phpize
#RUN ./configure
#RUN make
#RUN make install
#COPY php.ini /etc/php.ini
#RUN rm -rf /root/dl
#WORKDIR /root

# vim config
COPY .vimrc /root/

WORKDIR /var/www/html/app
EXPOSE 80
