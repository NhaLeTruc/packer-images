# Debian Data Engineering Golden Image for Proxmox

## Overview

Packer configuration for building a Debian 12 (Bookworm) 'golden image' Proxmox template optimized for data engineering workloads. Debian provides rock-solid stability and production-grade reliability, making it the ideal choice for mission-critical data engineering infrastructure.

## Features

### Core Infrastructure
- **Debian 12 (Bookworm)** stable release
- **Cloud-init** for automated configuration when cloning
- **QEMU guest agent** for Proxmox integration
- **Docker** with Docker Compose for containerized workflows
- Long-term stability with security updates
- Production-proven reliability

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
- **Dagster** - Modern data orchestrator
- **Poetry** - Python dependency management

#### Hadoop 3.3.6
- Hadoop client tools for HDFS interaction
- Configured environment variables (`HADOOP_HOME`, `HADOOP_CONF_DIR`)

#### Apache Kafka 3.6.0
- Kafka for real-time data streaming
- Producer and consumer APIs
- Kafka Connect support

#### Development Tools
- **Java OpenJDK 17** - Debian 12 default (LTS)
- **Git** - Version control
- **Vim, Nano** - Text editors
- **htop, tmux** - System monitoring and terminal multiplexing
- **Fish shell** - Modern shell with auto-completion
- **Testing tools** - pytest, black, flake8, mypy

#### Database Clients
- PostgreSQL client libraries
- MariaDB/MySQL client
- Redis Python client
- ClickHouse driver
- MongoDB PyMongo driver
- Elasticsearch Python client

#### Data Quality Tools
- Pandera - DataFrame validation
- Pydantic - Data validation
- Great Expectations - Data quality framework

#### Storage Tools
- **MinIO Client (mc)** - S3-compatible storage management
- Integration with object storage systems

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

### 1. Download Debian ISO

Download Debian 12 (Bookworm) netinst ISO and upload to your Proxmox server:

```bash
# On Proxmox server
cd /var/lib/vz/template/iso

# Download Debian 12 netinst
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso

# Get checksum
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS
cat SHA256SUMS | grep netinst
```

### 2. Configure Build Variables

Create `vars/build.pkrvars.hcl` from the sample:

```bash
cp vars/build.pkrvars.hcl.sample vars/build.pkrvars.hcl
```

Edit `vars/build.pkrvars.hcl` with your Proxmox settings:

```hcl
proxmox_node = "pve"              # Your Proxmox node name
vm_id = 700                        # Template VM ID
template_name = "debian-dataeng"
template_name_suffix = "-12"

# Update ISO path and checksum
iso_file = "local:iso/debian-12.5.0-amd64-netinst.iso"
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

**Note**: The build process can take 40-90 minutes depending on your internet connection and Proxmox server performance.

## Usage

### Creating VMs from Template

Once the template is created, you can clone it in Proxmox:

```bash
# Using Proxmox CLI
qm clone 700 101 --name spark-prod-01
qm set 101 --memory 16384
qm set 101 --cores 8
```

Or use the Proxmox web UI to create linked clones for faster deployment.

### First Boot Configuration

After cloning and starting a VM:

```bash
# Update system (Debian stable)
sudo apt update && sudo apt upgrade -y

# Source environment variables
source /etc/profile

# Verify installations
java -version
scala -version
spark-shell --version
python3 -c "import pyspark; print(pyspark.__version__)"
hadoop version
kafka-topics.sh --version
```

### Environment Variables

The following environment variables are pre-configured in `/etc/profile.d/`:

```bash
JAVA_HOME=/usr/lib/jvm/default-java
SCALA_HOME=/opt/scala
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
kafka-topics.sh --create --topic data-pipeline --bootstrap-server localhost:9092

# List topics
kafka-topics.sh --list --bootstrap-server localhost:9092
```

### MinIO Client Usage

Work with S3-compatible storage:

```bash
# Configure MinIO client
mc alias set myminio https://minio.example.com ACCESS_KEY SECRET_KEY

# List buckets
mc ls myminio

# Copy data
mc cp data.csv myminio/mybucket/
```

## Debian Specifics

### Stability and Release Model

Debian Stable (Bookworm) provides:
- **Long-term stability** - ~2 year release cycle
- **Security updates** - Regular security patches
- **Production reliability** - Thoroughly tested packages
- **Conservative approach** - Proven, stable software versions
- **Enterprise support** - Wide adoption in production environments

### Package Management

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install packages
sudo apt install package-name

# Search for packages
apt search search-term

# Remove packages
sudo apt remove package-name

# Clean cache
sudo apt clean
sudo apt autoclean
```

### System Upgrades

Debian stable releases every ~2 years:

```bash
# Check current version
cat /etc/debian_version
lsb_release -a

# When new stable release is available
sudo apt update
sudo apt upgrade
sudo apt full-upgrade

# Edit sources.list for new release (when upgrading)
sudo nano /etc/apt/sources.list
# Change 'bookworm' to new release name

sudo apt update
sudo apt full-upgrade
```

## Disk Partitioning

The preseed configuration creates:
- Single `/` (root) partition using all available space
- ext4 filesystem
- Automatic partition sizing

For production with large datasets:
- Consider separate `/var` for logs
- Consider separate `/data` for Spark local directories
- Use NFS or distributed filesystem for shared data
- Consider LVM for flexible storage management

## Customization

### Modifying Installed Packages

Edit `debian-build.pkr.hcl` to add or remove provisioners. The build is organized into sections:

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
11. MinIO client
12. Database clients
13. Data quality tools
14. Spark monitoring tools
15. Fish shell
16. Service enablement
17. Cleanup

### Changing Software Versions

Update download URLs in `debian-build.pkr.hcl`:

```bash
# For Spark
wget https://archive.apache.org/dist/spark/spark-VERSION/spark-VERSION-bin-hadoop3.tgz

# For Scala
wget https://downloads.lightbend.com/scala/VERSION/scala-VERSION.tgz

# For Hadoop
wget https://archive.apache.org/dist/hadoop/common/hadoop-VERSION/hadoop-VERSION.tar.gz

# For Kafka
wget https://archive.apache.org/dist/kafka/VERSION/kafka_2.12-VERSION.tgz
```

### Custom Preseed Configuration

Modify `http/preseed.cfg` to customize the Debian installation:
- Partition scheme
- Package selection
- Network configuration
- Localization settings

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
qm set 101 --ciuser debian
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

**Preseed installation fails:**
- Check internet connectivity from Proxmox host
- Verify Debian mirror is accessible
- Increase `ssh_timeout` in variables
- Check preseed.cfg syntax

**Out of disk space:**
- Increase `disk_size` in build.pkrvars.hcl (minimum 50G recommended)
- Check Proxmox storage pool has sufficient space

**Package installation errors:**
- Verify Debian release is current
- Check mirror availability
- Update package names if changed

**Java/Spark not found after boot:**
- Source the profile: `source /etc/profile`
- Check `/etc/profile.d/` scripts are present
- Verify installations in `/opt/` directory

**Python package conflicts:**
- Use virtual environments: `python3 -m venv myenv`
- Update pip: `pip3 install --upgrade pip`
- Use --break-system-packages flag for system-wide installs

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
spark.sql.adaptive.enabled       true
spark.sql.adaptive.coalescePartitions.enabled true
```

### Kafka Configuration

Optimize Kafka in `$KAFKA_HOME/config/server.properties`:

```properties
num.network.threads=8
num.io.threads=16
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
log.retention.hours=168
num.partitions=3
compression.type=lz4
```

### System Optimizations

Debian-specific optimizations:

```bash
# Tune kernel parameters
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.d/99-sysctl.conf
echo 'net.core.rmem_max=134217728' | sudo tee -a /etc/sysctl.d/99-sysctl.conf
echo 'net.core.wmem_max=134217728' | sudo tee -a /etc/sysctl.d/99-sysctl.conf
sudo sysctl -p /etc/sysctl.d/99-sysctl.conf

# Disable unnecessary services
sudo systemctl disable bluetooth
sudo systemctl disable cups
```

## Maintenance

### Regular Updates

```bash
# Full system update
sudo apt update && sudo apt upgrade -y

# Update Python packages
pip3 list --outdated
pip3 install --upgrade package-name --break-system-packages

# Clean package cache
sudo apt clean
sudo apt autoclean
```

### Monitoring

```bash
# System monitoring
htop

# Disk usage
df -h
du -sh /opt/*

# Check services
systemctl status docker
systemctl status qemu-guest-agent
```

### Security Updates

```bash
# Check for security updates
sudo apt list --upgradable

# Apply security updates
sudo apt update
sudo apt upgrade

# Unattended upgrades (optional)
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

## Advantages of Debian for Data Engineering

1. **Rock-Solid Stability** - Proven reliability for production workloads
2. **Long-term Support** - Stable releases with extended security updates
3. **Universal Base System** - Wide compatibility and support
4. **Production Proven** - Used by major companies worldwide
5. **Conservative Updates** - Thoroughly tested packages
6. **Security Focus** - Regular security patches and updates
7. **Community Support** - Large, active community
8. **Enterprise Adoption** - Trusted in production environments
9. **Package Quality** - Extensive testing before release
10. **Predictable Releases** - Stable 2-year release cycle

## Comparison: Debian vs Other Distributions

| Feature | **Debian** | Ubuntu LTS | Fedora | Arch |
|---------|------------|------------|--------|------|
| Stability | **Excellent** | Very Good | Good | Variable |
| Release Cycle | **~2 years** | 2 years | 6 months | Rolling |
| Package Testing | **Extensive** | Good | Moderate | Minimal |
| Production Use | **Widespread** | Widespread | Growing | Limited |
| Security Updates | **Long-term** | 5 years | 13 months | Rolling |
| Enterprise Support | **Strong** | Canonical | Red Hat | Community |
| Package Age | Conservative | **Moderate** | Latest | Latest |
| Predictability | **Highest** | High | Medium | Low |
| Best For | **Production** | General Use | Innovation | DIY |

## Use Cases

### Production Data Pipelines
- Mission-critical ETL workflows
- 24/7 streaming data processing
- Enterprise data warehousing
- Production Spark clusters

### Batch Processing
- Large-scale data transformation
- Daily/weekly data processing jobs
- Data lake operations
- Analytics workloads

### Real-time Streaming
- Kafka-based event streaming
- Real-time analytics
- IoT data processing
- Log aggregation

### Data Science
- ML model training
- Feature engineering
- Exploratory data analysis
- Collaborative data science

## Useful Resources

- [Debian Documentation](https://www.debian.org/doc/)
- [Debian Administrator's Handbook](https://debian-handbook.info/)
- [Apache Spark Documentation](https://spark.apache.org/docs/latest/)
- [PySpark API Reference](https://spark.apache.org/docs/latest/api/python/)
- [Scala Documentation](https://docs.scala-lang.org/)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Packer Proxmox Builder](https://www.packer.io/plugins/builders/proxmox/iso)
- [Cloud-Init Documentation](https://cloudinit.readthedocs.io/)
- [Proxmox Cloud-Init FAQ](https://pve.proxmox.com/wiki/Cloud-Init_FAQ)

## License

This configuration is provided as-is for building Debian-based Proxmox templates.

## Contributing

Improvements and suggestions are welcome. Please ensure:
- Packer configurations are validated before submitting
- Documentation is updated for any changes
- Compatibility with Debian stable is maintained
- Production reliability is prioritized

## Version Information

- **Debian**: 12 (Bookworm) stable
- **Apache Spark**: 3.5.0
- **Scala**: 2.12.18
- **Hadoop**: 3.3.6
- **Kafka**: 3.6.0
- **Java**: OpenJDK 17 (Debian default LTS)
- **Python**: 3.11 (Debian default)
- **Packer**: 1.9.1+

Last updated: 2025-11-14

---

**Debian: The Universal Operating System - Rock-solid stability for production data engineering.**
