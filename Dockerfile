FROM nimmis/apache-php7:latest

RUN apt-get update
RUN apt-get install -y unzip libaio1 php-pear libcurl3-openssl-dev php7.0-dev php-ssh2
RUN apt-get clean -y

RUN echo "log_errors = On" >> /etc/php/7.0/apache2/php.ini
RUN echo "error_log = /dev/stderr" >> /etc/php/7.0/apache2/php.ini

RUN pecl install pecl_http

ADD instantclient-basic-linux.x64-12.2.0.1.0.zip /tmp/
ADD instantclient-sdk-linux.x64-12.2.0.1.0.zip /tmp/
ADD instantclient-sqlplus-linux.x64-12.2.0.1.0.zip /tmp/

RUN unzip /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sqlplus-linux.x64-12.2.0.1.0.zip -d /usr/local/
RUN ln -s /usr/local/instantclient_12_2 /usr/local/instantclient
RUN ln -s /usr/local/instantclient_12_2/libclntsh.so.12.1 /usr/local/instantclient_12_2/libclntsh.so
RUN ln -s /usr/local/instantclient_12_2/lib /usr/local/instantclient_12_2
RUN ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus

RUN echo 'instantclient,/usr/local/instantclient' | pecl install oci8
RUN echo "extension=oci8.so" > /etc/php/7.0/apache2/conf.d/30-oci8.ini
RUN ln -s /etc/php/7.0/apache2/conf.d/30-oci8.ini /etc/php/7.0/cli/conf.d/30-oci8.ini 

RUN echo "export ORACLE_HOME=/usr/local/instantclient" >> /etc/apache2/envvars
RUN echo "export ORACLE_INCLUDE_DIR=$ORACLE_HOME/lib" >> /etc/apache2/envvars
RUN echo "export ORACLE_LIBRARIES=$ORACLE_INCLUDE_DIR" >> /etc/apache2/envvars
RUN echo "export LD_LIBRARY_PATH=$ORACLE_INCLUDE_DIR" >> /etc/apache2/envvars
RUN echo "export PATH=$PATH:$ORACLE_HOME" >> /etc/apache2/envvars

RUN echo "/usr/local/instantclient" >> /etc/ld.so.conf

RUN ldconfig

RUN service apache2 restart

RUN php -i | grep oci8