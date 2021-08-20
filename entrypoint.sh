#!/bin/sh

echo "Copying debian packages to /packages"
exec /bin/cp -f ROOT/*.deb /packages/
echo "Done!"
