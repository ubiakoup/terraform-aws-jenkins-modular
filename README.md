# 🚀 Terraform AWS Jenkins Deployment (Modular & Automated)

## 📌 Overview

This project provisions a complete AWS infrastructure using **Terraform** with a **fully modular architecture**, and deploys **Jenkins in a containerized environment using Docker Compose**.

The deployment is automated using a `user_data` script executed at EC2 instance startup.

---

## 🧱 Architecture

The infrastructure includes:

* EC2 instance (Ubuntu 22.04 - Jammy)
* Security Group (ports 80, 443, 8080)
* Elastic IP (static public IP)
* EBS volume attached to EC2
* Dynamically generated SSH Key Pair
* Automated Jenkins deployment via Docker

---

## 📁 Project Structure

```id="qqk1er"
.
├── modules/
│   ├── ec2module/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── user_data.sh
│   │   └── user_data.sh
│   ├── keypairmodule/
│   │   ├── main.tf
│   │   └── variables.tf
│   │
│   ├── sgmodule/
│   │   ├── main.tf
│   │   └── variables.tf
│   │
│   ├── eipmodule/
│   │   ├── main.tf
│   │   └── variables.tf
│   │
│   └── ebsmodule/
│       ├── main.tf
│       └── variables.tf
│
├── app/
│   ├── main.tf
│   ├── variables.tf
│
└── jenkins_ec2.txt
```

---

## 🧩 Modular Design

Each module follows Terraform best practices:

* `main.tf` → resource definitions
* `variables.tf` → input variables

👉 This ensures:

* Reusability
* Maintainability
* Clear separation of concerns

---

## ⚙️ EC2 Module (Core Component)

The EC2 module:

* Retrieves the latest Ubuntu 22.04 AMI
* Creates an EC2 instance
* Injects a startup script via `user_data`
* Attaches security group and SSH key

```hcl id="4q6yim"
resource "aws_instance" "myec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.security_group_id]

  user_data                   = file("${path.module}/user_data.sh")
  user_data_replace_on_change = true

  tags = var.aws_common_tag

  root_block_device {
    delete_on_termination = true
  }
}
```

---

## 🐳 Automated Installation (user_data)

The script `user_data.sh` is executed automatically when the instance starts.

### 📄 user_data.sh

```bash id="ph8dt9"
#!/bin/bash
apt update -y

curl -fsSL https://get.docker.com -o install-docker.sh
sh install-docker.sh --dry-run
sh install-docker.sh

usermod -aG docker ubuntu

git clone https://github.com/eazytrainingfr/jenkins-training.git
cd jenkins-training
docker compose up -d
```

### 🔥 Responsibilities

* Install Docker
* Configure user permissions
* Deploy Jenkins via Docker Compose

---

## 📦 Application Layer (`app/`)

The `app/` directory acts as the **entry point**:

* Calls all modules
* Passes variables
* Centralizes configuration via `variables.tf`

---

## 🔧 Variables Management

Each module defines its own `variables.tf`, ensuring:

* Loose coupling between modules
* High configurability
* Clean and reusable code

The `app/variables.tf` file is used to:

* Override defaults
* Customize deployment dynamically

---

## 📄 Output File

After deployment:

```id="3g7n9d"
jenkins_ec2.txt
```

Contains:

```id="8jct2h"
<PUBLIC_IP> <PUBLIC_DNS>
```

---

## 🚀 Deployment

```bash id="zz9pnn"
cd app
terraform init
terraform apply
```

---
---

## 🚫 Sensitive Files Protection

To prevent accidental exposure, the following files and directories are excluded using `.gitignore`:

```id="gitignore"
*.tfstate
*.tfstate.backup
.terraform/
.terraform.lock.hcl
```

---

## 🌍 Access Jenkins

```id="aib3po"
http://<PUBLIC_IP>:8080
```

---

## ⚠️ Production Recommendation

For production environments:

* Generate SSH keys **outside Terraform**
* Store secrets in secure services (e.g., AWS Secrets Manager)
* Enable encryption for remote state storage

---
## 🔐 Security Considerations

The SSH private key is stored in the Terraform state file.
This is acceptable for learning or lab environments, but **must be handled carefully**.

⚠️ **Important:**
The Terraform state file (`.tfstate`) may contain sensitive data such as:

* Private SSH keys
* Infrastructure details
* Credentials or secrets (depending on configuration)

👉 Therefore, it should **NEVER be exposed publicly** (e.g., committed to GitHub).

## 🛡️ Best Practices

* Never commit `.tfstate` files to a public repository
* Use a **remote backend** (e.g., S3 with encryption + DynamoDB locking)
* Restrict access to Terraform state files
* Avoid storing sensitive data in Terraform when possible

## ☁️ Remote Backend Best Practices

For better security and collaboration, Terraform state files should be stored in a **remote backend**, such as an AWS S3 bucket.

### 🔐 Why use a remote backend?

Storing the `.tfstate` file locally is not recommended in production because:

* It may expose sensitive information
* It is not shared across team members
* It can lead to inconsistent infrastructure states

---

### 🚀 Advantages of Using S3 Backend

Using an S3 remote backend provides:

* 🔒 **Secure storage** (with encryption enabled)
* 👥 **Team collaboration** (shared state)
* 🔄 **State consistency** across environments
* 🛑 **Prevention of duplicate resource deployment**
* 📜 **State versioning** (track changes over time)

---

## ⚠️ Preventing Infrastructure Issues

In team environments, using a remote backend helps to:

* Avoid **duplicate deployments** of the same resources
* Prevent **state conflicts** between team members
* Ensure that everyone works with the **same infrastructure state**

---

## 🔄 State Locking (Recommended)

To avoid concurrent modifications, it is recommended to use:

* **AWS S3** → for storing the state
* **AWS DynamoDB** → for state locking

This prevents multiple users from applying changes at the same time.

---

## 🛡️ Production Recommendations

For production environments:

* Use **S3 backend with encryption enabled**
* Enable **bucket versioning** to track state changes
* Use **DynamoDB for state locking**
* Restrict access using IAM policies

---

## 💡 Example (S3 Backend Configuration)

```hcl id="s3backend"
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "jenkins-project/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
```

---


## 👨‍💻 Author

Ulrich kouatang

IoT cloud engineer|industrial Devops engineer

---

