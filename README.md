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

## 🌍 Access Jenkins

```id="aib3po"
http://<PUBLIC_IP>:8080
```

---

## 💡 Best Practices Applied

* ✔️ Fully modular Terraform architecture
* ✔️ Separation of concerns
* ✔️ Use of `variables.tf` per module
* ✔️ Reusable and scalable design
* ✔️ `user_data` instead of provisioners
* ✔️ Automated infrastructure provisioning

---

## ⚠️ Notes

* SSH private key is stored in Terraform state (acceptable for lab environments)
* Docker group change may require session refresh in real-world usage



## 👨‍💻 Author

Ulrich kouatang 
IoT cloud engineer|industrial Devops engineer

---

