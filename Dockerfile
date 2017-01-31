FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y protobuf-compiler

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh
ENV DOCKER_HOST tcp://docker:2375

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

ARG VERSION=2.62

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

RUN wget -q https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.2/swarm-client-2.2-jar-with-dependencies.jar
CMD java -jar swarm-client-2.2-jar-with-dependencies.jar -master http://master:8080 $EXTRA_PARAMS


