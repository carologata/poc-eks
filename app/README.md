Spring Boot Web Application

Run the application

```bash

# run the application in the demo/ folder
mvn spring-boot:run

```

Build the image and push to ECR manually

```bash

# clean the /targe and build .jar again 
./mvnw clean package

# build the image
docker build -t spring-api .

# tag the image for ECR
docker tag spring-api:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/spring-api:latest

# authenticate docker with ECR
aws ecr get-login-password \
  --region us-east-1 | \
  docker login \
  --username AWS \
  --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com

# push to ECR
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/spring-api:latest

```


Endpoints:

GET     http://localhost:8080/api/          Returns "Hello, World!"

GET     http://localhost:8080/api/users     Returns the hardcoded list of users

POST    http://localhost:8080/api/users     Accepts a JSON body to create user

GET     http://localhost:8080/api/health    Returns a status message    