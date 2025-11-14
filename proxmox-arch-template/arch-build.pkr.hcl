build {
  sources = ["source.proxmox-iso.arch"]

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
      "pacman -Syu --noconfirm",
      "pacman -S --noconfirm base-devel git wget curl vim nano htop tmux unzip",
      "pacman -S --noconfirm openssh sudo which"
    ]
  }

  # Install Python and pip
  provisioner "shell" {
    inline = [
      "pacman -S --noconfirm python python-pip python-virtualenv",
      "pip install --upgrade pip"
    ]
  }

  # Install Java (OpenJDK 11 - required for Spark)
  provisioner "shell" {
    inline = [
      "pacman -S --noconfirm jdk11-openjdk",
      "archlinux-java set java-11-openjdk",
      "echo 'JAVA_HOME=/usr/lib/jvm/java-11-openjdk' >> /etc/environment",
      "java -version"
    ]
  }

  # Install Scala
  provisioner "shell" {
    inline = [
      "pacman -S --noconfirm scala",
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
      "pip install pyspark==3.5.0",
      "pip install pandas numpy scipy",
      "pip install matplotlib seaborn plotly",
      "pip install jupyter jupyterlab notebook",
      "pip install scikit-learn",
      "pip install pyarrow fastparquet",
      "pip install sqlalchemy psycopg2-binary pymongo",
      "pip install requests boto3",
      "pip install apache-airflow",
      "pip install delta-spark"
    ]
  }

  # Install Docker
  provisioner "shell" {
    inline = [
      "pacman -S --noconfirm docker docker-compose",
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
      "pip install dbt-core dbt-postgres",
      "pip install great-expectations",
      "pip install prefect",
      "pip install poetry"
    ]
  }

  # Install Apache Kafka (useful for data streaming)
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

  # Install fish shell (optional but nice)
  provisioner "shell" {
    inline = [
      "pacman -S --noconfirm fish",
      "echo '/usr/bin/fish' >> /etc/shells"
    ]
  }

  # Install additional useful tools for data engineering
  provisioner "shell" {
    inline = [
      "pacman -S --noconfirm postgresql-libs mariadb-clients",
      "pip install clickhouse-driver",
      "pip install redis",
      "pip install kafka-python",
      "pip install pytest pytest-cov black flake8 mypy"
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

  # Clean up and optimize
  provisioner "shell" {
    inline = [
      "pacman -Scc --noconfirm",
      "rm -rf /tmp/*",
      "rm -rf /var/cache/pacman/pkg/*",
      "rm -rf /var/tmp/*"
    ]
  }

}
