# Fedora Data Engineering Golden Image for Proxmox

## Overview

Packer configuration for building a Fedora Linux 'golden image' Proxmox template optimized for data engineering workloads. Fedora provides cutting-edge packages with Red Hat innovation, making it ideal for data engineers who want the latest features with enterprise-grade quality and stability.

## Features

### Core Infrastructure
- **Fedora Server 40** (or latest) with 6-month release cycle
- **Cloud-init** for automated configuration when cloning
- **QEMU guest agent** for Proxmox integration
- **Docker** AND **Podman** for containerized workflows (Fedora excellence!)
- **SELinux** properly configured for data engineering tools
- Latest kernel and system packages with Red Hat quality assurance

### Data Engineering Stack

#### Apache Spark 3.5.0
- Pre-installed Apache Spark with Hadoop 3 bindings
- Configured environment variables (`SPARK_HOME`, `PATH`)
- Ready for both standalone and cluster modes
- SELinux contexts properly configured

#### Scala 2.13
- Latest Scala from Fedora repositories
- Compatible with Spark 3.5.0
- Installed via dnf for easy updates

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
- **MLflow** - ML lifecycle management
- **Poetry** - Python dependency management

#### Hadoop 3.3.6
- Hadoop client tools for HDFS interaction
- Configured environment variables (`HADOOP_HOME`, `HADOOP_CONF_DIR`)

#### Apache Kafka 3.6.0
- Kafka for real-time data streaming
- Producer and consumer APIs
- Kafka Connect support

#### Apache Flink 1.18.0
- Stream processing framework
- Real-time analytics and ETL
- Complex event processing
- Scala API support

#### Development Tools
- **Java OpenJDK 11** - Required for Spark
- **Git** - Version control
- **Vim, Nano** - Text editors
- **htop, tmux** - System monitoring and terminal multiplexing
- **Fish, Zsh** - Modern shells with auto-completion
- **Testing tools** - pytest, pytest-cov, black, flake8, mypy
- **Profiling tools** - memory-profiler, line-profiler, py-spy

#### Database Clients
- PostgreSQL development libraries
- MariaDB/MySQL client
- Redis Python client
- ClickHouse driver
- MongoDB PyMongo driver

#### Monitoring & Profiling
- sysstat - System performance monitoring
- iotop - I/O monitoring
- iftop - Network monitoring
- ncdu - Disk usage analyzer
- Python profiling tools

## System Requirements

### Recommended VM Specifications
- **CPU**: 4 cores (host CPU type for best performance)
- **Memory**: 8192 MB (8 GB) minimum, 16 GB recommended for production
- **Disk**: 50 GB minimum (stores Spark, Hadoop, Kafka, Flink, and Python libraries)
- **Storage Format**: Raw (best performance) or qcow2

### Proxmox Requirements
- Proxmox VE 7.x or later
- Packer 1.9.1 or later
- Sufficient storage for template and clones

## Quick Start

### 1. Download Fedora Server ISO

Download the latest Fedora Server ISO and upload to your Proxmox server:

```bash
# On Proxmox server
cd /var/lib/vz/template/iso

# Download Fedora Server 40 (or latest)
wget https://download.fedoraproject.org/pub/fedora/linux/releases/40/Server/x86_64/iso/Fedora-Server-dvd-x86_64-40-1.14.iso

# Get checksum
wget https://download.fedoraproject.org/pub/fedora/linux/releases/40/Server/x86_64/iso/Fedora-Server-40-1.14-x86_64-CHECKSUM
cat Fedora-Server-40-1.14-x86_64-CHECKSUM | grep DVD
```

### 2. Configure Build Variables

Create `vars/build.pkrvars.hcl` from the sample:

```bash
cp vars/build.pkrvars.hcl.sample vars/build.pkrvars.hcl
```

Edit `vars/build.pkrvars.hcl` with your Proxmox settings:

```hcl
proxmox_node = "pve"              # Your Proxmox node name
vm_id = 1000                       # Template VM ID
template_name = "fedora-dataeng"
template_name_suffix = "-40"

# Update ISO path and checksum
iso_file = "local:iso/Fedora-Server-dvd-x86_64-40-1.14.iso"
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
qm clone 1000 101 --name spark-dev-01
qm set 101 --memory 16384
qm set 101 --cores 8
```

Or use the Proxmox web UI to create linked clones for faster deployment.

### First Boot Configuration

After cloning and starting a VM:

```bash
# Update system (Fedora releases every 6 months)
sudo dnf update -y

# Source environment variables
source /etc/profile

# Verify installations
java -version
scala -version
spark-shell --version
python3 -c "import pyspark; print(pyspark.__version__)"
hadoop version
kafka-topics.sh --version
flink --version
```

### Environment Variables

The following environment variables are pre-configured in `/etc/profile.d/`:

```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk
SPARK_HOME=/opt/spark
HADOOP_HOME=/opt/hadoop
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
KAFKA_HOME=/opt/kafka
FLINK_HOME=/opt/flink
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

### Apache Flink Usage

Start Flink cluster:

```bash
# Start Flink
$FLINK_HOME/bin/start-cluster.sh

# Check Flink UI
# Access at http://your-vm-ip:8081

# Submit a Flink job
$FLINK_HOME/bin/flink run examples/streaming/WordCount.jar

# Stop Flink
$FLINK_HOME/bin/stop-cluster.sh
```

### Container Options: Docker vs Podman

Fedora includes both Docker and Podman:

```bash
# Using Docker (traditional)
sudo systemctl start docker
sudo docker run hello-world

# Using Podman (rootless, more secure)
podman run hello-world
podman-compose up

# Docker Compose
docker-compose up
```

## Fedora Specifics

### Release Model

Fedora releases every 6 months with:
- Latest software versions
- Cutting-edge features
- Red Hat quality assurance
- 13-month support lifecycle
- Clear upgrade path to RHEL/CentOS Stream

### Package Management

```bash
# Update system
sudo dnf update -y

# Install packages
sudo dnf install package-name

# Search for packages
dnf search search-term

# Remove packages
sudo dnf remove package-name

# Clean cache
sudo dnf clean all

# List installed packages
dnf list installed
```

### SELinux Configuration

Fedora uses SELinux in enforcing mode for security:

```bash
# Check SELinux status
sestatus

# View SELinux contexts
ls -Z /opt/spark

# SELinux is pre-configured for data engineering tools
# If you need to add custom policies:
sudo semanage fcontext -a -t bin_t '/path/to/binary(/.*)?'
sudo restorecon -Rv /path
```

### System Upgrades

Upgrade to next Fedora release:

```bash
# Update current system
sudo dnf upgrade --refresh

# Install system upgrade plugin
sudo dnf install dnf-plugin-system-upgrade

# Download next release
sudo dnf system-upgrade download --releasever=41

# Reboot and upgrade
sudo dnf system-upgrade reboot
```

## Disk Partitioning

The kickstart configuration creates:
- 1 GB `/boot` partition
- 2 GB Swap partition
- Remaining space for root (`/`) partition
- ext4 filesystem

For production with large datasets:
- Consider separate `/var` for logs
- Consider separate `/data` for Spark local directories
- Use NFS or distributed filesystem for shared data

## Customization

### Modifying Installed Packages

Edit `fedora-build.pkr.hcl` to add or remove provisioners. The build is organized into sections:

1. Base system and development tools
2. Python and pip
3. Java installation
4. Scala installation
5. Apache Spark installation
6. Python data engineering libraries
7. Docker and Podman
8. Hadoop client tools
9. Additional data engineering tools
10. Apache Kafka installation
11. Apache Flink installation
12. Shell installations (fish, zsh)
13. Additional database clients
14. Monitoring and profiling tools
15. Service enablement
16. SELinux configuration
17. Cleanup

### Changing Software Versions

Update download URLs in `fedora-build.pkr.hcl`:

```bash
# For Spark
wget https://archive.apache.org/dist/spark/spark-VERSION/spark-VERSION-bin-hadoop3.tgz

# For Hadoop
wget https://archive.apache.org/dist/hadoop/common/hadoop-VERSION/hadoop-VERSION.tar.gz

# For Kafka
wget https://archive.apache.org/dist/kafka/VERSION/kafka_2.12-VERSION.tgz

# For Flink
wget https://archive.apache.org/dist/flink/flink-VERSION/flink-VERSION-bin-scala_2.12.tgz
```

### Custom Kickstart Configuration

Modify `http/ks.cfg` to customize the Fedora installation:
- Partition scheme
- Package selection
- Network configuration
- Security settings

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
qm set 101 --ciuser fedora
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

**Kickstart installation fails:**
- Check internet connectivity from Proxmox host
- Verify Fedora mirror is accessible
- Check kickstart syntax: `ksvalidator http/ks.cfg`
- Increase `ssh_timeout` in variables

**Out of disk space:**
- Increase `disk_size` in build.pkrvars.hcl (minimum 50G recommended)
- Check Proxmox storage pool has sufficient space

**Package installation errors:**
- Update to latest Fedora ISO
- Check Fedora release is still supported
- Verify package names in kickstart and provisioners

**Java/Spark not found after boot:**
- Source the profile: `source /etc/profile`
- Check `/etc/profile.d/` scripts are present
- Verify installations in `/opt/` directory

**SELinux denials:**
- Check audit logs: `sudo ausearch -m avc -ts recent`
- Generate policy: `sudo audit2allow -a`
- SELinux contexts are pre-configured for common paths

**Python package conflicts:**
- Use virtual environments: `python3 -m venv myenv`
- Update pip: `pip3 install --upgrade pip`
- Consider using system packages when available

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
```

### Flink Configuration

Tune Flink in `$FLINK_HOME/conf/flink-conf.yaml`:

```yaml
taskmanager.numberOfTaskSlots: 4
parallelism.default: 4
taskmanager.memory.process.size: 4096m
jobmanager.memory.process.size: 2048m
```

### System Optimizations

Fedora-specific optimizations:

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
sudo dnf update -y

# Update Python packages
pip3 list --outdated
pip3 install --upgrade package-name

# Clean DNF cache
sudo dnf clean all
```

### Monitoring

```bash
# System monitoring
htop

# Disk I/O
iotop

# Network monitoring
iftop

# Disk usage
ncdu /

# Check services
systemctl status docker
systemctl status qemu-guest-agent
```

### Security Updates

```bash
# Check for security updates
sudo dnf check-update --security

# Apply security updates only
sudo dnf update --security

# Enable automatic security updates
sudo dnf install dnf-automatic
sudo systemctl enable --now dnf-automatic.timer
```

## Advantages of Fedora for Data Engineering

1. **Latest Packages**: Always get cutting-edge software versions
2. **Red Hat Quality**: Enterprise-grade testing and quality assurance
3. **SELinux**: Enhanced security out of the box
4. **Podman**: Native container runtime, rootless containers
5. **Innovation**: Latest features from Red Hat ecosystem
6. **Regular Releases**: Predictable 6-month release cycle
7. **Community**: Strong community with Red Hat backing
8. **Enterprise Path**: Clear migration path to RHEL
9. **Performance**: Optimized for modern hardware
10. **Documentation**: Excellent documentation and support

## Comparison: Ubuntu vs Arch vs Fedora

| Feature | Ubuntu | Arch | Fedora |
|---------|--------|------|--------|
| Release Model | LTS (22.04) | Rolling | 6-month cycle |
| Package Updates | Periodic | Continuous | Regular + Security |
| Enterprise Support | Canonical | Community | Red Hat |
| Spark | 3.5.0 ✓ | 3.5.0 ✓ | 3.5.0 ✓ |
| Scala | 2.12.18 | 2.12 | 2.13 ✓ |
| Kafka | ✗ | 3.6.0 ✓ | 3.6.0 ✓ |
| **Flink** | ✗ | ✗ | **1.18.0 ✓** |
| **Podman** | Manual | Manual | **Native ✓** |
| **SELinux** | AppArmor | Manual | **Native ✓** |
| **MLflow** | ✗ | ✗ | **✓** |
| **Dagster** | ✗ | ✗ | **✓** |
| Stability | High | Medium | **High** |
| Latest Features | Medium | High | **Very High** |
| Security | Good | Manual | **Excellent** |
| Best For | Stability | DIY | **Enterprise** |

## Useful Resources

- [Fedora Documentation](https://docs.fedoraproject.org/)
- [Apache Spark Documentation](https://spark.apache.org/docs/latest/)
- [PySpark API Reference](https://spark.apache.org/docs/latest/api/python/)
- [Scala Documentation](https://docs.scala-lang.org/)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Apache Flink Documentation](https://flink.apache.org/documentation.html)
- [Podman Documentation](https://docs.podman.io/)
- [Kickstart Documentation](https://docs.fedoraproject.org/en-US/fedora/latest/install-guide/appendixes/Kickstart_Syntax_Reference/)
- [Packer Proxmox Builder](https://www.packer.io/plugins/builders/proxmox/iso)
- [Cloud-Init Documentation](https://cloudinit.readthedocs.io/)
- [Proxmox Cloud-Init FAQ](https://pve.proxmox.com/wiki/Cloud-Init_FAQ)

## License

This configuration is provided as-is for building Fedora-based Proxmox templates.

## Contributing

Improvements and suggestions are welcome. Please ensure:
- Packer configurations are validated before submitting
- Documentation is updated for any changes
- Test on latest Fedora release
- Version compatibility is maintained
- SELinux policies are properly configured

## Version Information

- **Fedora**: 40 (or latest, 6-month releases)
- **Apache Spark**: 3.5.0
- **Scala**: 2.13 (latest from Fedora repos)
- **Hadoop**: 3.3.6
- **Kafka**: 3.6.0
- **Flink**: 1.18.0
- **Java**: OpenJDK 11
- **Python**: 3.12+ (latest from Fedora repos)
- **Packer**: 1.9.1+

Last updated: 2025-11-14
