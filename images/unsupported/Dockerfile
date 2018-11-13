FROM centos:centos7

# Add everything
ADD . /usr/src/plugins

ENV INSTALL_PKGS "git golang"
ENV SUPPORTED "vlan macvlan dhcp host-device"
RUN yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    cd /usr/src/plugins && \
    ./build.sh && \
    yum autoremove -y $INSTALL_PKGS && \
    yum clean all && \
    rm -rf /tmp/* && \
    cd /usr/src/plugins/bin && \
    rm -f $SUPPORTED

WORKDIR /

LABEL io.k8s.display-name="Container Networking Plugins" \
      io.k8s.description="This is a component of OpenShift Container Platform and provides the reference CNI plugins." \
      io.openshift.tags="openshift" \
      maintainer="Doug Smith <dosmith@redhat.com>"
