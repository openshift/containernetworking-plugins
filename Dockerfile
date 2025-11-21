# This dockerfile is specific to building Multus for OpenShift
FROM registry.ci.openshift.org/ocp/builder:rhel-9-golang-1.24-openshift-4.21 AS rhel9
ADD . /usr/src/plugins
WORKDIR /usr/src/plugins
ENV CGO_ENABLED=0
RUN ./build_linux.sh && \
    cd /usr/src/plugins/bin
WORKDIR /

FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.24-openshift-4.21 AS rhel8
ADD . /usr/src/plugins
WORKDIR /usr/src/plugins
ENV CGO_ENABLED=0
RUN ./build_linux.sh && \
    cd /usr/src/plugins/bin
WORKDIR /

FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.24-openshift-4.21 AS windows
ADD . /usr/src/plugins
WORKDIR /usr/src/plugins
ENV CGO_ENABLED=0
RUN ./build_windows.sh && \
    cd /usr/src/plugins/bin
WORKDIR /

FROM registry.ci.openshift.org/ocp/4.21:base-rhel9
RUN mkdir -p /usr/src/plugins/bin && \
    mkdir -p /usr/src/plugins/rhel8/bin && \
    mkdir -p /usr/src/plugins/rhel9/bin && \
    mkdir -p /usr/src/plugins/windows/bin
COPY --from=rhel8 /usr/src/plugins/bin/* /usr/src/plugins/rhel8/bin/
# pod container image is RHEL8 based, so use rhel8
COPY --from=rhel8 /usr/src/plugins/bin/* /usr/src/plugins/bin/
COPY --from=rhel9 /usr/src/plugins/bin/* /usr/src/plugins/rhel9/bin/
COPY --from=windows /usr/src/plugins/bin/* /usr/src/plugins/windows/bin/

LABEL io.k8s.display-name="Container Networking Plugins" \
      io.k8s.description="This is a component of OpenShift Container Platform and provides the reference CNI plugins." \
      io.openshift.tags="openshift" \
      maintainer="Doug Smith <dosmith@redhat.com>"

