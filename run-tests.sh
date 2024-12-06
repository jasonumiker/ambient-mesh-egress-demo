# Install curl service in default
kubectl apply -f curl.yaml
kubectl exec deploy/curl -- curl -sI http://httpbin.org/get -v

# Set up ambient in the default namespace
kubectl label namespace default istio.io/dataplane-mode=ambient
/root/.istioctl/bin/istioctl waypoint apply --enroll-namespace --name egress-gateway --namespace default

# Add the serviceentry for httpbin.org
kubectl apply -f serviceentry.yaml

# Add the authorizationpolicy only allowing the curl SA
kubectl apply -f authorizationpolicy.yaml

# Rerun the curls
kubectl exec deploy/curl -- curl -sI http://httpbin.org/get -v
kubectl exec deploy/curl-defaultsa -- curl -sI http://httpbin.org/get -v