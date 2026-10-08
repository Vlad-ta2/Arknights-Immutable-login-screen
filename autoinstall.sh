#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "!!!!!!!!!!Please provide this to me with sudo privileges!!!!!!!!!!!!!!!"
  exec sudo "$0" "$@"
fi

cd "$(dirname "$0")"

if [ ! -d "immutable" ]; then
  echo "WTF Error: 'immutable' folder not found next to this script!"
  exit 1
fi

echo "Starting the installation of the 'immutable' SDDM theme..."
mkdir -p /usr/share/sddm/themes/
cp -r immutable /usr/share/sddm/themes/

chown -R root:root /usr/share/sddm/themes/immutable
chmod -R 755 /usr/share/sddm/themes/immutable

mkdir -p /etc/sddm.conf.d
cat <<EOF > /etc/sddm.conf.d/theme.conf
[Theme]
Current=immutable
EOF
echo " The 'immutable' theme has been successfully installed and activated!"
echo " Please reboot your computer to see the changes."
echo " Or run this command: sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/immutable"