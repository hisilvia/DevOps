resource "aws_instance" "backend_app" {
  ami = "ami-03fd334507439f4d1"
  instance_type = "t2.medium"
  subnet_id = module.my-vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  associate_public_ip_address = true
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  git clone https://github.com/neerajbalodi/spring-backend.git
  sudo apt install openjdk-17-jdk -y
  sudo apt install maven -y

  sudo apt-get install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ubuntu

  # only download kubectl - the worker node setups will be done manually

  # Download kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  chmod +x kubectl
  mkdir -p ~/.local/bin
  mv ./kubectl ~/.local/bin/kubectl
  # Append ~/.local/bin to $PATH
  export PATH=$PATH:~/.local/bin
  kubectl version --client

  # Disable swap
  sudo swapoff -a

  # Create the .conf file to load the modules at bootup
  cat <<EOM_1 | sudo tee /etc/modules-load.d/k8s.conf
  overlay
  br_netfilter
  EOM_1

  sudo modprobe overlay
  sudo modprobe br_netfilter

  # Apply sysctl params required by Kubernetes setup
  cat <<EOM_2 | sudo tee /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-iptables  = 1
  net.bridge.bridge-nf-call-ip6tables = 1
  net.ipv4.ip_forward                 = 1
  EOM_2

  # Apply sysctl parameters without reboot
  sudo sysctl --system

  # Install CRIO Runtime
  sudo apt-get update -y
  sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates gpg

  sudo curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list

  sudo apt-get update -y
  sudo apt-get install -y cri-o

  sudo systemctl daemon-reload
  sudo systemctl enable crio --now
  sudo systemctl start crio.service

  echo "CRI runtime installed successfully"

  # Add Kubernetes APT repository and install required packages
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

  sudo apt-get update -y
  sudo apt-get install -y kubelet="1.29.0-*" kubectl="1.29.0-*" kubeadm="1.29.0-*"
  sudo apt-get update -y
  sudo apt-get install -y jq

  sudo systemctl enable --now kubelet
  sudo systemctl start kubelet

  EOF

  tags = {
    Name = "Backend_App"
  }
}

resource "aws_instance" "mysql_server" {
  ami = "ami-03fd334507439f4d1"
  instance_type = "t2.micro"
  subnet_id = module.my-vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  associate_public_ip_address = true
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install mysql-server -y

  EOF

  tags = {
    Name = "sql_server"
  }
}

resource "aws_instance" "frontend_app" {
  ami = "ami-03fd334507439f4d1"
  instance_type = "t2.medium"
  subnet_id = module.my-vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  associate_public_ip_address = true
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update
  git clone https://github.com/neerajbalodi/angular-frontend.git
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
  sudo npm install -g @angular/cli@19.0.2
  sudo npm install -g npm@10.9.2
  
  # setup the angular project
  cd angular-frontend 
  npm install

  # download the docker
  sudo apt-get install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ubuntu

  # only download kubectl - the worker node setups will be done manually
  
  # Download kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  chmod +x kubectl
  mkdir -p ~/.local/bin
  mv ./kubectl ~/.local/bin/kubectl
  # Append ~/.local/bin to $PATH
  export PATH=$PATH:~/.local/bin
  kubectl version --client

  # Disable swap
  sudo swapoff -a

  # Create the .conf file to load the modules at bootup
  cat <<EOM_1 | sudo tee /etc/modules-load.d/k8s.conf
  overlay
  br_netfilter
  EOM_1

  sudo modprobe overlay
  sudo modprobe br_netfilter

  # Apply sysctl params required by Kubernetes setup
  cat <<EOM_2 | sudo tee /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-iptables  = 1
  net.bridge.bridge-nf-call-ip6tables = 1
  net.ipv4.ip_forward                 = 1
  EOM_2

  # Apply sysctl parameters without reboot
  sudo sysctl --system

  # Install CRIO Runtime
  sudo apt-get update -y
  sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates gpg

  sudo curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list

  sudo apt-get update -y
  sudo apt-get install -y cri-o

  sudo systemctl daemon-reload
  sudo systemctl enable crio --now
  sudo systemctl start crio.service

  echo "CRI runtime installed successfully"

  # Add Kubernetes APT repository and install required packages
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

  sudo apt-get update -y
  sudo apt-get install -y kubelet="1.29.0-*" kubectl="1.29.0-*" kubeadm="1.29.0-*"
  sudo apt-get update -y
  sudo apt-get install -y jq

  sudo systemctl enable --now kubelet
  sudo systemctl start kubelet

  EOF

  tags = {
    Name = "Frontend_App"
  }
}

resource "aws_instance" "kubernetes_master" {
  ami = "ami-03fd334507439f4d1"
  instance_type = "t2.medium"
  subnet_id = module.my-vpc.public_subnets[0]
  vpc_security_group_ids =  [ aws_security_group.my_security_group.id ]
  associate_public_ip_address = true
  
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y

  # Download kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  chmod +x kubectl
  mkdir -p ~/.local/bin
  mv ./kubectl ~/.local/bin/kubectl
  # Append ~/.local/bin to $PATH
  export PATH=$PATH:~/.local/bin
  kubectl version --client

  # Disable swap
  sudo swapoff -a

  # Create the .conf file to load the modules at bootup
  cat <<EOM_1 | sudo tee /etc/modules-load.d/k8s.conf
  overlay
  br_netfilter
  EOM_1

  sudo modprobe overlay
  sudo modprobe br_netfilter

  # Apply sysctl params required by Kubernetes setup
  cat <<EOM_2 | sudo tee /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-iptables  = 1
  net.bridge.bridge-nf-call-ip6tables = 1
  net.ipv4.ip_forward                 = 1
  EOM_2

  # Apply sysctl parameters without reboot
  sudo sysctl --system

  # Install CRIO Runtime
  sudo apt-get update -y
  sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates gpg

  sudo curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list

  sudo apt-get update -y
  sudo apt-get install -y cri-o

  sudo systemctl daemon-reload
  sudo systemctl enable crio --now
  sudo systemctl start crio.service

  echo "CRI runtime installed successfully"

  # Add Kubernetes APT repository and install required packages
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

  sudo apt-get update -y
  sudo apt-get install -y kubelet="1.29.0-*" kubectl="1.29.0-*" kubeadm="1.29.0-*"
  sudo apt-get update -y
  sudo apt-get install -y jq

  sudo systemctl enable --now kubelet
  sudo systemctl start kubelet
  
  EOF

  tags = {
    Name = "Kubernetes_Master"
  }
}

resource "aws_instance" "jenkins_server" {
  ami = "ami-03fd334507439f4d1"
  instance_type = "t2.medium"
  subnet_id = module.my-vpc.public_subnets[0]
  vpc_security_group_ids =  [ aws_security_group.my_security_group.id ]
  associate_public_ip_address = true
  
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y

  # install jenkins
  sudo apt update
  sudo apt install openjdk-17-jdk
  curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian binary/ | sudo tee  /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update
  sudo apt-get install jenkins -y

  # download the docker
  sudo apt install -y docker.io
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker jenkins

  EOF

  tags = {
    Name = "Jenkins_Server"
  }
}


