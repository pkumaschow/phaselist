# DOCKER-VERSION 17.06.0-ce, build 02c1d87
FROM    perl:latest

LABEL   version="1.1"
LABEL   description="Spits out a HTML page containing upcoming moonphases and their dates"
LABEL   maintainer  Peter Kumaschow pkumaschow@gmail.com

RUN     curl -L http://cpanmin.us | perl - App::cpanminus

RUN     cpanm Carton

RUN     cachebuster=b776805 git clone https://github.com/pkumaschow/phaselist
RUN     cd phaselist && carton install
RUN     mv /root/phaselist/Phaselist.pm /root/phaselist/local/lib/perl5/

WORKDIR /root/phaselist
CMD     perl -I local/lib/perl5 phaselist.pl
