### **Documentation for ecommerce\_docker\_deployment**

---

### **a. PURPOSE**

The purpose of this workload is to containerize an ecommerce application that is secure, available, and fault tolerant. I also utilized Infrastructure as Code as well as a CICD pipeline to be able to spin up or modify infrastructure as needed whenever an update is made to the application source code.

---

### **b. STEPS**

Below are the steps taken and their importance:

1. **Git Clone Repository**:  
   * Clone the repository to manage application and Terraform configurations. This helps with version control.   
2. **Create Jenkins Environment**:  
   * Created a Jenkins Manger   
   * Set up a t3.micro Jenkins Manager that configures and manages Jenkins jobs on the Jenkins Node (t3.medium) and with Docker, Terraform, and AWS CLI installed. This helps with distribution of the Jenkins resource.  
3. **Provision AWS Resources using Terraform**:  
   * Created the following resources:  
     * Production VPC with private and public subnets.  
     * Bastion hosts, load balancers, and RDS.  
     * Application EC2 instances.  
4. **Create Deploy Script**:  
   * `Deploy.sh` installs Docker, logs into Docker Hub, pulls images that were created during the Jenkins Build stage and runs containers. Also install node exporter and docker-compose.   
5. **Create Dockerfiles for Frontend and Backend Container:**  
   * Added necessary dependencies to ensure containers launched successfully.   
6. **Implement Jenkins Pipeline**:  
   * Jenkins will run the following stages: Build, test, Cleanup, Build and Push Images, Deploy Infrastructure  
7. **Create Monitoring Instance**:  
   * Monitor resources in the Application instance 

---

### **c. SYSTEM DESIGN DIAGRAM**

![Workload 6 Diagram](https://github.com/user-attachments/assets/1c0ecadc-feea-4f43-b1e2-5edaa9795081)

---

### **d. ISSUES/TROUBLESHOOTING**

1. **Jenkins Pipeline Failure:**  
   * **Build and push stage failed. Unable to push docker image to Docker Hub.**  
   * **Added Jenkins to docker user group**

   

---

### **e. OPTIMIZATION**

1. **Implement Monitoring**  
   * **Add prometheus and Grafana for Metrics** 

---

### **f. CONCLUSION**

This workload demonstrates how to deploy containerized applications. Using Terraform, Jenkins, and Docker allows for automation, and resilience.  
