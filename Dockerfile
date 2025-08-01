FROM quay.io/centos/centos:latest
RUN dnf install -y httpd zip unzip curl
ADD https://www.tooplate.com/zip-templates/2135_mini_finance.zip /var/www/html/
WORKDIR /var/www/html/
RUN unzip photogenic.zip
RUN cp -rvf photogenic/* .
RUN rm -rf photogenic photogenic.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80 443
