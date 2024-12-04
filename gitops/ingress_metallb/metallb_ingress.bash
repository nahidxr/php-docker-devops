Confiugre Metallb:
-----------------
Use kubectl to apply the MetalLB manifest:
------------------
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/metallb.yaml


Create MetalLB ConfigMap:
-------------------------
Create a ConfigMap to configure MetalLB. Save the following YAML to a file (e.g., metallb-config.yaml):

vi metallb-config.yaml
----------------------
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.44.200-192.168.44.210

kubectl apply -f metallb-config.yaml

#Check the MetalLB pods to ensure they are running:
kubectl get pods -n metallb-system



Configure Ingress:

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/baremetal/deploy.yaml
kubectl get all -n ingress-nginx

# Edit svc service type ClusterIP to Loadbalancer
kubectl -n ingress-nginx edit svc ingress-nginx-controller

go to bottom of the file and change type from clusteip to LoadBalancer

type: LoadBalancer

Save and Exit

kubectl -n ingress-nginx get svc # Check external ip for this serivce

#Create Ingress Resoureces in your application namesapce:
-------------------------------------------------------
vi bhw-ingress.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: bhw-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: bhw.csl.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: bhw-frontend
            port:
              number: 80

kubectl apply -f bhw-ingress.yaml
kubectl get ingress #check ingress resourece

Check Log From Ingress Controller:

kubectl -n ingress-nginx logs -f ingress-nginx-controller-7845fcfbdf-jztdr
