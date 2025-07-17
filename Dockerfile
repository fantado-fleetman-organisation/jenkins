
# Use the official Jenkins image as a base
FROM jenkins/jenkins:lts

# Switch to the root user to install additional packages
USER root

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    maven \
    openjdk-17-jdk \
    docker.io \
    gettext \
    && rm -rf /var/lib/apt/lists/*

# Install Docker inside the Jenkins container
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh \
    && rm get-docker.sh

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl
    
# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins \
    "workflow-aggregator:latest" \
    "git:latest" \
    "github-branch-source:latest" \
    "github:latest" \
    "blueocean:latest" \
    "docker-workflow:latest" \
    "credentials-binding:latest" \
    "ws-cleanup:latest" \
    "timestamper:latest" \
    "kubernetes:latest" \
    "ssh-credentials:latest" \
    "ssh-agent:latest" \
    "pipeline-utility-steps:latest" \
    "pipeline-stage-view:latest" \
    "pipeline-rest-api:latest" \
    "pipeline-input-step:latest" \
    "pipeline-milestone-step:latest" \
    "pipeline-build-step:latest" \
    "pipeline-graph-analysis:latest" \
    "pipeline-model-api:latest" \
    "pipeline-model-declarative-agent:latest" \
    "pipeline-model-definition:latest" \
    "pipeline-model-extensions:latest" \
    "pipeline-stage-step:latest" \
    "pipeline-stage-tags-metadata:latest"
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
