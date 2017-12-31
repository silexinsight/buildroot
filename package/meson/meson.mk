################################################################################
#
# meson
#
################################################################################

MESON_VERSION = 0.44.0
MESON_SITE = https://github.com/mesonbuild/meson/releases/download/$(MESON_VERSION)
MESON_LICENSE = Apache-2.0
MESON_LICENSE_FILES = COPYING
MESON_SETUP_TYPE = setuptools

HOST_MESON_DEPENDENCIES = host-ninja
HOST_MESON_NEEDS_HOST_PYTHON = python3

HOST_MESON_TARGET_ENDIAN = $(call LOWERCASE,$(BR2_ENDIAN))
HOST_MESON_TARGET_CPU = $(call qstrip,$(BR2_GCC_TARGET_CPU))

define HOST_MESON_INSTALL_CROSS_CONF
	mkdir -p $(HOST_DIR)/etc/meson
	sed -e "s%@TARGET_CROSS@%$(TARGET_CROSS)%g" \
	    -e "s%@TARGET_ARCH@%$(ARCH)%g" \
	    -e "s%@TARGET_CPU@%$(HOST_MESON_TARGET_CPU)%g" \
	    -e "s%@TARGET_ENDIAN@%$(HOST_MESON_TARGET_ENDIAN)%g" \
	    -e "s%@TARGET_CFLAGS@%`printf '"%s", ' $(TARGET_CFLAGS)`%g" \
	    -e "s%@TARGET_LDFLAGS@%`printf '"%s", ' $(TARGET_LDFLAGS)`%g" \
	    -e "s%@TARGET_CXXFLAGS@%`printf '"%s", ' $(TARGET_CXXFLAGS)`%g" \
	    -e "s%@HOST_DIR@%$(HOST_DIR)%g" \
	    $(HOST_MESON_PKGDIR)/cross-compilation.conf.in \
	    > $(HOST_DIR)/etc/meson/cross-compilation.conf
endef

HOST_MESON_POST_INSTALL_HOOKS += HOST_MESON_INSTALL_CROSS_CONF

$(eval $(host-python-package))