# Update
yum -y update

# Jenkins
curl -o /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum -y install jenkins java
systemctl enable jenkins
systemctl start jenkins
