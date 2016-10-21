# DOCKER-VERSION 1.12.2
FROM        perl:latest
MAINTAINER  Peter Kumaschow pkumaschow@gmail.com

RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm Carton Starman

RUN cachebuster=b953b38 git clone http://github.com/pkumaschow/phaselist
RUN cd phaselist && carton install --deployment

EXPOSE 8080

WORKDIR phaselist
CMD carton exec starman --port 8080 phaselist.pl
