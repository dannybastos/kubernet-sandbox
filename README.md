# Kubernet-sandbox
This is a kubernete-sandbox cluster


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
#creating a local registry
kubectl create deployment registry --image=registry:2
kubectl expose deployment registry --port=5000 --target-port=5000

#add insecure registry
sudo cat <<EOF >/etc/docker/daemon.json
    {
        "insecure-registries": ["<registry-ip>:<registry-port>"]
    }
EOF
sudo systemctl restart docker

#publishing the sample-app into local registry
git clone https://github.com/dannybastos/spring-boot-sample-app.git
cd spring-boot-sample-app/
docker-compose build
docker-compose push

#deploy sample-app into cluster
kubectl create deployment spring-boot-sample-app --image=<registry-ip>:<registry-port>/spring-boot-sample-app
kubectl expose deployment spring-boot-sample-app --port=8888 --type=NodePort

kubectl get services
NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
kubernetes               ClusterIP   10.96.0.1       <none>        443/TCP          47h
registry                 ClusterIP   10.102.8.96     <none>        5000/TCP         14m
spring-boot-sample-app   NodePort    10.107.241.16   <none>        8888:32150/TCP   3m50s
```

Test in :
> curl http://localhost:32150/hi

Enjoy!
