FROM ubuntu
MAINTAINER iamsaikishore@gmail.com
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 zip unzip && \
    apt-get clean
ADD https://www.free-css.com/assets/files/free-css-templates/download/page290/tourist.zip /var/www/html/
WORKDIR /var/www/html/
RUN mkdir zip
RUN unzip tourist.zip -d ./zip/
RUN cp -rvf ./zip/*/* .
RUN rm -rf zip tourist.zip
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
