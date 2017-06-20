# Filebeat + Docker-gen

Based on http://www.sandtable.com/forwarding-docker-logs-to-logstash/

## Example Usage
1. Create Dockerfile with certificates
    ```
    FROM gici/nomad-beat
    ENV LOGSTASH_HOST=filebeat.domain.com:443
    ADD certs/logstash-forwarder.crt /etc/pki/tls/certs/logstash-forwarder.crt
    ADD certs/logstash-forwarder.key /etc/pki/tls/private/logstash-forwarder.key
    ```
2. Run docker build
3. Edit beat.hcl with image name
4. Run beat.hcl
