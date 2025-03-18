# Testing HPA

```bash
# apply the files from myapp-hpa-one
kubectl apply -f myapp-hpa-one

# check if the pod is running
watch -t kubectl get pods -n myapp-one

# check the hpa 
watch -t kubectl get hpa -n myapp-one

# get the service name and port
kubectl get svc -m myapp-one

# port-forward the app to test it
kubectl port-forward svc/myapp 8080 -n myapp-one

# send a request using curl, insomnia or other app (it will do a fibonacci, this example will request more cpu usage)
curl "localhost:8080/api/cpu?index=44"

# delete the resources
kubectl delete ns myapp-one

```