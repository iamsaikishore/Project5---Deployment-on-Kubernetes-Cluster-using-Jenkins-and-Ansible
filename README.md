# Project5---Deployment-on-Kubernetes-Cluster-using-Jenkins-and-Ansible

**Prerequisites:** Git, GitHub, Jenkins, Ansible, Docker, Docker Hub, Kubernetes

For this project, we are going to launch 3 EC2 instances, 2 instances will be t2.micro and one will be t2.medium

1. Jenkins server (default jre, jenkins)
2. Ansible server (python, ansible, docker)
3. Kubernetes cluster (docker, kind)

### Configuring Jenkins server

#### Install Java

```shell
sudo apt update -y
sudo apt install default-jre -y
java --version
```
```sudo update-alternatives --config java or sudo update-alternatives --list java```

### Git

Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

Git is easy to learn and has a tiny footprint with lightning fast performance. It outclasses SCM tools like Subversion, CVS, Perforce, and ClearCase with features like cheap local branching, convenient staging areas, and multiple workflows.

#### Install Git

```shell
sudo apt install git -y
git --version
```

### Jenkins

Jenkins is an open-source automation tool written in Java with plugins built for continuous integration. Jenkins is used to build and test your software projects continuously making it easier for developers to integrate changes to the project, and making it easier for users to obtain a fresh build. It also allows you to continuously deliver your software by integrating with a large number of testing and deployment technologies.

With Jenkins, organizations can accelerate the software development process through automation. Jenkins integrates development life-cycle processes of all kinds, including build, document, test, package, stage, deploy, static analysis, and much more.

Jenkins achieves Continuous Integration with the help of plugins. Plugins allow the integration of Various DevOps stages. If you want to integrate a particular tool, you need to install the plugins for that tool. For example Git, Maven 2 project, Amazon EC2, HTML publisher etc.

#### Install Jenkins

First, add the repository key to your system:

```
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
```

The `gpg --dearmor` command is used to convert the key into a format that `apt` recognizes.

Next, let’s append the Debian package repository address to the server’s `sources.list`:

```
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```

The `[signed-by=/usr/share/keyrings/jenkins.asc]` portion of the line ensures that `apt` will verify files in the repository using the GPG key that you just downloaded.

After both commands have been entered, run `apt update` so that `apt` will use the new repository.

```
sudo apt-get update -y
```

Finally, install Jenkins and its dependencies:

```
sudo apt-get install jenkins -y
```

Now that Jenkins and its dependencies are in place, we’ll start the Jenkins server.

```
sudo systemctl enable jenkins.service
sudo systemctl start jenkins.service
sudo systemctl status jenkins.service
```

Grant Jenkins user and ec2-user user permission to docker deamon.

```
sudo su - 
usermod -aG docker jenkins
usermod -aG docker ec2-user
systemctl restart docker
```

As we installed many tools, its better to restart the server

```
sudo reboot now
```

**Note: ** By default, Jenkins will not be accessible to the external world due to the inbound traffic restriction by AWS. Open port 8080 in the inbound traffic rules as show below.

- EC2 > Instances > Click on <Instance-ID>
- In the bottom tabs -> Click on Security
- Security groups
- Add inbound traffic rules as shown in the image (you can just allow TCP 8080 as well, in my case, I allowed `All traffic`).

<img width="1187" alt="Screenshot 2023-02-01 at 12 42 01 PM" src="https://user-images.githubusercontent.com/43399466/215975712-2fc569cb-9d76-49b4-9345-d8b62187aa22.png">


#### Setting Up Jenkins:

To set up your installation, visit Jenkins on its default port, `8080`, using your server domain name or IP address: `http://your_server_ip_or_domain:8080`

You should receive the **Unlock Jenkins** screen, which displays the location of the initial password:

![j1](https://user-images.githubusercontent.com/129657174/232184739-64b9df07-a444-4729-9b3a-df21c2c51354.png)

In the terminal window, use the `cat` command to display the password:

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy the 32-character alphanumeric password from the terminal and paste it into the **Administrator password** field, then click **Continue**.

The next screen presents the option of installing suggested plugins or selecting specific plugins:

<img width="983" alt="j2" src="https://user-images.githubusercontent.com/129657174/232184809-3f60871d-ebae-425f-973d-167fbfe14faa.png">

We’ll click the **Install suggested** plugins option, which will immediately begin the installation process.

<img width="982" alt="j3" src="https://user-images.githubusercontent.com/129657174/232184843-7d49fa56-2102-4e2c-bc6a-921a0f7554ef.png">

When the installation is complete, you’ll be prompted to set up the first administrative user. It’s possible to skip this step and continue as `admin` using the initial password from above, but we’ll take a moment to create the user.

**Note:** The default Jenkins server is NOT encrypted, so the data submitted with this form is not protected. Refer to How to Configure Jenkins with SSL Using an Nginx Reverse Proxy on Ubuntu 22.04 to protect user credentials and information about builds that are transmitted via the web interface.

<img width="1009" alt="j4" src="https://user-images.githubusercontent.com/129657174/232184877-a06eb4b4-fe41-4edc-af35-f072e82bcffa.png">

Enter the name and password for your user:

<img width="1017" alt="j5" src="https://user-images.githubusercontent.com/129657174/232184944-a4971704-a037-4e27-b099-9be02a5a11aa.png">

You’ll receive an **Instance Configuration** page that will ask you to confirm the preferred URL for your Jenkins instance. Confirm either the domain name for your server or your server’s IP address:

<img width="1015" alt="j6" src="https://user-images.githubusercontent.com/129657174/232184976-15651c23-1e0a-490b-ab16-5494033e0c0f.png">

After confirming the appropriate information, click **Save and Finish**. You’ll receive a confirmation page confirming that **“Jenkins is Ready!”**:

<img width="983" alt="j7" src="https://user-images.githubusercontent.com/129657174/232184996-7b4798da-6c56-4a80-8a49-6515d274acac.png">

Click **Start using Jenkins** to visit the main Jenkins dashboard:

![j8](https://user-images.githubusercontent.com/129657174/232185030-c54d9308-2671-4952-ab07-5704c57715e7.png)

At this point, you have completed a successful installation of Jenkins.

Install the Required plugins in Jenkins

   - Log in to Jenkins.
   - Go to Manage Jenkins > Manage Plugins.
   - In the Available tab, search for `SSH Agent`, `Publish over SSH`.
   - Select the plugins and click the Install button.
   - Restart Jenkins after the plugin is installed. `http://<ec2-instance-public-ip-address>:8080/restart`
   
<img width="1392" alt="Screenshot 2023-02-01 at 12 17 02 PM" src="https://user-images.githubusercontent.com/43399466/215973898-7c366525-15db-4876-bd71-49522ecb267d.png">

Wait for the Jenkins to be restarted.

### Configuring Ansible server

#### Install Python

```
sudo apt update -y
sudo apt install python3 python3-pip -y
```

### Ansible

Ansible® is an open source IT automation tool that automates provisioning, configuration management, application deployment, orchestration, and many other manual IT processes. Unlike more simplistic management tools, Ansible users (like system administrators, developers and architects) can use Ansible automation to install software, automate daily tasks, provision infrastructure, improve security and compliance, patch systems, and share automation across the entire organization.

#### Install Ansible

```
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

### Docker

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker’s methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

Docker provides the ability to package and run an application in a loosely isolated environment called a container. The isolation and security allows you to run many containers simultaneously on a given host. Containers are lightweight and contain everything needed to run the application, so you do not need to rely on what is currently installed on the host. You can easily share containers while you work, and be sure that everyone you share with gets the same container that works in the same way.

#### **Installing Docker**

#### Uninstall old versions

Older versions of Docker went by the names of docker, docker.io, or docker-engine, you might also have installations of containerd or runc. Uninstall any such older versions before attempting to install a new version:

```shell
sudo apt-get remove docker docker-engine docker.io containerd runc
```
```apt-get``` might report that you have none of these packages installed.

#### Install using the apt repository

Before you install Docker Engine for the first time on a new host machine, you need to set up the Docker repository. Afterward, you can install and update Docker from the repository.

**Set up the repository**

   1. Update the ```apt``` package index and install packages to allow ```apt``` to use a repository over HTTPS:

```shell
sudo apt-get update
sudo apt-get install \
  ca-certificates \
  curl \
  gnupg
```

   2. Add Docker’s official GPG key:

```shell
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

   3. Use the following command to set up the repository:

```shell
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### Install Docker Engine

   1. Update the apt package index:

```shell
sudo apt-get update -y
```

   Receiving a GPG error when running apt-get update?

   Your default umask may be incorrectly configured, preventing detection of the repository public key file. Try granting read permission for the Docker public key file before updating the package index:

```shell
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y
```

   2. Install Docker Engine, containerd, and Docker Compose.

To install the latest version, run:

```shell
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

   3. Verify that the Docker Engine installation is successful by running the hello-world image:

```shell
sudo docker run hello-world
```

This command downloads a test image and runs it in a container. When the container runs, it prints a confirmation message and exits.

```shell
sudo chmod 777 /var/run/docker.sock
```

### Configuring Kubernetes cluster

**Install the Docker**

### Kind

kind is a tool for running local Kubernetes clusters using Docker container “nodes”.
kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

#### Installing Kind

```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.18.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
**Configuring Your kind Cluster**

A simple configuration for Multi-node cluster can be achieved with the following

``` vim kind-cluster.yml```

```
# three node (two workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```

```kind create cluster --config kind-cluster.yml```










