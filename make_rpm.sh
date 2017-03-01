VERSION=$(grep "Version:" tomcat.spec |cut -d ":" -f2 |tr -d "[:space:]")
RELEASE=$(grep "Release:" tomcat.spec |cut -d ":" -f2 |tr -d "[:space:]")
ARCH=$(grep "BuildArch:" tomcat.spec |cut -d ":" -f2 |tr -d "[:space:]")

echo "Version: $VERSION-$RELEASE BuildArch: $ARCH"

rm -rf rpmbuild
mkdir rpmbuild
mkdir rpmbuild/BUILD
mkdir rpmbuild/RPMS
mkdir rpmbuild/SOURCES
mkdir rpmbuild/SPECS
mkdir rpmbuild/SRPMS

wget http://archive.apache.org/dist/tomcat/tomcat-8/v$VERSION/bin/apache-tomcat-$VERSION.tar.gz -O apache-tomcat-$VERSION.tar.gz

ln -v -s "$(pwd)/apache-tomcat-$VERSION.tar.gz" "rpmbuild/SOURCES/"
ln -v -s "$(pwd)/tomcat."{init,logrotate,sysconfig,bin,conf} "rpmbuild/SOURCES/"
ln -v -s "$(pwd)/tomcat.spec" "rpmbuild/SPECS/"

cd rpmbuild

rpmbuild --buildroot "`pwd`/BUILDROOT" ../tomcat.spec -bb --define "_topdir `pwd`"

publish-rpm $VERSION $RELEASE $ARCH tomcat "RPMS/$ARCH/tomcat8-$VERSION-$RELEASE.$ARCH.rpm"

