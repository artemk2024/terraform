AWS CLI
```
aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```

```aws configure list-profiles```
```aws configure list```


Terraform commands

```terraform init```
```terraform plan```
```terraform apply -auto-approve```  
```terraform destroy -auto-approve``` 

Connect to EKS
```aws eks --region eu-west-1 update-kubeconfig --name example-k8s```
https://docs.aws.amazon.com/eks/latest/userguide/copy-image-to-repository.html


Connect to ECR

```aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com```

Tag the image to push to your repository.
```docker tag hello-world:latest aws_account_id.dkr.ecr.region.amazonaws.com/hello-repository```

Push the image.
```docker push aws_account_id.dkr.ecr.region.amazonaws.com/hello-repository```

List images
```aws ecr list-images --region eu-west-3 --repository-name int --profile akryvoruchko```


https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html

Example
```
docker build  -t asterisk/asterisk  .
docker tag asterisk/asterisk 496765097802.dkr.ecr.eu-west-1.amazonaws.com/sip:070224
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 496765097802.dkr.ecr.eu-west-1.amazonaws.com/sip
docker push 496765097802.dkr.ecr.eu-west-1.amazonaws.com/sip:070224
aws ecr list-images --region eu-west-1 --repository-name sip --profile akryvoruchko
```