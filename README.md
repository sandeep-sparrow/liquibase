# Liquibase RDS MySQL Schema Management with Spring Boot and Terraform

This project is a Spring Boot application integrated with **Liquibase** to manage MySQL schema changes on an **AWS RDS** instance. It uses **Terraform** for Infrastructure as Code (IaC) to provision the RDS and networking components like VPC, subnets, and security groups.

---

## 🚀 Tech Stack

- **Spring Boot** 3.x
- **Liquibase** 4.27.0
- **MySQL 8.0 (AWS RDS)**
- **Terraform** (AWS provider)
- **Gradle** (build automation)

---

## 📁 Project Structure

```
├── src/
│   └── main/
│       └── resources/
│           └── db/
│               └── changelog/
│                   └── db.changelog-master.yaml
├── build.gradle
├── application.properties
├── rds.tf
├── networking.tf
└── README.md
```

---

## 🏗️ Infrastructure Provisioning (Terraform)

This project provisions the following AWS resources:

- VPC with public subnets
- Internet Gateway & routing
- Security Group allowing port `3306`
- MySQL RDS instance (Free Tier eligible)
- DB Subnet Group

### ⚙️ To Provision Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

---

## 🧪 Configure Liquibase

Liquibase is integrated using the Gradle Liquibase plugin. All changelogs are defined in YAML format.

### 🛠️ Liquibase Configuration (`build.gradle`)

```groovy
liquibase {
    activities {
        main {
            changeLogFile 'db/changelog/db.changelog-master.yaml'
            url 'jdbc:mysql://<your-rds-endpoint>:3306/liquibaseapp'
            username 'username'
            password 'password'
            driver 'com.mysql.cj.jdbc.Driver'
        }
    }
    runList = 'main'
}
```

> ✅ Ensure you replace `<your-rds-endpoint>` with the Terraform output or AWS Console value.

### 🔄 Run Migrations

```bash
./gradlew update
./gradlew rollbackCount -PliquibaseCommandValue=1
```

---

## ⚙️ Spring Boot Configuration (`application.properties`)

```properties
spring.datasource.url=jdbc:mysql://<your-rds-endpoint>:3306/liquibaseapp
spring.datasource.username=username
spring.datasource.password=password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.liquibase.enabled=true
```

---

## ✅ Checklist

- [x] RDS instance is publicly accessible
- [x] VPC has DNS support and public subnets
- [x] MySQL port 3306 is open to your IP
- [x] MySQL JDBC driver added to `liquibaseRuntime` in Gradle
- [x] Terraform output exposes RDS endpoint

---

## 🛡️ Security Notes

- Use IP-restricted ingress rules for MySQL (`cidr_blocks = ["<your-ip>/32"]`)
- Avoid hardcoding credentials; use AWS Secrets Manager or environment variables

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
