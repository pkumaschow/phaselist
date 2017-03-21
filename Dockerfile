# DOCKER-VERSION 1.12.2
FROM        perl:latest

LABEL version="1.0"
LABEL description="Spits out a HTML page containing upcoming moonphases and their dates"
LABEL maintainer  Peter Kumaschow pkumaschow@gmail.com

RUN curl -L http://cpanmin.us | perl - App::cpanminus

RUN cpanm Carton

RUN cachebuster=b953b99 git clone https://github.com/pkumaschow/phaselist
RUN cd phaselist && carton install

WORKDIR phaselist
CMD perl -I local/lib/perl5 phaselist.pl
