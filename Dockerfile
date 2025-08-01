FROM quay.io/centos/centos:latest
RUN dnf install -y httpd zip unzip curl
ADD https://www.tooplate.com/zip-templates/2135_mini_finance.zip /var/www/html/
WORKDIR /var/www/html/
RUN unzip 2135_mini_finance.zip
RUN cp -rvf 2135_mini_finance/* .
RUN rm -rf 2135_mini_finance 2135_mini_finance.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80 443
