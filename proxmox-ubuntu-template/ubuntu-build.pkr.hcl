build {
  sources = ["source.proxmox-iso.ubuntu"]

  # Copy default cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "http/cloud.cfg"
  }

  # Copy Proxmox cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg.d/99-pve.cfg"
    source      = "http/99-pve.cfg"
  }

  # Install base system packages and development tools
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ca-certificates curl wget gnupg lsb-release software-properties-common",
      "sudo apt-get install -y build-essential git make vim nano htop tmux unzip",
      "sudo apt-get install -y python3-pip python3-dev python3-venv",
    ]
  }

  # Install Java (OpenJDK 11 - required for Spark)
  provisioner "shell" {
    inline = [
      "sudo apt-get install -y openjdk-11-jdk",
      "java -version",
      "echo 'JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' | sudo tee -a /etc/environment",
      "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
    ]
  }

  # Install Scala
  provisioner "shell" {
    inline = [
      "wget https://downloads.lightbend.com/scala/2.12.18/scala-2.12.18.tgz -P /tmp",
      "sudo tar -xzf /tmp/scala-2.12.18.tgz -C /opt",
      "sudo ln -s /opt/scala-2.12.18 /opt/scala",
      "echo 'export SCALA_HOME=/opt/scala' | sudo tee -a /etc/profile.d/scala.sh",
      "echo 'export PATH=$PATH:$SCALA_HOME/bin' | sudo tee -a /etc/profile.d/scala.sh",
      "sudo chmod +x /etc/profile.d/scala.sh",
      "rm -f /tmp/scala-2.12.18.tgz"
    ]
  }

  # Install Apache Spark
  provisioner "shell" {
    inline = [
      "wget https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz -P /tmp",
      "sudo tar -xzf /tmp/spark-3.5.0-bin-hadoop3.tgz -C /opt",
      "sudo ln -s /opt/spark-3.5.0-bin-hadoop3 /opt/spark",
      "echo 'export SPARK_HOME=/opt/spark' | sudo tee -a /etc/profile.d/spark.sh",
      "echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' | sudo tee -a /etc/profile.d/spark.sh",
      "echo 'export PYSPARK_PYTHON=python3' | sudo tee -a /etc/profile.d/spark.sh",
      "sudo chmod +x /etc/profile.d/spark.sh",
      "rm -f /tmp/spark-3.5.0-bin-hadoop3.tgz"
    ]
  }

  # Install Python data engineering libraries
  provisioner "shell" {
    inline = [
      "sudo pip3 install --upgrade pip",
      "sudo pip3 install pyspark==3.5.0",
      "sudo pip3 install pandas numpy scipy",
      "sudo pip3 install matplotlib seaborn plotly",
      "sudo pip3 install jupyter jupyterlab notebook",
      "sudo pip3 install scikit-learn",
      "sudo pip3 install pyarrow fastparquet",
      "sudo pip3 install sqlalchemy psycopg2-binary pymongo",
      "sudo pip3 install requests boto3",
      "sudo pip3 install apache-airflow",
      "sudo pip3 install delta-spark"
    ]
  }

  # Install Docker
  provisioner "shell" {
    inline = [
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
    ]
  }

  # Install Hadoop client tools (optional)
  provisioner "shell" {
    inline = [
      "wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz -P /tmp",
      "sudo tar -xzf /tmp/hadoop-3.3.6.tar.gz -C /opt",
      "sudo ln -s /opt/hadoop-3.3.6 /opt/hadoop",
      "echo 'export HADOOP_HOME=/opt/hadoop' | sudo tee -a /etc/profile.d/hadoop.sh",
      "echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' | sudo tee -a /etc/profile.d/hadoop.sh",
      "echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' | sudo tee -a /etc/profile.d/hadoop.sh",
      "sudo chmod +x /etc/profile.d/hadoop.sh",
      "rm -f /tmp/hadoop-3.3.6.tar.gz"
    ]
  }

  # Install additional data engineering tools
  provisioner "shell" {
    inline = [
      "sudo pip3 install dbt-core dbt-postgres",
      "sudo pip3 install great-expectations",
      "sudo pip3 install prefect",
      "curl -sSL https://install.python-poetry.org | python3 -"
    ]
  }

  # Install fish shell (optional but nice to have)
  provisioner "shell" {
    inline = [
      "sudo apt-add-repository ppa:fish-shell/release-3 -y",
      "sudo apt-get update",
      "sudo apt-get install -y fish",
      "sudo echo /usr/bin/fish | sudo tee -a /etc/shells"
    ]
  }

  # Clean up and optimize
  provisioner "shell" {
    inline = [
      "sudo apt-get autoremove -y",
      "sudo apt-get clean",
      "sudo rm -rf /var/lib/apt/lists/*",
      "sudo rm -rf /tmp/*"
    ]
  }
  
}