build {
  sources = ["source.proxmox-iso.fedora"]

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
      "dnf update -y",
      "dnf groupinstall -y 'Development Tools'",
      "dnf install -y git wget curl vim nano htop tmux unzip tar gzip bzip2",
      "dnf install -y openssh-server sudo which net-tools"
    ]
  }

  # Install Python and pip
  provisioner "shell" {
    inline = [
      "dnf install -y python3 python3-pip python3-devel python3-virtualenv",
      "pip3 install --upgrade pip"
    ]
  }

  # Install Java (OpenJDK 11 - required for Spark)
  provisioner "shell" {
    inline = [
      "dnf install -y java-11-openjdk java-11-openjdk-devel",
      "echo 'JAVA_HOME=/usr/lib/jvm/java-11-openjdk' >> /etc/environment",
      "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk",
      "java -version"
    ]
  }

  # Install Scala
  provisioner "shell" {
    inline = [
      "dnf install -y scala",
      "scala -version"
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
      "pip3 install pyspark==3.5.0",
      "pip3 install pandas numpy scipy",
      "pip3 install matplotlib seaborn plotly",
      "pip3 install jupyter jupyterlab notebook",
      "pip3 install scikit-learn",
      "pip3 install pyarrow fastparquet",
      "pip3 install sqlalchemy psycopg2-binary pymongo",
      "pip3 install requests boto3",
      "pip3 install apache-airflow",
      "pip3 install delta-spark"
    ]
  }

  # Install Docker and Podman (Fedora includes both)
  provisioner "shell" {
    inline = [
      "dnf install -y docker docker-compose",
      "dnf install -y podman podman-compose",
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
      "pip3 install dbt-core dbt-postgres",
      "pip3 install great-expectations",
      "pip3 install prefect",
      "pip3 install poetry"
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

  # Install Apache Flink for stream processing
  provisioner "shell" {
    inline = [
      "wget https://archive.apache.org/dist/flink/flink-1.18.0/flink-1.18.0-bin-scala_2.12.tgz -P /tmp",
      "tar -xzf /tmp/flink-1.18.0-bin-scala_2.12.tgz -C /opt",
      "ln -s /opt/flink-1.18.0 /opt/flink",
      "echo 'export FLINK_HOME=/opt/flink' > /etc/profile.d/flink.sh",
      "echo 'export PATH=$PATH:$FLINK_HOME/bin' >> /etc/profile.d/flink.sh",
      "chmod +x /etc/profile.d/flink.sh",
      "rm -f /tmp/flink-1.18.0-bin-scala_2.12.tgz"
    ]
  }

  # Install fish shell and other shells
  provisioner "shell" {
    inline = [
      "dnf install -y fish zsh",
      "echo '/usr/bin/fish' >> /etc/shells",
      "echo '/usr/bin/zsh' >> /etc/shells"
    ]
  }

  # Install additional useful tools for data engineering
  provisioner "shell" {
    inline = [
      "dnf install -y postgresql-devel mariadb-devel",
      "pip3 install clickhouse-driver",
      "pip3 install redis",
      "pip3 install kafka-python",
      "pip3 install pytest pytest-cov black flake8 mypy",
      "pip3 install apache-flink",
      "pip3 install mlflow",
      "pip3 install dagster"
    ]
  }

  # Install monitoring and profiling tools
  provisioner "shell" {
    inline = [
      "dnf install -y sysstat iotop iftop ncdu",
      "pip3 install memory-profiler",
      "pip3 install line-profiler",
      "pip3 install py-spy"
    ]
  }

  # Enable and configure services
  provisioner "shell" {
    inline = [
      "systemctl enable sshd",
      "systemctl enable qemu-guest-agent",
      "systemctl enable cloud-init",
      "systemctl enable cloud-init-local",
      "systemctl enable cloud-config",
      "systemctl enable cloud-final"
    ]
  }

  # Configure SELinux for data engineering workloads
  provisioner "shell" {
    inline = [
      "dnf install -y policycoreutils-python-utils",
      "semanage fcontext -a -t bin_t '/opt/spark/bin(/.*)?'",
      "semanage fcontext -a -t bin_t '/opt/hadoop/bin(/.*)?'",
      "semanage fcontext -a -t bin_t '/opt/kafka/bin(/.*)?'",
      "semanage fcontext -a -t bin_t '/opt/flink/bin(/.*)?'",
      "restorecon -Rv /opt/spark /opt/hadoop /opt/kafka /opt/flink 2>/dev/null || true"
    ]
  }

  # Clean up and optimize
  provisioner "shell" {
    inline = [
      "dnf clean all",
      "rm -rf /tmp/*",
      "rm -rf /var/cache/dnf/*",
      "rm -rf /var/tmp/*"
    ]
  }

}
