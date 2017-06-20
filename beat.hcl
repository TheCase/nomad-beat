job "metricbeat" {
    type = "system"
    datacenters = [ "dc1" ]
    constraint {
    }
    group "metricbeat" {
      count = 1
      ######### METRIC BEAT START ######
        task "metricbeat" {
        driver = "docker"
        config {
          image = "devops/filebeat-gen:develop"
	  labels {
	   task = "metricbeat"
	   job = "beats"
	  }
          force_pull  = true
          network_mode = "host"
          volumes = [
          "/proc:/hostfs/proc:ro",
          "/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro",
          "/:/hostfs:ro",
          "/var/run/docker.sock:/var/run/docker.sock"
          ]
          command = "metricbeat"
    			args = [
    			"-c",
          "/etc/beats/metricbeat.yml",
    			"-E",
          "name=${node.unique.name}"
          ]
        }
        resources {
          memory = 128
          network {
            mbits = 10
          }
        }
      }
  }
    ######### METRIC BEAT EOF ######
    ######### FILE BEAT START ######
  group "filebeat" {
    task "filebeat" {
      driver = "docker"
      config {
        image = "devops/filebeat-gen"
        labels {
           task = "filebeat"
           job = "beats"
        }
        force_pull  = true
        network_mode = "host"
        privileged = true
        volumes = [
        "/var/run/docker.sock:/var/run/docker.sock",
        "/var/lib/docker:/var/lib/docker",
        "/apps:/apps",
        "/apps/filebeat:/usr/local/bin/data"
        ]
      }
      env{
        "NOMAD_ALLOC"="/apps/nomad-data/alloc"
        "SERVER_HOST" = "${node.unique.name}"
      }
      resources {
        memory = 128
        network {
          mbits = 10
        }
      }
    }
  }
  ######### METRIC BEAT EOF ######
}
