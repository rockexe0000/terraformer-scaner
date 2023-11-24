

FROM public.ecr.aws/ubuntu/ubuntu:22.04_stable



RUN apt-get update \
  && apt-get install -y curl unzip wget sudo git gnupg software-properties-common



### Install terraform v1.4.0
RUN wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
RUN apt-get update && apt-get install -y terraform=1.4.0


### Install AWS-cli v2
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf aws awscliv2.zip


### Install terraformer v0.8.24
RUN curl -LO "https://github.com/GoogleCloudPlatform/terraformer/releases/download/0.8.24/terraformer-all-linux-amd64"
RUN chmod +x terraformer-all-linux-amd64
RUN sudo mv terraformer-all-linux-amd64 /usr/local/bin/terraformer





# Create app directory
RUN mkdir -p /var/app
WORKDIR /var/app






COPY . .



RUN chmod a+x -R  /var/app


CMD ["bash"]





