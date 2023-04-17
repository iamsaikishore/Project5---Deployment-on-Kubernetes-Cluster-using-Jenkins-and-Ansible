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

# ADD https://www.free-css.com/assets/files/free-css-templates/download/page254/photogenic.zip /var/www/html/

# FROM ubuntu
# MAINTAINER iamsaikishore@gmail.com
# RUN apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 zip unzip && \
#     apt-get clean
# ADD https://www.free-css.com/assets/files/free-css-templates/download/page290/element.zip /var/www/html/
# WORKDIR /var/www/html/
# RUN mkdir zip
# RUN unzip element.zip -d ./zip/
# RUN cp -rvf ./zip/*/* .
# RUN rm -rf zip element.zip
# CMD ["apache2ctl", "-D", "FOREGROUND"]
# EXPOSE 80

# FROM ubuntu
# MAINTAINER iamsaikishore@gmail.com
# RUN apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 zip unzip && \
#     apt-get clean
# ADD https://www.free-css.com/assets/files/free-css-templates/download/page289/zon.zip /var/www/html/
# WORKDIR /var/www/html/
# RUN mkdir zip
# RUN unzip zon.zip -d ./zip/
# RUN cp -rvf ./zip/*/* .
# RUN rm -rf zip zon.zip
# CMD ["apache2ctl", "-D", "FOREGROUND"]
# EXPOSE 80
