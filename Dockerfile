# DOCKER-VERSION 1.12.2
FROM        perl:latest
MAINTAINER  Peter Kumaschow pkumaschow@gmail.com

RUN curl -L http://cpanmin.us | perl - App::cpanminus

RUN cpanm Carton

RUN cachebuster=b953b63 git clone https://github.com/pkumaschow/phaselist
RUN cd phaselist && carton install

WORKDIR phaselist
CMD perl -I local/lib/perl5 phaselist.pl
