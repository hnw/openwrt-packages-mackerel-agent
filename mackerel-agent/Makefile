include $(TOPDIR)/rules.mk

PKG_NAME:=mackerel-agent
PKG_VERSION:=0.45.0
PKG_RELEASE:=1

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/mackerelio/mackerel-agent/archive/
PKG_MD5SUM:=32d6ded877a8722cd42bf75015b31bff

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_USE_MIPS16:=0

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Yoshio HANAWA <for-openwrt@hnw.jp>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

include $(INCLUDE_DIR)/package.mk

define Package/mackerel-agent
  SECTION:=admin
  CATEGORY:=Administration
  TITLE:=mackerel.io agent
  URL:=https://mackerel.io/
endef

define Package/mackerel-agent/description
  mackerel.io agent
  Server monitoring agent for https://mackerel.io (Monitoring SaaS)
endef

# golang cross-compile architecture (GOARCH)
GOARCH:=

# golang soft-float support (GOARM/GOMIPS)
GOSOFTFLOAT:=

# set GOARCH and GOARM/GOMIPS by $(ARCH)
ifeq ($(ARCH),mips)		# for MIPS big-endianess SoC
  GOARCH:=mips
  GOSOFTFLOAT:=GOMIPS=softfloat
endif
ifeq ($(ARCH),mipsel)		# for MIPS little-endianess SoC
  GOARCH:=mipsle
  GOSOFTFLOAT:=GOMIPS=softfloat
endif
ifeq ($(ARCH),mips64)		# for MIPS64 big-endianess SoC
  GOARCH:=mips64
  GOSOFTFLOAT:=GOMIPS=softfloat
endif
ifeq ($(ARCH),arm)		# for ARM SoC
  GOARCH:=arm
  GOSOFTFLOAT:=GOARM=5
endif
ifeq ($(ARCH),i386)		# for x86 (i386) SoC/CPU
  GOARCH:=386
endif
ifeq ($(ARCH),x86_64)		# for x86_64 (amd64) SoC/CPU
  GOARCH:=amd64
endif

CROSS_COMPILE_GOENVS:=GOOS=linux GOARCH=$(GOARCH) $(GOSOFTFLOAT)

define Build/Configure
	true
endef

define Build/Compile
	make -C $(PKG_BUILD_DIR) generate
	$(CROSS_COMPILE_GOENVS) make CC=gcc -C $(PKG_BUILD_DIR) build
	upx --best $(PKG_BUILD_DIR)/build/$(PKG_NAME)
endef

define Build/Install
	true
endef

define Package/mackerel-agent/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/$(PKG_NAME) $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/mackerel-agent/status
	$(INSTALL_CONF) ./files/$(PKG_NAME).conf $(1)/etc/mackerel-agent/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/$(PKG_NAME).init $(1)/etc/init.d/$(PKG_NAME)

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/$(PKG_NAME).uci $(1)/etc/config/$(PKG_NAME)
endef

$(eval $(call BuildPackage,mackerel-agent))
