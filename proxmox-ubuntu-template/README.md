# Ubuntu Data Engineering Golden Image for Proxmox

## Overview

Packer configuration for building an Ubuntu Linux 'golden image' Proxmox template optimized for data engineering workloads, specifically designed to support PySpark and Scala Spark development and production environments.

## Features

### Core Infrastructure
- **Ubuntu 22.04 LTS** base image
- **Cloud-init** for automated configuration when cloning
- **QEMU guest agent** for Proxmox integration
- **Docker** with Docker Compose for containerized workflows
- Ready for Ansible automation

### Data Engineering Stack

#### Apache Spark 3.5.0
- Pre-installed Apache Spark with Hadoop 3 bindings
- Configured environment variables (`SPARK_HOME`, `PATH`)
- Ready for both standalone and cluster modes

#### Scala 2.12.18
- Scala runtime and compiler
- Compatible with Spark 3.5.0
- Configured environment variables (`SCALA_HOME`)

#### Python Data Engineering Ecosystem
- **PySpark 3.5.0** - Python API for Apache Spark
- **Pandas** - Data manipulation and analysis
- **NumPy** - Numerical computing
- **SciPy** - Scientific computing
- **Matplotlib, Seaborn, Plotly** - Data visualization
- **Jupyter Lab & Notebook** - Interactive development environment
- **Scikit-learn** - Machine learning library
- **PyArrow, FastParquet** - Columnar data format support
- **SQLAlchemy, psycopg2, pymongo** - Database connectors
- **Apache Airflow** - Workflow orchestration
- **Delta-Spark** - Delta Lake support
- **dbt-core** - Data transformation tool
- **Great Expectations** - Data validation framework
- **Prefect** - Modern workflow orchestration
- **Poetry** - Python dependency management

#### Hadoop 3.3.6
- Hadoop client tools for HDFS interaction
- Configured environment variables (`HADOOP_HOME`, `HADOOP_CONF_DIR`)

#### Development Tools
- **Java OpenJDK 11** - Required for Spark
- **Git, Make** - Version control and build tools
- **Vim, Nano** - Text editors
- **htop, tmux** - System monitoring and terminal multiplexing
- **Fish shell** - Modern shell with auto-completion

## System Requirements

### Recommended VM Specifications
- **CPU**: 4 cores (host CPU type for best performance)
- **Memory**: 8192 MB (8 GB) minimum, 16 GB recommended for production
- **Disk**: 50 GB minimum (stores Spark, Hadoop, and Python libraries)
- **Storage Format**: Raw (best performance) or qcow2

### Proxmox Requirements
- Proxmox VE 7.x or later
- Packer 1.9.1 or later
- Sufficient storage for template and clones

## Quick Start

### 1. Download Ubuntu ISO

Download Ubuntu 22.04 LTS Server ISO and upload to your Proxmox server:

```bash
# On Proxmox server
cd /var/lib/vz/template/iso
wget https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-live-server-amd64.iso
```

### 2. Configure Build Variables

Create `vars/build.pkrvars.hcl` from the sample:

```bash
cp vars/build.pkrvars.hcl.sample vars/build.pkrvars.hcl
```

Edit `vars/build.pkrvars.hcl` with your Proxmox settings:

```hcl
proxmox_node = "pve"              # Your Proxmox node name
vm_id = 800                        # Template VM ID
template_name = "ubuntu-dataeng"
template_name_suffix = "-22.04"

# Update ISO path to match your Proxmox storage
iso_file = "local:iso/ubuntu-22.04.3-live-server-amd64.iso"

# Adjust resources based on your needs
cores = 4
memory = 8192
disk_size = "50G"
```

### 3. Set Environment Variables

Create `vars/env` from the sample:

```bash
cp vars/env.sample vars/env
```

Configure your Proxmox API credentials:

```bash
export PROXMOX_URL="https://your-proxmox-server:8006/api2/json"
export PROXMOX_USERNAME="root@pam"
export PROXMOX_TOKEN="your-api-token-id"
export PROXMOX_TOKEN_SECRET="your-api-token-secret"
```

Or source the env file:
```bash
source vars/env
```

### 4. Build the Template

```bash
# Initialize Packer
packer init .

# Format configuration files
packer fmt .

# Validate configuration
packer validate --var-file vars/build.pkrvars.hcl .

# Build the template
packer build --var-file vars/build.pkrvars.hcl .
```

**Note**: The build process can take 30-60 minutes depending on your internet connection and Proxmox server performance.

## Usage

### Creating VMs from Template

Once the template is created, you can clone it in Proxmox:

```bash
# Using Proxmox CLI
qm clone 800 101 --name spark-dev-01
qm set 101 --memory 16384
qm set 101 --cores 8
```

Or use the Proxmox web UI to create linked clones for faster deployment.

### Verifying Installation

After cloning and starting a VM, verify the installations:

```bash
# Check Java
java -version

# Check Scala
scala -version

# Check Spark
spark-shell --version
spark-submit --version

# Check PySpark
python3 -c "import pyspark; print(pyspark.__version__)"

# Check Hadoop
hadoop version

# Start PySpark shell
pyspark

# Start Scala Spark shell
spark-shell
```

### Environment Variables

The following environment variables are pre-configured in `/etc/profile.d/`:

```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
SCALA_HOME=/opt/scala
SPARK_HOME=/opt/spark
HADOOP_HOME=/opt/hadoop
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
PYSPARK_PYTHON=python3
```

### Running Spark Jobs

#### PySpark Example

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("DataEngineering") \
    .getOrCreate()

# Your data engineering code here
df = spark.read.csv("data.csv", header=True, inferSchema=True)
df.show()
```

#### Scala Spark Example

```scala
import org.apache.spark.sql.SparkSession

val spark = SparkSession.builder()
  .appName("DataEngineering")
  .getOrCreate()

// Your data engineering code here
val df = spark.read.option("header", "true").csv("data.csv")
df.show()
```

### Jupyter Notebook

Launch Jupyter Lab for interactive development:

```bash
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

Access at `http://your-vm-ip:8888`

## Disk Partitioning

The preseed configuration uses a simple atomic partitioning scheme:
- Single `/` (root) partition
- Swap partition (automatically sized)
- ext4 filesystem

For production environments with large datasets, consider:
- Separate `/var` partition for logs
- Separate `/data` partition for Spark local directories
- NFS or distributed filesystem for shared data

## Customization

### Modifying Installed Packages

Edit `ubuntu-build.pkr.hcl` to add or remove provisioners. The build is organized into logical sections:

1. Base system packages
2. Java installation
3. Scala installation
4. Apache Spark installation
5. Python data engineering libraries
6. Docker installation
7. Hadoop client tools
8. Additional tools (dbt, Great Expectations, etc.)
9. Fish shell (optional)
10. Cleanup

### Changing Spark/Scala Versions

Update the download URLs in `ubuntu-build.pkr.hcl`:

```bash
# For Spark
wget https://archive.apache.org/dist/spark/spark-VERSION/spark-VERSION-bin-hadoop3.tgz

# For Scala
wget https://downloads.lightbend.com/scala/VERSION/scala-VERSION.tgz
```

Ensure compatibility between Spark and Scala versions.

### Adding Custom Scripts

Add additional provisioners to `ubuntu-build.pkr.hcl`:

```hcl
provisioner "file" {
  source      = "scripts/custom-setup.sh"
  destination = "/tmp/custom-setup.sh"
}

provisioner "shell" {
  inline = [
    "chmod +x /tmp/custom-setup.sh",
    "/tmp/custom-setup.sh"
  ]
}
```

## Cloud-Init Configuration

VMs cloned from this template can be configured using Cloud-Init:

```bash
# Set SSH keys
qm set 101 --sshkey ~/.ssh/id_rsa.pub

# Set IP address
qm set 101 --ipconfig0 ip=192.168.1.100/24,gw=192.168.1.1

# Set DNS
qm set 101 --nameserver 8.8.8.8

# Set user credentials
qm set 101 --ciuser ubuntu
qm set 101 --cipassword secure-password
```

See `http/cloud.cfg` for default Cloud-Init configuration.

## Troubleshooting

### Enable Packer Logging

```bash
export PACKER_LOG=1
packer build --var-file vars/build.pkrvars.hcl .
```

### Common Issues

**Build fails during package installation:**
- Check internet connectivity from Proxmox host
- Verify Ubuntu mirror is accessible
- Increase `ssh_timeout` in variables

**Out of disk space:**
- Increase `disk_size` in build.pkrvars.hcl (minimum 50G recommended)
- Check Proxmox storage pool has sufficient space

**Java/Spark not found after boot:**
- Check `/etc/profile.d/` scripts are present
- Source the profile: `source /etc/profile`
- Verify installations in `/opt/` directory

**PySpark import errors:**
- Ensure pip packages installed successfully
- Check Python version: `python3 --version`
- Reinstall: `pip3 install pyspark==3.5.0`

## SSH Access

The template is configured for root SSH access during build (password: `packer`). For production:

1. Use Cloud-Init to set SSH keys:
```bash
qm set <vmid> --sshkey ~/.ssh/id_rsa.pub
```

2. Disable root password login after first boot
3. Create non-root users with sudo privileges

## Performance Tuning

### Spark Configuration

For production workloads, tune Spark settings in `$SPARK_HOME/conf/spark-defaults.conf`:

```properties
spark.driver.memory              4g
spark.executor.memory            4g
spark.executor.cores             2
spark.local.dir                  /data/spark-temp
```

### Docker Configuration

Configure Docker to use appropriate storage driver for Proxmox:

```bash
# Edit /etc/docker/daemon.json
{
  "storage-driver": "overlay2"
}
```

## Development Tools

Included development tools for data engineering:

- **Poetry**: Modern Python dependency management
- **dbt**: Data transformation workflows
- **Great Expectations**: Data validation and documentation
- **Prefect**: Modern workflow orchestration
- **Apache Airflow**: Traditional workflow orchestration

## Useful Resources

- [Apache Spark Documentation](https://spark.apache.org/docs/latest/)
- [PySpark API Reference](https://spark.apache.org/docs/latest/api/python/)
- [Scala Documentation](https://docs.scala-lang.org/)
- [Packer Proxmox Builder](https://www.packer.io/plugins/builders/proxmox/iso)
- [Cloud-Init Documentation](https://cloudinit.readthedocs.io/)
- [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/)
- [Proxmox Cloud-Init FAQ](https://pve.proxmox.com/wiki/Cloud-Init_FAQ)

## License

This configuration is provided as-is for building Ubuntu-based Proxmox templates.

## Contributing

Improvements and suggestions are welcome. Please ensure:
- Packer configurations are validated before submitting
- Documentation is updated for any changes
- Version compatibility is maintained

## Version Information

- **Ubuntu**: 22.04 LTS (Jammy Jellyfish)
- **Apache Spark**: 3.5.0
- **Scala**: 2.12.18
- **Hadoop**: 3.3.6
- **Java**: OpenJDK 11
- **Python**: 3.10+ (Ubuntu default)
- **Packer**: 1.9.1+

Last updated: 2025-11-14
