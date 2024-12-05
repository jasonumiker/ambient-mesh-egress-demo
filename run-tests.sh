#!/bin/bash

# Install test workload
kubectl apply -f https://raw.githubusercontent.com/istio/istio/refs/heads/master/samples/curl/curl.yaml
sleep 10
echo "--------------------"
# Test curl of httpbin.org
echo "curl results with nothing in place"
kubectl exec deploy/curl -- curl -sI http://httpbin.org/get
echo "--------------------"
# Create waypoint/egress-gateway and apply to common-infrastructure namespace
kubectl create namespace foo
echo "--------------------"
kubectl apply -f egress-gateway.yaml
sleep 10
echo "--------------------"
kubectl label namespace default istio.io/dataplane-mode=ambient
kubectl label namespace default istio.io/use-waypoint=egress-gateway
kubectl label namespace foo istio.io/dataplane-mode=ambient
kubectl label namespace foo istio.io/use-waypoint=egress-gateway
echo "--------------------"
kubectl apply -f serviceentry.yaml
echo "--------------------"
sleep 10
echo "curl before AuthorizationPolicy"
kubectl get serviceentry httpbin.org -oyaml
echo "--------------------"
kubectl exec deploy/curl -- curl -sI http://httpbin.org/get -v
echo "--------------------"
kubectl apply -f authorizationpolicy.yaml
echo "--------------------"
echo "curl after AuthorizationPolicy"
kubectl exec deploy/curl -- curl -sI http://httpbin.org/get -v
echo "--------------------"
kubectl apply -f https://raw.githubusercontent.com/istio/istio/refs/heads/master/samples/curl/curl.yaml -n foo
echo "--------------------"
echo "curl after AuthorizationPolicy from foo Namespace"
kubectl exec deploy/curl -- curl -sI http://httpbin.org/get -n foo