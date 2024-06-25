#!/bin/bash
apt update
apt install -y apache2

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

apt install -y awscli

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Fallback Instance</title>
</head>
<body>
  <h2> Hellow! This script is running on the fallback instance (t2-micro), Instance ID: <span style="color:green">$INSTANCE_ID</span></h2>
  <br/>
  <h4> Please retry for the instance running Jenkins. </h4>
  
</body>
</html>
EOF

# Start Apache and enable it on boot
systemctl start apache2
systemctl enable apache2