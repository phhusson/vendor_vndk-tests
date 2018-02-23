LOCAL_PATH := $(call my-dir)

vndk-test-sepolicy-sources-26 := $(wildcard $(LOCAL_PATH)/sepolicies/26/*.cil)
vndk-test-sepolicy-targets-26 := $(patsubst %.cil,%-26-selinux-tested,$(vndk-test-sepolicy-sources-26))

vndk-test-sepolicy-sources-27 := $(wildcard $(LOCAL_PATH)/sepolicies/27/*.cil)
vndk-test-sepolicy-targets-27 := $(patsubst %.cil,%-27-selinux-tested,$(vndk-test-sepolicy-sources-27))
.PHONY: $(vndk-test-sepolicy-targets-26) $(vndk-test-sepolicy-targets-27)

vndk-test-sepolicy: selinux_policy checkpolicy $(vndk-test-sepolicy-targets-26) $(vndk-test-sepolicy-targets-25)
	echo "Successfully ran:"
	echo 26: $(vndk-test-sepolicy-sources-26)
	echo 26: $(vndk-test-sepolicy-targets-26)
	echo 27: $(vndk-test-sepolicy-sources-27)
	echo 27: $(vndk-test-sepolicy-targets-27)

%-26-selinux-tested: %.cil
	./out/host/linux-x86/bin/secilc $(PRODUCT_OUT)/system/etc/selinux/plat_sepolicy.cil -M true -G -N -c 30 $(PRODUCT_OUT)/system/etc/selinux/mapping/26.0.cil $<
	./out/host/linux-x86/bin/checkpolicy -M -bC -o /dev/null policy.30

%-27-selinux-tested: %.cil
	./out/host/linux-x86/bin/secilc $(PRODUCT_OUT)/system/etc/selinux/plat_sepolicy.cil -M true -G -N -c 30 $(PRODUCT_OUT)/system/etc/selinux/mapping/27.0.cil $<
	./out/host/linux-x86/bin/checkpolicy -M -bC -o /dev/null policy.30
