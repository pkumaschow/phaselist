# DOCKER-VERSION 1.12.2
FROM        perl:latest
MAINTAINER  Peter Kumaschow pkumaschow@gmail.com

RUN curl -L http://cpanmin.us | perl - App::cpanminus
#RUN cpanm Carton Starman
RUN cpanm Carton

RUN cachebuster=b953b49 git clone http://github.com/pkumaschow/phaselist
RUN cd phaselist && carton install --deployment

#EXPOSE 8080

WORKDIR phaselist
CMD perl phaselist.pl
