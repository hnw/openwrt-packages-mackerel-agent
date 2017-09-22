set -eu

ARCH=$1
PKG_DIR=$2
PKGS=$3
QUIET=${4-}
FEED_NAME=custom
WORK_DIR=/work/pkgs

PATH=/home/openwrt/go1.8.3-mips32-softfloat-patch/bin:$PATH

cd /home/openwrt/sdk
rm -rf bin
cp feeds.conf.default feeds.conf
echo src-link $FEED_NAME /work >> feeds.conf
./scripts/feeds update -a
./scripts/feeds install $PKGS
make defconfig

# To bypass travis-ci 10 minutes build timeout
[[ -n "$QUIET" ]] && while true; do echo "..."; sleep 60; done &

for pkg in toolchain $PKGS; do
    echo make package/$pkg/compile V=s
    if [[ -n "$QUIET" ]]; then
        make package/$pkg/compile V=s >> $WORK_DIR/build.log 2>&1
    else
        make package/$pkg/compile V=s
    fi
done

[[ -n "$QUIET" ]] && kill %1

ls -laR bin
mkdir -p $WORK_DIR/for-bintray $WORK_DIR/for-github
if [ -e "$PKG_DIR/$FEED_NAME" ] ; then
    cd $PKG_DIR/$FEED_NAME
    for file in *; do
        cp $file $WORK_DIR/for-bintray
        cp $file $WORK_DIR/for-github/${ARCH}-${file}
    done
    ls -la $WORK_DIR/for-bintray $WORK_DIR/for-github
fi
