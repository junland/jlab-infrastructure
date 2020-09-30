#!/bin/bash

sed -i -e "s|base_url : False|base_url : ${BASE_URL}|g" \
       -e "s/image_proxy : False/image_proxy : ${IMAGE_PROXY}/g" \
       -e "s/ultrasecretkey/$(openssl rand -hex 32)/g" \
       /opt/searx/searx/settings.yml

exec python3 /opt/searx/searx/webapp.py
