# This dockerfile is specific to building Multus for OpenShift
FROM registry.ci.openshift.org/ocp/builder:rhel-9-golang-1.23-openshift-4.19 AS rhel9
ADD . /usr/src/plugins
WORKDIR /usr/src/plugins
ENV CGO_ENABLED=0
RUN ./build_linux.sh && \
    cd /usr/src/plugins/bin
WORKDIR /

FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.23-openshift-4.19 AS rhel8
ADD . /usr/src/plugins
WORKDIR /usr/src/plugins
ENV CGO_ENABLED=0
RUN ./build_linux.sh && \
    cd /usr/src/plugins/bin
WORKDIR /

FROM registry.ci.openshift.org/ocp/4.19:base-rhel9
RUN dnf install -y util-linux && dnf clean all && \
    mkdir -p /usr/src/plugins/bin && \
    mkdir -p /usr/src/plugins/rhel8/bin && \
    mkdir -p /usr/src/plugins/rhel9/bin

COPY --from=rhel8 /usr/src/plugins/bin/* /usr/src/plugins/rhel8/bin/
# pod container image is RHEL8 based, so use rhel8
COPY --from=rhel8 /usr/src/plugins/bin/* /usr/src/plugins/bin/
COPY --from=rhel9 /usr/src/plugins/bin/* /usr/src/plugins/rhel9/bin/

LABEL io.k8s.display-name="Container Networking Plugins" \
      io.k8s.description="This is a component of OpenShift Container Platform and provides the reference CNI plugins." \
      io.openshift.tags="openshift" \
      maintainer="Doug Smith <dosmith@redhat.com>"

