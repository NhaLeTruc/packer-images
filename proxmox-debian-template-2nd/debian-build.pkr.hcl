build {
  sources = ["source.proxmox-iso.debian"]

  # Copy cloud-init configuration
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "http/cloud.cfg"
  }

  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg.d/99-pve.cfg"
    source      = "http/99-pve.cfg"
  }

  # Update system and install base development tools
  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install -y build-essential git wget curl vim nano htop tmux unzip",
      "apt-get install -y openssh-server sudo net-tools ca-certificates gnupg lsb-release"
    ]
  }

  # Install Python and pip
  provisioner "shell" {
    inline = [
      "apt-get install -y python3 python3-pip python3-dev python3-venv",
      "pip3 install --upgrade pip --break-system-packages"
    ]
  }

  # Install Java (OpenJDK 17 - Debian 12 default)
  provisioner "shell" {
    inline = [
      "apt-get install -y default-jdk default-jre",
      "java -version",
      "echo 'JAVA_HOME=/usr/lib/jvm/default-java' >> /etc/environment",
      "export JAVA_HOME=/usr/lib/jvm/default-java"
    ]
  }

  # Install Scala
  provisioner "shell" {
    inline = [
      "wget https://downloads.lightbend.com/scala/2.12.18/scala-2.12.18.tgz -P /tmp",
      "tar -xzf /tmp/scala-2.12.18.tgz -C /opt",
      "ln -s /opt/scala-2.12.18 /opt/scala",
      "echo 'export SCALA_HOME=/opt/scala' > /etc/profile.d/scala.sh",
      "echo 'export PATH=$PATH:$SCALA_HOME/bin' >> /etc/profile.d/scala.sh",
      "chmod +x /etc/profile.d/scala.sh",
      "rm -f /tmp/scala-2.12.18.tgz"
    ]
  }

  # Install Apache Spark
  provisioner "shell" {
    inline = [
      "wget https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz -P /tmp",
      "tar -xzf /tmp/spark-3.5.0-bin-hadoop3.tgz -C /opt",
      "ln -s /opt/spark-3.5.0-bin-hadoop3 /opt/spark",
      "echo 'export SPARK_HOME=/opt/spark' > /etc/profile.d/spark.sh",
      "echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >> /etc/profile.d/spark.sh",
      "echo 'export PYSPARK_PYTHON=python3' >> /etc/profile.d/spark.sh",
      "chmod +x /etc/profile.d/spark.sh",
      "rm -f /tmp/spark-3.5.0-bin-hadoop3.tgz"
    ]
  }

  # Install Python data engineering libraries
  provisioner "shell" {
    inline = [
      "pip3 install --break-system-packages pyspark==3.5.0",
      "pip3 install --break-system-packages pandas numpy scipy",
      "pip3 install --break-system-packages matplotlib seaborn plotly",
      "pip3 install --break-system-packages jupyter jupyterlab notebook",
      "pip3 install --break-system-packages scikit-learn",
      "pip3 install --break-system-packages pyarrow fastparquet",
      "pip3 install --break-system-packages sqlalchemy psycopg2-binary pymongo",
      "pip3 install --break-system-packages requests boto3",
      "pip3 install --break-system-packages apache-airflow",
      "pip3 install --break-system-packages delta-spark"
    ]
  }

  # Install Docker
  provisioner "shell" {
    inline = [
      "install -m 0755 -d /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc",
      "chmod a+r /etc/apt/keyrings/docker.asc",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "apt-get update",
      "apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "systemctl enable docker"
    ]
  }

  # Install Hadoop client tools
  provisioner "shell" {
    inline = [
      "wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz -P /tmp",
      "tar -xzf /tmp/hadoop-3.3.6.tar.gz -C /opt",
      "ln -s /opt/hadoop-3.3.6 /opt/hadoop",
      "echo 'export HADOOP_HOME=/opt/hadoop' > /etc/profile.d/hadoop.sh",
      "echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> /etc/profile.d/hadoop.sh",
      "echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> /etc/profile.d/hadoop.sh",
      "chmod +x /etc/profile.d/hadoop.sh",
      "rm -f /tmp/hadoop-3.3.6.tar.gz"
    ]
  }

  # Install additional data engineering tools
  provisioner "shell" {
    inline = [
      "pip3 install --break-system-packages dbt-core dbt-postgres",
      "pip3 install --break-system-packages great-expectations",
      "pip3 install --break-system-packages prefect",
      "pip3 install --break-system-packages dagster",
      "pip3 install --break-system-packages poetry"
    ]
  }

  # Install Apache Kafka
  provisioner "shell" {
    inline = [
      "wget https://archive.apache.org/dist/kafka/3.6.0/kafka_2.12-3.6.0.tgz -P /tmp",
      "tar -xzf /tmp/kafka_2.12-3.6.0.tgz -C /opt",
      "ln -s /opt/kafka_2.12-3.6.0 /opt/kafka",
      "echo 'export KAFKA_HOME=/opt/kafka' > /etc/profile.d/kafka.sh",
      "echo 'export PATH=$PATH:$KAFKA_HOME/bin' >> /etc/profile.d/kafka.sh",
      "chmod +x /etc/profile.d/kafka.sh",
      "rm -f /tmp/kafka_2.12-3.6.0.tgz"
    ]
  }

  # Install MinIO client for S3-compatible storage
  provisioner "shell" {
    inline = [
      "wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc",
      "chmod +x /usr/local/bin/mc"
    ]
  }

  # Install additional database clients and tools
  provisioner "shell" {
    inline = [
      "apt-get install -y postgresql-client postgresql-common",
      "apt-get install -y mariadb-client",
      "pip3 install --break-system-packages clickhouse-driver",
      "pip3 install --break-system-packages redis",
      "pip3 install --break-system-packages kafka-python",
      "pip3 install --break-system-packages elasticsearch"
    ]
  }

  # Install data quality and testing tools
  provisioner "shell" {
    inline = [
      "pip3 install --break-system-packages pytest pytest-cov",
      "pip3 install --break-system-packages black flake8 mypy",
      "pip3 install --break-system-packages pandera",
      "pip3 install --break-system-packages pydantic"
    ]
  }

  # Install Spark performance monitoring tools
  provisioner "shell" {
    inline = [
      "pip3 install --break-system-packages py4j",
      "pip3 install --break-system-packages sparkmonitor"
    ]
  }

  # Install fish shell (optional but nice)
  provisioner "shell" {
    inline = [
      "echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | tee /etc/apt/sources.list.d/shells:fish:release:3.list",
      "curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null",
      "apt-get update",
      "apt-get install -y fish",
      "echo '/usr/bin/fish' >> /etc/shells"
    ]
  }

  # Enable and configure services
  provisioner "shell" {
    inline = [
      "systemctl enable ssh",
      "systemctl enable qemu-guest-agent",
      "systemctl enable cloud-init",
      "systemctl enable cloud-init-local",
      "systemctl enable cloud-config",
      "systemctl enable cloud-final"
    ]
  }

  # Clean up and optimize
  provisioner "shell" {
    inline = [
      "apt-get autoremove -y",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*",
      "rm -rf /tmp/*",
      "rm -rf /var/tmp/*"
    ]
  }

}
