
- goto this </lib/systemd/system/docker.service> file 
========================================================================
-- change it with this below codes
<--
    ExecStart=/usr/bin/dockerd fd://
    with
    ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375
-->
========================================================================
- then make this file /etc/init.d/docker and then paste this below line
<-- DOCKER_OPTS="-H tcp://0.0.0.0:2375" -->
