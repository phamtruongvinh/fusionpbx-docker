FROM debian:9

MAINTAINER Pham Truong Vinh <truongvinh2112@gmail.com>

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y --allow-unauthenticated wget gnupg apt-utils

RUN wget -O - https://raw.githubusercontent.com/fusionpbx/fusionpbx-install.sh/master/debian/pre-install.sh | sed -E 's/\b(apt-get install -y)\b/\1 --allow-unauthenticated/' | sh
RUN rgrep -lE '\bapt-get install -y\b' /usr/src/fusionpbx-install.sh/debian | grep -vF '/usr/src/fusionpbx-install.sh/debian/pre-install.sh' | xargs sed -i -E 's/\b(apt-get install -y)\b/\1 --allow-unauthenticated/'

RUN mkdir /var/run/php

# In theory with the use of the custom "systemctl" this should not be necessary.
RUN sed -i -E 's/^(#+\s*)(.*service\s*postgresql)\b/\2/' /usr/src/fusionpbx-install.sh/debian/resources/postgresql.sh

RUN wget -O - https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py > /opt/systemctl3.py
RUN chmod +x /opt/systemctl3.py
RUN perl -0777 -i -pe 's/^(apt-get\s*install.*systemd-sysv.*)$/$1\nmv \/bin\/systemctl \/bin\/systemctl.ori\nln -s \/opt\/systemctl3.py \/bin\/systemctl/m' /usr/src/fusionpbx-install.sh/debian/install.sh

RUN sh /usr/src/fusionpbx-install.sh/debian/install.sh

RUN systemctl enable nginx
RUN systemctl enable postgresql
RUN systemctl enable freeswitch

COPY fusionpbx_main.sh /opt/
RUN chmod +x /opt/fusionpbx_main.sh

EXPOSE 80
EXPOSE 443

EXPOSE 5060-5090
EXPOSE 5060-5090/udp
EXPOSE 16384-32768/udp

ENTRYPOINT ["/opt/fusionpbx_main.sh"]
