#!/bin/bash

export DEFAULT_BIND_ADDRESS="0.0.0.0:8888"
if [ -z "${BIND_ADDRESS}" ]; then
    export BIND_ADDRESS="${DEFAULT_BIND_ADDRESS}"
fi

sed -i -e "s|base_url : False|base_url : ${BASE_URL}|g" \
       -e "s/instance_name : \"searx\"/instance_name : \"${INSTANCE_NAME}\"/g" \
       -e "s/autocomplete : \"\"/autocomplete : \"${AUTOCOMPLETE}\"/g" \
       -e "s/ultrasecretkey/$(openssl rand -hex 32)/g" \
       /opt/searx/searx/settings.yml

if [ ! -z "${MORTY_KEY}" -a ! -z "${MORTY_URL}" ]; then
	sed -i -e "s/image_proxy : False/image_proxy : True/g" /opt/searx/searx/settings.yml
	
       cat >> /opt/searx/searx/settings.yml <<-EOF
# Morty configuration
result_proxy:
   url : ${MORTY_URL}
   key : !!binary "${MORTY_KEY}"
EOF
fi

exec uwsgi --master --http-socket "${BIND_ADDRESS}" /etc/uwsgi.d/searx.ini