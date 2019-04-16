# This dockerfile is specific to building Multus for OpenShift
FROM openshift/origin-release:golang-1.10 as builder

# Add everything
ADD . /usr/src/plugins

ENV SUPPORTED "macvlan dhcp host-device"
WORKDIR /usr/src/plugins
RUN ./build.sh && \
    cd /usr/src/plugins/bin && \
    rm -f $SUPPORTED

WORKDIR /

FROM openshift/origin-base
RUN mkdir -p /usr/src/plugins/bin
COPY --from=builder /usr/src/plugins/bin/* /usr/src/plugins/bin/

LABEL io.k8s.display-name="Container Networking Plugins" \
      io.k8s.description="This is a component of OpenShift Container Platform and provides the reference CNI plugins." \
      io.openshift.tags="openshift" \
      maintainer="Doug Smith <dosmith@redhat.com>"
