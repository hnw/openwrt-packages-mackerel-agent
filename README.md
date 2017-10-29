# openwrt-packages-mackerel-agent [![Build Status](https://secure.travis-ci.org/hnw/openwrt-packages-mackerel-agent.svg?branch=master)](https://travis-ci.org/hnw/openwrt-packages-mackerel-agent)

This is [mackerel-agent](https://github.com/mackerelio/mackerel-agent/) package for OpenWrt, tested on OpenWrt 15.05.1 / LEDE 17.01.4.

# How to install binary package

See [hnw/openwrt-packages](https://github.com/hnw/openwrt-packages).

# How to build

To build these packages, add the following line to the feeds.conf in the OpenWrt buildroot:

```
$ echo 'src-git hnw_mackerel-agent https://github.com/hnw/openwrt-packages-mackerel-agent.git' >> feeds.conf
```

Then you can build packages as follows:

```
$ ./scripts/feeds update -a
$ ./scripts/feeds install mackerel-agent
$ make packages/mackerel-agent/compile
```
