/usr/bin/glance-registry --config-file=/etc/glance/glance-registry.conf > /var/log/nova/glance-registry.log 2>&1 &
 
cd /usr/bin
/usr/bin/glance-api --config-file=/etc/glance/glance-api.conf > /var/log/nova/glance-api.log 2>&1 &
echo "Waiting for g-api to start..."
if ! timeout 60 sh -c "while ! wget --no-proxy -q -O- http://127.0.0.1:9292;
do sleep 1; done"; then
        echo "g-api did not start"
        exit 1
fi
echo "Done."
 
cd /usr/bin
/usr/bin/keystone-all --config-file /etc/keystone/keystone.conf > /var/log/nova/keystone-all.log 2>&1 &
echo "Waiting for keystone to start..."
if ! timeout 60 sh -c "while ! wget --no-proxy -q -O- http://127.0.0.1:5000;
do sleep 1; done"; then
        echo "keystone did not start"
        exit 1
fi
echo "Done."
 
cd /usr/bin/
/usr/bin/cinder-api --config-file /etc/cinder/cinder.conf > /var/log/nova/cinder-api.log 2>&1 &
 
cd /usr/bin/
/usr/bin/cinder-volume --config-file /etc/cinder/cinder.conf > /var/log/nova/cinder-volume.log 2>&1 &
 
cd /usr/bin/
/usr/bin/cinder-scheduler --config-file /etc/cinder/cinder.conf > /var/log/nova/cinder-scheduler.log 2>&1 &
 
cd /usr/bin
/usr/bin/nova-api > /var/log/nova/nova-api.log 2>&1 &
echo "Waiting for nova-api to start..."
if ! timeout 60 sh -c "while ! wget --no-proxy -q -O- http://127.0.0.1:8774;
do sleep 1; done"; then
        echo "nova-api did not start"
        exit 1
fi
echo "Done."
 
cd /usr/bin
/usr/bin/nova-conductor > /var/log/nova/nova-conductor.log 2>&1 &

cd /usr/bin
/usr/bin/nova-scheduler > /var/log/nova/nova-scheduler.log 2>&1 &
 
cd /usr/bin
/usr/bin/nova-compute > /var/log/nova/nova-compute.log 2>&1 &
 
cd /opt/stack/noVNC
/opt/stack/noVNC/utils/nova-novncproxy --config-file /etc/nova/nova.conf  --web . > /var/log/nova/nova-novncproxy.log 2>&1 &
 
cd /usr/bin/
/usr/bin/nova-consoleauth > /var/log/nova/nova-consoleauth.log 2>&1 &

cd /usr/bin/
/usr/bin/neutron-server > /var/log/nova/neutron-server.log 2>&1 &

echo "Waiting for neutron-server to start..."
if ! timeout 60 sh -c "while ! wget --no-proxy -q -O- http://127.0.0.1:9696;
do sleep 1; done"; then
        echo "neutron server did not start"
        exit 1
fi
echo "Done."

cd /usr/bin/
/usr/bin/neutron-openvswitch-agent > /var/log/nova/neutron-ovs-agent.log 2>&1 &

cd /usr/bin/
/usr/bin/neutron-l3-agent > /var/log/nova/neutron-l3-agent.log 2>&1 &
