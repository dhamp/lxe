#!/bin/sh

[ -z "${X11PROTO_CORE_VER}" ] && exit 1

(
    PKG=x11proto-core
    PKG_VERSION=${X11PROTO_CORE_VER}
    PKG_SUBDIR_ORIG=xproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

