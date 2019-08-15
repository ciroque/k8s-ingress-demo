# Kubernetes Service / Pod / Ingress demo

## Files

- apple.yaml: defines a Service that pulls a simple echo service Docker image and configures it to return "apple".
- banana.yaml: defines a Service that pulls a simple echo service Docker image and configures it to return "banana".
- orange.yaml: defines a Service that pulls a simple echo service Docker image and configures it to return "orange".
- ingress.yaml: defines two Ingress resource; one to route /apple to the apple Service; one to route /banana to the banana Service.
- ingress-orange.yaml: defines a single Ingress resource that routes /orange to the orage Service.

## Running

- Run `kubectl get service` ; shows a list of defined Services 
- Run `kubectl get pod` ; shows a list of defined Pods
- Run `kubectl get ingress` ; shows a list of defined Ingresses
- Run `kubectl apply -f apple.yaml` ; creates the Apple Pod and Service
- Run `kubectl apply -f banana.yaml` ; creates the Banana Pod and Service
- Run `kubectl get service` ; shows the two services have been created
- Run `kubectl describe service apple` ; shows that the Service is of type 'ClusterIP' and not 'NodePort'
- Run `kubectl apply -f ingress.yaml` ; creates the Ingress resource
- Run `kubectl describe ingress example-ingress` ; shows the Ingress definition, grab the IP address
- Run `curl -kL http://<ingress_ip>:8080/apple` ; should respond with "apple" (note: it may take a few seconds to create and propagate the nginx configuration)
- Run `curl -kL http://<ingress_ip>:8080/banana` ; should respond with "banana"
- Run `curl -kL http://<ingress_ip>:8080/orange` ; should return a 404
- Run `kubectl apply -f orange.yaml` ; creates the orange Service
- Run `curl -kL http://<ingress_ip>:8080/orange` ; still a 404
- Run `kubectl apply ingress-orange.yaml` ; creates the orange-ingress
- Run `curl -kL http://<ingress_ip>:8080/orange` ; should respond with "orange" after the spin-up time

## Cleanup
- Run `kubectl delete -f ingress-orange.yaml`
- Run `kubectl delete -f orange.yaml`
- Run `kubectl delete -f ingress.yaml`
- Run `kubectl delete -f apple.yaml`

## References

[Understanding kubernetes networking: pods](https://medium.com/google-cloud/understanding-kubernetes-networking-pods-7117dd28727?)

[Using a Network Load Balancer with the NGINX Ingress Controller on Amazon EKS](https://aws.amazon.com/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/)


