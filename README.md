# phaselist

[![Build status](https://badge.buildkite.com/a998efb5cae58aefb9da7bb87a60e96453e48cf19f15c685ed.svg?branch=master)](https://buildkite.com/webselect/phase-list)

Build Docker Image
```
docker build -t pkumaschow/phaselist .
```

HTML Output (Default)
```
docker run --rm --name phaselist -t pkumaschow/phaselist
```

or

```
./scripts/makepage.sh > phaselist.html
```


Create Stack
```
aws cloudformation create-stack --template-body file://./phaselist.template --stack-name phaselist-dev
```

Update Stack
```
aws cloudformation update-stack --template-body file://./phaselist.template --stack-name phaselist-dev
```

or
```
./scripts/updatestack.sh
```

