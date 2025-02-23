# HCP Terraform VPC & Subnet Assignment

🌍 Step 1: Set Up Terraform Cloud Workspaces

Need two workspaces in Terraform Cloud:
    1.	master-vpc → To create the VPC
    2.	master-subnet → To create the Subnet

**🛠 Step 2: Create master-vpc workspace**

```jsx
mkdir master-vpc
cd master-vpc
```

Then, create  ***version.tf, main.tf, backend.tf, output.tf***  files inside **master-vpc** workspace:

```jsx
#for version.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}

provider "aws" {
  # Configuration options
}
```

```jsx
#for main.tf

resource "aws_vpc" "my_jp_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-jp-vpc"
  }
}
```

```jsx
#for backend.tf

terraform {
  cloud {

    organization = "hsan-hc-jp"

    workspaces {
      name = "master-vpc"
    }
  }
}

```

```jsx
#for output.tf

output "vpc_id" {
  value = aws_vpc.my_jp_vpc.id
}
```

**🚀 Step 3: the VPC Configuration**

```jsx
terraform login
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

✅ This will create an HCP VPC and store the vpc_id in Terraform Cloud state.

**🛠 Step 4: Create master-subnet Workspace**

- Now, create a second workspace for **master-subnet**:

```jsx
mkdir master-subnet
cd master-subnet
```

Inside **master-subnet/*version.tf, backend.tf, main.tf, output.tf***

```jsx
#for version.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}

provider "aws" {
  # Configuration options
}
```

```jsx
#for backend.tf

terraform {
  cloud {

    organization = "hsan-hc-jp"

    workspaces {
      name = "master-subnet"
    }
  }
}

```

use terraform_remote_state to fetch the VPC ID:

```jsx
#for main.tf

data "terraform_remote_state" "networking" {
  backend = "remote"

  config = {
    organization = "hsan-hc-jp"
    workspaces = {
      name = "master-vpc"
    }
  }
}

resource "aws_subnet" "my_jp_subnet" {
  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "my-jp-subnet"
  }
}
```

```jsx
#for output.tf
output "subnet_id" {
  value = aws_subnet.my_jp_subnet.id
}
```

**🚀 Step 5: Apply the Subnet Configuration**

```jsx
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

**🔍 Step 6: Verify the Setup**

Go to **Terraform Cloud** → **Workspaces**
<img width="1152" alt="Screenshot_2025-02-17_at_22 21 32" src="https://github.com/user-attachments/assets/81864227-deb4-448b-8156-a75cf6cbcdfd" />

(Check master-vpc workspace of Resources and Outputs)

![Screenshot 2025-02-17 at 22.44.43.png](HCP%20Terraform%20VPC%20&%20Subnet%20Assignment%2019d36aca720c809a929cdb6da9ec82a2/Screenshot_2025-02-17_at_22.44.43.png)

![Screenshot 2025-02-17 at 22.46.56.png](HCP%20Terraform%20VPC%20&%20Subnet%20Assignment%2019d36aca720c809a929cdb6da9ec82a2/Screenshot_2025-02-17_at_22.46.56.png)

(Check master-subnet workspace of Resources and Outputs)

![Screenshot 2025-02-17 at 22.48.28.png](HCP%20Terraform%20VPC%20&%20Subnet%20Assignment%2019d36aca720c809a929cdb6da9ec82a2/Screenshot_2025-02-17_at_22.48.28.png)

![Screenshot 2025-02-17 at 22.48.53.png](HCP%20Terraform%20VPC%20&%20Subnet%20Assignment%2019d36aca720c809a929cdb6da9ec82a2/Screenshot_2025-02-17_at_22.48.53.png)

**🎯 Final Result: Check the AWS Console VPC**

![Screenshot 2025-02-17 at 22.56.51.png](HCP%20Terraform%20VPC%20&%20Subnet%20Assignment%2019d36aca720c809a929cdb6da9ec82a2/Screenshot_2025-02-17_at_22.56.51.png)

![Screenshot 2025-02-17 at 23.04.07.png](HCP%20Terraform%20VPC%20&%20Subnet%20Assignment%2019d36aca720c809a929cdb6da9ec82a2/Screenshot_2025-02-17_at_23.04.07.png)
