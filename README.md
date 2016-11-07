# phaselist

Build Docker Image
```
docker build -t pkumaschow/phaselist .
```

Text Output (Default)
```
docker run --rm --name phaselist -t pkumaschow/phaselist
```

HTML Output
```
docker run --rm --name phaselist -t pkumaschow/phaselist perl -I local/lib/perl5 phaselist.pl -html
```

Create Stack
```
aws cloudformation create-stack --template-body file://./phaselist.template --stack-name phaselist-dev
```

