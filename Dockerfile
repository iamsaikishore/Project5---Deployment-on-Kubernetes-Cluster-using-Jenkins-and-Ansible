FROM ubuntu
MAINTAINER iamsaikishore@gmail.com
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 zip unzip && \
    apt-get clean
ADD https://www.free-css.com/assets/files/free-css-templates/download/page254/photogenic.zip /var/www/html/
WORKDIR /var/www/html/
RUN unzip photogenic.zip
RUN cp -rvf photogenic/* .
RUN rm -rf photogenic photogenic.zip
CMD ["apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80



# FROM ubuntu
# MAINTAINER iamsaikishore@gmail.com
# RUN apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 zip unzip && \
#     apt-get clean
# ADD https://www.free-css.com/assets/files/free-css-templates/download/page265/shine.zip /var/www/html/
# WORKDIR /var/www/html/
# RUN unzip shine.zip
# RUN cp -rvf shine/* .
# RUN rm -rf shine shine.zip
# CMD ["apache2ctl", "-D", "FOREGROUND"]
# EXPOSE 80
