# Kubernet-sandbox
This is a kubernete-sandbox cluster.

<kbd>*We install a local registry in the master just for testing proposes.</kbd>

## A simple cluster using 3 vm's ( one master and 2 workers )

## System requirements
- vagrant
- virtualbox

## How to run
```
vagrant up
```

## How to use
To connect into master use:
```
vagrant ssh master
```

## Publish an app

```
#get the master ip
MASTER_IP=`ip addr show eth1 | grep "inet " | awk '{print $2}' | cut -f1 -d/`

#creating a local registry
docker run -it -d --name=registry -p 5000:5000 registry:2

#find the ip of the registry services
kubectl get service registry

#publishing the sample-app into local registry
git clone https://github.com/dannybastos/spring-boot-sample-app.git
cd spring-boot-sample-app/
sed -i "s/127.0.0.1/$MASTER_IP/" docker-compose.yml
docker-compose build
docker-compose push

#deploy sample-app into cluster
kubectl create deployment spring-boot-sample-app --image=$MASTER_IP:5000/spring-boot-sample-app
kubectl expose deployment spring-boot-sample-app --port=8888
kubectl get services spring-boot-sample-app
```

Test in :
> curl http://<ip-from-service-spring-boot-sample-app>:8888/hi

Enjoy!
