FROM alpine:latest

ARG VCS_REF
ARG BUILD_DATE


LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="terraform-helm-kubectl-awscli-sb" \
      org.label-schema.url="https://hub.docker.com/r/scriptbees/terraform-kubectl-helm-awscli-sb/" \
      org.label-schema.vcs-url="https://github.com/scriptbees/docker-terraform-kubectl-helm-awscli-sb" \
      org.label-schema.build-date=$BUILD_DATE

# Note: Latest version of awscli may be found at:
# https://github.com/aws/aws-cli/releases

RUN apk --no-cache add \
	ca-certificates \
	groff \
	less \
	python \
	py2-pip \
	&& pip install awscli \
	&& mkdir -p /root/.aws 


RUN apk update && \
    apk add curl jq python bash ca-certificates git openssl unzip wget 



# Note: Latest version of terraform may be found at:
# https://releases.hashicorp.com/terraform/

ENV TERRAFORM_VERSION="0.12.19"

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*


# Note: Latest version of kubectl may be found at:
# https://aur.archlinux.org/packages/kubectl-bin/

ENV KUBE_LATEST_VERSION="1.17.3"

RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl 

RUN wget -q https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBE_LATEST_VERSION}/2019-06-11/bin/linux/amd64/aws-iam-authenticator -O /usr/local/bin/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator
    

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases

ENV HELM_VERSION="v3.1.0"

RUN wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

ENTRYPOINT ["/bin/bash"]
