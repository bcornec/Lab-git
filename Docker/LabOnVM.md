# Docker Lab - VM on a laptop

This note records notes to setup VMs on a laptop to perform the Lab

## Software installation

```
for i in 1 2 3; do
	cp /users/qemu/centos-7-x86_64.qemu /users/qemu/centos-7-x86_64-$i.qemu
	qemu-kvm -m 2048 -net nic -net user,hostfwd=tcp:127.0.0.1:250$i-:22,hostfwd=tcp:127.0.0.1:260$i-:80 /users/qemu/centos-7-x86_64-$i.qemu
done
```
On each VM launched then realize the configuration:
```
cat > /tmp/conf << EOF
useradd dock
echo "dock" | passwd dock --stdin
echo "dock ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "LANG=C" >> /root/.bashrc
echo "LANGUAGE=C" >> /root/.bashrc
echo "LC_ALL=C" >> /root/.bashrc
echo "LANG=C" >> /home/dock/.bashrc
echo "LANGUAGE=C" >> /home/dock/.bashrc
echo "LC_ALL=C" >> /home/dock/.bashrc
EOF
chmod 755 /tmp/conf
for i in 1 2 3; do
	scp -P 250$i /tmp/conf root@localhost:/tmp
	ssh -p 250$i root@localhost /tmp/conf
done
```
