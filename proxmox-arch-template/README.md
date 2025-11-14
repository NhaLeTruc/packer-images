# Arch Linux Data Engineering Golden Image for Proxmox

## Overview

Packer configuration for building an Arch Linux 'golden image' Proxmox template optimized for data engineering workloads. Arch Linux provides a rolling-release model with cutting-edge packages, making it ideal for data engineers who want the latest tools and performance optimizations.

## Features

### Core Infrastructure
- **Arch Linux** rolling release base image
- **Cloud-init** for automated configuration when cloning
- **QEMU guest agent** for Proxmox integration
- **Docker** with Docker Compose for containerized workflows
- Latest kernel and system packages
- Pacman package manager with AUR access capability

### Data Engineering Stack

#### Apache Spark 3.5.0
- Pre-installed Apache Spark with Hadoop 3 bindings
- Configured environment variables (`SPARK_HOME`, `PATH`)
- Ready for both standalone and cluster modes

#### Scala 2.12
- Latest Scala from official Arch repositories
- Compatible with Spark 3.5.0
- Installed via pacman for easy updates

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

#### Apache Kafka 3.6.0
- Kafka for real-time data streaming
- Producer and consumer APIs
- Kafka Connect support

#### Development Tools
- **Java OpenJDK 11** - Required for Spark
- **Git** - Version control
- **Vim, Nano** - Text editors
- **htop, tmux** - System monitoring and terminal multiplexing
- **Fish shell** - Modern shell with auto-completion
- **Testing tools** - pytest, pytest-cov, black, flake8, mypy

#### Database Clients
- PostgreSQL client libraries
- MariaDB/MySQL client
- Redis Python client
- ClickHouse driver
- MongoDB PyMongo driver

## System Requirements

### Recommended VM Specifications
- **CPU**: 4 cores (host CPU type for best performance)
- **Memory**: 8192 MB (8 GB) minimum, 16 GB recommended for production
- **Disk**: 50 GB minimum (stores Spark, Hadoop, Kafka, and Python libraries)
- **Storage Format**: Raw (best performance) or qcow2

### Proxmox Requirements
- Proxmox VE 7.x or later
- Packer 1.9.1 or later
- Sufficient storage for template and clones

## Quick Start

### 1. Download Arch Linux ISO

Download the latest Arch Linux ISO and upload to your Proxmox server:

```bash
# On Proxmox server
cd /var/lib/vz/template/iso
wget https://mirror.rackspace.com/archlinux/iso/latest/archlinux-x86_64.iso

# Get checksum
wget https://mirror.rackspace.com/archlinux/iso/latest/sha256sums.txt
cat sha256sums.txt | grep archlinux-x86_64.iso
```

### 2. Configure Build Variables

Create `vars/build.pkrvars.hcl` from the sample:

```bash
cp vars/build.pkrvars.hcl.sample vars/build.pkrvars.hcl
```

Edit `vars/build.pkrvars.hcl` with your Proxmox settings:

```hcl
proxmox_node = "pve"              # Your Proxmox node name
vm_id = 900                        # Template VM ID
template_name = "arch-dataeng"
template_name_suffix = "-rolling"

# Update ISO path and checksum
iso_file = "local:iso/archlinux-2024.11.01-x86_64.iso"
iso_checksum = "sha256:your-actual-checksum"

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

**Note**: The build process can take 40-90 minutes depending on your internet connection and Proxmox server performance. Arch Linux requires a full system installation and compilation of some packages.

## Usage

### Creating VMs from Template

Once the template is created, you can clone it in Proxmox:

```bash
# Using Proxmox CLI
qm clone 900 101 --name spark-dev-01
qm set 101 --memory 16384
qm set 101 --cores 8
```

Or use the Proxmox web UI to create linked clones for faster deployment.

### First Boot Configuration

After cloning and starting a VM:

```bash
# Update system (Arch is rolling release)
sudo pacman -Syu

# Source environment variables
source /etc/profile

# Verify installations
java -version
scala -version
spark-shell --version
python -c "import pyspark; print(pyspark.__version__)"
hadoop version
kafka-topics.sh --version
```

### Environment Variables

The following environment variables are pre-configured in `/etc/profile.d/`:

```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk
SPARK_HOME=/opt/spark
HADOOP_HOME=/opt/hadoop
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
KAFKA_HOME=/opt/kafka
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

### Apache Kafka Usage

Start Zookeeper and Kafka:

```bash
# Start Zookeeper
$KAFKA_HOME/bin/zookeeper-server-start.sh -daemon $KAFKA_HOME/config/zookeeper.properties

# Start Kafka
$KAFKA_HOME/bin/kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties

# Create a topic
kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092

# List topics
kafka-topics.sh --list --bootstrap-server localhost:9092
```

## Arch Linux Specifics

### Rolling Release Model

Arch Linux uses a rolling release model, which means:
- Always get the latest software versions
- No need for distribution upgrades
- Regular updates with `pacman -Syu`
- Bleeding-edge packages and kernel

### Package Management

```bash
# Update system
sudo pacman -Syu

# Install packages
sudo pacman -S package-name

# Search for packages
pacman -Ss search-term

# Remove packages
sudo pacman -R package-name

# Clean package cache
sudo pacman -Scc
```

### AUR (Arch User Repository)

For packages not in official repositories, use an AUR helper like `yay`:

```bash
# Install yay (AUR helper)
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install AUR packages
yay -S package-name
```

## Disk Partitioning

The installation script creates:
- 512 MB EFI partition (`/boot`)
- 2 GB Swap partition
- Remaining space for root (`/`) partition
- ext4 filesystem

For production with large datasets:
- Consider separate `/var` for logs
- Consider separate `/data` for Spark local directories
- Use NFS or distributed filesystem for shared data

## Customization

### Modifying Installed Packages

Edit `arch-build.pkr.hcl` to add or remove provisioners. The build is organized into sections:

1. Base system and development tools
2. Python and pip
3. Java installation
4. Scala installation
5. Apache Spark installation
6. Python data engineering libraries
7. Docker installation
8. Hadoop client tools
9. Additional data engineering tools
10. Apache Kafka installation
11. Fish shell
12. Additional database clients
13. Service enablement
14. Cleanup

### Changing Software Versions

Update download URLs in `arch-build.pkr.hcl`:

```bash
# For Spark
wget https://archive.apache.org/dist/spark/spark-VERSION/spark-VERSION-bin-hadoop3.tgz

# For Hadoop
wget https://archive.apache.org/dist/hadoop/common/hadoop-VERSION/hadoop-VERSION.tar.gz

# For Kafka
wget https://archive.apache.org/dist/kafka/VERSION/kafka_2.12-VERSION.tgz
```

### Custom Installation Script

Modify `http/install.sh` to customize the Arch Linux installation process:
- Partition scheme
- Filesystem types
- Base packages
- Bootloader configuration

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
qm set 101 --ciuser arch
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

**Installation script fails:**
- Check internet connectivity from Proxmox host
- Verify Arch mirror is accessible
- Increase `ssh_timeout` in variables (Arch installation takes longer)

**Out of disk space:**
- Increase `disk_size` in build.pkrvars.hcl (minimum 50G recommended)
- Check Proxmox storage pool has sufficient space

**Package installation errors:**
- Update Arch ISO to latest version
- Check pacman mirrors in installation script
- Verify package names haven't changed

**Java/Spark not found after boot:**
- Source the profile: `source /etc/profile`
- Check `/etc/profile.d/` scripts are present
- Verify installations in `/opt/` directory

**Python package conflicts:**
- Use virtual environments: `python -m venv myenv`
- Update pip: `pip install --upgrade pip`
- Check package dependencies

## Performance Tuning

### Spark Configuration

For production workloads, tune Spark settings in `$SPARK_HOME/conf/spark-defaults.conf`:

```properties
spark.driver.memory              4g
spark.executor.memory            4g
spark.executor.cores             2
spark.local.dir                  /data/spark-temp
spark.eventLog.enabled           true
spark.eventLog.dir               /var/log/spark/events
```

### Kafka Configuration

Optimize Kafka for your workload in `$KAFKA_HOME/config/server.properties`:

```properties
num.network.threads=8
num.io.threads=16
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
log.retention.hours=168
```

### System Optimizations

Arch Linux specific optimizations:

```bash
# Enable performance CPU governor
sudo pacman -S cpupower
sudo cpupower frequency-set -g performance

# Tune kernel parameters
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.d/99-sysctl.conf
echo 'net.core.rmem_max=134217728' | sudo tee -a /etc/sysctl.d/99-sysctl.conf
sudo sysctl -p /etc/sysctl.d/99-sysctl.conf
```

## Maintenance

### Regular Updates

```bash
# Full system update
sudo pacman -Syu

# Update Python packages
pip list --outdated
pip install --upgrade package-name

# Clean package cache
sudo pacman -Scc
```

### Monitoring

```bash
# System monitoring
htop

# Disk usage
df -h

# Check services
systemctl status docker
systemctl status qemu-guest-agent
```

## Advantages of Arch Linux for Data Engineering

1. **Rolling Release**: Always get latest versions of tools
2. **Performance**: Optimized packages, minimal bloat
3. **Flexibility**: Complete control over system configuration
4. **AUR**: Access to thousands of additional packages
5. **Documentation**: Excellent Arch Wiki
6. **Package Manager**: Fast and efficient pacman
7. **Customization**: Build exactly what you need
8. **Community**: Active and helpful community

## Useful Resources

- [Arch Linux Documentation](https://wiki.archlinux.org/)
- [Apache Spark Documentation](https://spark.apache.org/docs/latest/)
- [PySpark API Reference](https://spark.apache.org/docs/latest/api/python/)
- [Scala Documentation](https://docs.scala-lang.org/)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Packer Proxmox Builder](https://www.packer.io/plugins/builders/proxmox/iso)
- [Cloud-Init Documentation](https://cloudinit.readthedocs.io/)
- [Proxmox Cloud-Init FAQ](https://pve.proxmox.com/wiki/Cloud-Init_FAQ)

## License

This configuration is provided as-is for building Arch Linux-based Proxmox templates.

## Contributing

Improvements and suggestions are welcome. Please ensure:
- Packer configurations are validated before submitting
- Documentation is updated for any changes
- Test on latest Arch Linux ISO
- Version compatibility is maintained

## Version Information

- **Arch Linux**: Rolling release (always latest)
- **Apache Spark**: 3.5.0
- **Scala**: 2.12 (latest from Arch repos)
- **Hadoop**: 3.3.6
- **Kafka**: 3.6.0
- **Java**: OpenJDK 11
- **Python**: 3.11+ (latest from Arch repos)
- **Packer**: 1.9.1+

Last updated: 2025-11-14
