FROM centos:8

# GoCD agent needs the jdk and git/svn/mercurial...
# Uncomment one of the lines below to ensure that openjdk is installed.
# apt-get install openjdk-8-jre-headless git
RUN yum update -y && yum -y install git unzip java-11-openjdk-devel curl microdnf && yum clean all

# download tini to ensure that an init process exists
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini-arm64 /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Add a user to run the go agent
RUN adduser go -d /go

# ensure that the container logs on stdout
ADD log4j.properties /go/log4j.properties
ADD log4j.properties /go/go-agent-log4j.properties

ADD go-agent /go/go-agent
RUN chmod 755 /go/go-agent

# Run the bootstrapper as the `go` user
USER go
CMD /go/go-agent
