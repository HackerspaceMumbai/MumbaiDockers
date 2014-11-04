#############################################################################################################
# Dockerfile to build an application stack with tomcat7 and a loadbalancer using HAProxy as a front-end     #
# Based on Ubuntu                                                                                           #
# Authors: Ashish Jaiswal; Anand Ved; Nikhil Thakkar                                                        #
#############################################################################################################

# Set the base image to Ubuntu to set up Tomcat
FROM ubuntu
MAINTAINER Ashish Jaiswal <ashish1099@gmail.com>, Anand Ved <anandved@yahoo.com>, Nikhil Thakkar <>

# Install JDK 7 and Tomcat
RUN apt-get update && apt-get install -qy openjdk-7-jdk tomcat

# Expose default port 8080
EXPOSE 8080
CMD service tomcat7 start

# Build another tomcat running on a different port
FROM ubuntu
#MAINTAINER Ashish Jaiswal <ashish1099@gmail.com>, Anand Ved <anandved@yahoo.com>, Nikhil Thakkar <>
RUN apt-get update && apt-get install -qy openjdk-7-jdk tomcat
RUN sed -i 's/8080/9080/g' /etc/tomcat7/server.xml
RUN sed -i 's/8443/9443/g' /etc/tomcat7/server.xml
RUN sed -i 's/8005/9005/g' /etc/tomcat7/server.xml
RUN sed -i 's/8005/9005/g' /etc/tomcat7/server.xml
RUN sed -i 's/8009/9009/g' /etc/tomcat7/server.xml

# Expose configured port
EXPOSE 8090
CMD service tomcat7 start

### Build a Load Balancer ###
#############################

FROM ubuntu
MAINTAINER Ashish Jaiswal <ashish1099@gmail.com>, Anand Ved <anandved@yahoo.com>, Nikhil Thakkar <>

# Install HAProxy on base Ubuntu
RUN apt-get update && apt-get install -y haproxy

# Configure log settings
RUN sed -i 's/\/dev\/log/127.0.0.1/g' /etc/haproxy/haproxy.cfg

# Configure Load Balancing properties
RUN sed -i 's/^$/&\n### ADDED BY DOCKER CONFIG >> ###&\nfrontend http-in&\n&\tbind *:80&\n&\tdefault_backend apps&\n&\nbackend apps&\n&\tserver app1 ${APP1_IP}:${APP1_PORT} maxconn 32 check&\n&\tserver app2 ${APP2_IP}:${APP2_PORT} maxconn 32 check&\n&### ADDED BY DOCKER CONFIG << ###\n/' /etc/haproxy/haproxy.cfg

# TODO Fetch the values and set them here
#ENV APP1_IP
#ENV APP1_PORT 
#ENV APP2_IP
#ENV APP2_PORT

# Expose Loadbalancer port
EXPOSE 80

