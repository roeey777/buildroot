################################################################################
#
# cboot
#
################################################################################

CBOOT_PROJECT = $(BR2_CBOOT_NVIDIA_BOARD_TYPE)

ifeq ($(call qstrip,$(CBOOT_PROJECT)),t186)
	CBOOT_VERSION = t186-L4T-R28.2.1
else ifeq ($(call qstrip,$(CBOOT_PROJECT)),t194)
	CBOOT_VERSION = t194-L4T-R31.1
else
	$(error "$(CBOOT_PROJECT) isn't a supported board type!")
endif
CBOOT_SITE = $(call github,SMEmbed,cboot,$(CBOOT_VERSION))
CBOOT_DEPENDENCIES = toolchain

CBOOT_INSTALL_IMAGES = YES

CBOOT_LK_BUILD_ARGS = PROJECT=$(CBOOT_PROJECT)
CBOOT_LK_BUILD_ARGS += TOOLCHAIN_PREFIX=$(TARGET_CROSS)
CBOOT_LK_BUILD_ARGS += TEGRA_TOP=$(@D)
CBOOT_LK_BUILD_ARGS += DEBUG=2
CBOOT_LK_BUILD_ARGS += BUILDROOT=$(@D)/out
CBOOT_LK_BUILD_ARGS += NV_TARGET_BOARD=$(CBOOT_PROJECT)ref
CBOOT_LK_BUILD_ARGS += NV_BUILD_SYSTEM_TYPE=l4t

define CBOOT_BUILD_CMDS
	$(MAKE) -C $(@D)/bootloader/partner/t18x/cboot $(CBOOT_LK_BUILD_ARGS) LIBGCC=$(shell $(HOSTCC) -print-libgcc-file-name)
	$(CP) $(@D)/out/build-$(CBOOT_PROJECT)/lk.bin $(@D)/out/cboot.bin
endef

define CBOOT_INSTALL_IMAGES_CMD
	$(INSTALL) $(@D)/out/cboot.bin $(BINARIES_DIR)
endef

$(eval $(generic-package))
