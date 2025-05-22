
#!/bin/bash

sudo apt update
sudo apt install mc
sudo apt install -y openjdk-8-jdk maven wget
sudo apt install -y mysql-server
sudo systemctl enable mysql
sudo systemctl start mysql
sudo apt install -y redis redis-tools
sudo systemctl enable redis-server.service
sudo systemctl start redis-server.service

export MAVEN_OPTS="-Xmx2048m -Xms512m"

mkdir -p ~/.m2

cat <<EOF > ~/.m2/settings.xml
<settings>
    <profiles>
        <profile>
            <id>default</id>
            <properties>
                <maven.compiler.source>1.8</maven.compiler.source>
                <maven.compiler.target>1.8</maven.compiler.target>
                <maven.compiler.encoding>UTF-8</maven.compiler.encoding>
                <maven.javadoc.skip>true</maven.javadoc.skip>
            </properties>
        </profile>
    </profiles>
</settings>
EOF

sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat

wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.99/bin/apache-tomcat-9.0.99.tar.gz
sudo rm -rf /opt/tomcat
sudo tar -xzf apache-tomcat-9.0.99.tar.gz -C /opt
sudo mv /opt/apache-tomcat-9.0.99 /opt/tomcat
sudo rm -rf apache-tomcat-9.0.99.tar.gz

sudo chown -R tomcat:tomcat /opt/tomcat
sudo chmod -R u+x /opt/tomcat/bin
sudo chmod -R g+r /opt/tomcat/conf
sudo chmod -R g+w /opt/tomcat/logs /opt/tomcat/temp /opt/tomcat/work

sudo mkdir -p /opt/tomcat/logs
sudo mkdir -p /opt/tomcat/temp
sudo touch /opt/tomcat/temp/tomcat.pid
sudo chown -R tomcat:tomcat /opt/tomcat/temp/tomcat.pid

#JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
JAVA_HOME="$(readlink -f /usr/bin/java | sed "s:/bin/java::")"

cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=simple
User=tomcat
Group=tomcat
Environment="JAVA_HOME=$JAVA_HOME"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
ExecStart=/opt/tomcat/bin/catalina.sh run
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=on-failure
RestartSec=10
UMask=0007

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

sudo systemctl status tomcat

cat <<EOF | sudo tee -a /opt/tomcat/conf/tomcat-users.xml
<role rolename="manager-gui"/>
<role rolename="admin-gui"/>
<user username="multi" password="multidev" roles="manager-gui,admin-gui"/>
EOF

sudo sed -i 's/<Context>/<Context privileged="true" antiResourceLocking="false" crossContext="true">/' /opt/tomcat/webapps/manager/META-INF/context.xml

echo "Tomcat is running and accessible at http://192.168.56.11:8080/"


