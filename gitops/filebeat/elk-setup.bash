#Step 1: Update Ubuntu Server
-----------------------------
sudo apt update && sudo apt upgrade -y

#Step 2: Install Java
---------------------
sudo apt install openjdk-17-jdk -y

#Verify the installation:
java -version

#Step 3: Install and Configure Elasticsearch

Add the Elasticsearch repository.

=> wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-archive-keyring.gpg

=> echo "deb [signed-by=/usr/share/keyrings/elasticsearch-archive-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

#Install Elasticsearch:
-----------------------
sudo apt update
sudo apt install elasticsearch

###After Instalation completion below data will be generated :
---------------------------------------------------------

#Authentication and authorization are enabled.
#TLS for the transport and HTTP layers is enabled and configured.

#The generated password for the elastic built-in superuser is : uaa5di1qmFCID=Bb+Fru  #admin password

#If this node should join an existing cluster, you can reconfigure this with
'/usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token <token-here>'
#after creating an enrollment token on your existing cluster.

#You can complete the following actions at any time:

#Reset the password of the elastic built-in superuser with
'/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic'.

#Generate an enrollment token for Kibana instances with
 '/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana'.  #Kibana Join token

#Generate an enrollment token for Elasticsearch nodes with
'/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node'.
------------------------------------------------------------


#adjust configuration file elasticsearch.yml

vi /etc/elasticsearch/elasticsearch.yml

# Elasticsearch configuration example
cluster.name: brac-elk
network.host: 0.0.0.0
http.port: 9200

#Enable and start Elasticsearch service

sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

tail -f /var/log/elasticsearch/brac-elk.log  # Check elk log

#Troubleshoting elastic search:
-------------------------------
#Verify Data in Elasticsearch:
curl -k -u elastic:your_password https://192.168.44.150:9200/_cat/indices?v

#manually query the logs from Elasticsearch
curl -k -u elastic:your_password https://192.168.44.150:9200/filebeat-*/_search?pretty

#Check the Cluster Health
curl -k -u elastic:your_password https://192.168.44.150:9200/_cluster/health?pretty

#Check Unassigned Shards
curl -k -u elastic:your_password https://192.168.44.150:9200/_cat/shards?v

# Check Index-Specific Shard Status
curl -k -u elastic:your_password https://192.168.44.150:9200/_cluster/allocation/explain?pretty

#Step 4: Install and Configure Kibana
-------------------------------------

sudo apt install kibana

#Edit the kibana.yml file

vi /etc/kibana/kibana.yml

server.port: 5601
server.host: "0.0.0.0"

elasticsearch.hosts: ["https://192.168.44.150:9200"] 
elasticsearch.username: "elastic" 
elasticsearch.password: "<password>"

#Enable and start Kibana
sudo systemctl enable kibana
sudo systemctl start kibana


http://your_server_ip:5601  #in a web browser and log in with the elastic username and password.

#Generate Kibana enrollment token and verification-code
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana .
/usr/share/kibana/bin/kibana-verification-code

Step 5: Install Logstash


Install Logstash
sudo apt install logstash

Start Logstash

sudo systemctl enable logstash
sudo systemctl start logstash
