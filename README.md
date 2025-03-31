# ELK_Stack_Deployment

Used for log monitoring our app 

ELK:
E - Elastic 
L - Logstash
K - Kibana

when app run it generate a lot of logs (raw data) elk stack help us 

app running on ec2 -> 
    the app generate logs  app.log (raw format not easy to analyze)
    install another tool (filebeat)
    create another ec2 machine(ELK stack)
        logs stash get the log from filebeat(5044) -> it will parse the log/filter using grok (how to filter)
        and now the data will be structured
        elasticsearch - get the data (index the data) it will be faster/easer to analyze the data 
        forwarded to kibana visual tool convert it to chart

ec2 - app -generate log -> filebeat
ec2 - logstash get the log from filebeat and filter it -> elasticsearch (index the data) -> kibana (visualtion tool graphs,...,dashboards) 


# modify the file : /etc/elasticsearch/elasticsearch.yml
# network.host: 0.0.0.0
# cluster.name: my-cluster
# node.name: node-1
# descovery.type: single-node
# enable & start elasticsearch

# vim /etc/logstash/conf.d/logstash.conf
# input{
#  beats{
#     port => 5044
# }
#}
# filter{
#   grok{ 
#     match => {"message" => "%TIMESTAMP_ISO8601:log_timestamp}%{LOGLEVEL:log_level}%{GREEDYDATA:log_message}"}
# }
# output {
#   elasticsearch {
#    hosts => ["http://localhost:9200"]
#    index => "logs-%{+YYYY.MM.dd}"
#  }
#  stdout {codec => rubydebug }
# start logstash



# sudo vim /etc/kibana/kibana.yml
# server.host: "0.0.0.0"
# elasticsearch.hosts: ["http://localhost:9200"]
# start kibana

