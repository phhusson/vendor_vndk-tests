#!/bin/bash

set -ex

t="$(mktemp)"
for vndk in 26 27;do
	for src in $(find "$1"/sepolicies/$vndk/ -name \*.cil);do
		./out/host/linux-x86/bin/secilc "$2"/system/etc/selinux/plat_sepolicy.cil -o "$t" -M true -G -N -c 30 "$2"/system/etc/selinux/mapping/${vndk}.0.cil "$src"
		./out/host/linux-x86/bin/checkpolicy -M -bC -o /dev/null "$t"
		rm -f "$t"
	done
done

for vndk in 29 28;do
	for src in $(find "$1"/sepolicies/$vndk -name \*sepolicy.cil);do
		plat_pub="$(echo "$src" |sed -E 's/_sepolicy.cil$/_plat_pub.cil/g')"
		./out/host/linux-x86/bin/secilc "$2"/system/etc/selinux/plat_sepolicy.cil -o "$t" -M true -G -N -c 30 "$2"/system/etc/selinux/mapping/${vndk}.0.cil "$plat_pub" "$src"
		./out/host/linux-x86/bin/checkpolicy -M -bC -o /dev/null "$t"
		rm -f "$t"
	done
done
