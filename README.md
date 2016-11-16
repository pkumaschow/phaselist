# phaselist

Build Docker Image
```
docker build -t pkumaschow/phaselist .
```

HTML Output (Default)
```
docker run --rm --name phaselist -t pkumaschow/phaselist
```

Create Stack
```
aws cloudformation create-stack --template-body file://./phaselist.template --stack-name phaselist-dev
```

