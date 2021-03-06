#!/bin/sh

[ -z "${QT4_VER}" ] && exit 1

(
    PKG=qt4
    PKG_VERSION=${QT4_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=qt-everywhere-opensource-src-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR_ORIG}.tar.gz
    [ "${PKG_VERSION}" = "4.8.7" ] && \
        PKG_URL="http://download.qt.io/official_releases/qt/${QT4_SUBVER}/${QT4_VER}/${PKG_FILE}" || \
        ( IsPkgVersionGreaterOrEqualTo "4.8.0" && \
            PKG_URL="http://download.qt.io/archive/qt/${QT4_SUBVER}/${QT4_VER}/${PKG_FILE}" || \
            PKG_URL="http://download.qt.io/archive/qt/${QT4_SUBVER}/${PKG_FILE}" )
    PKG_DEPS="gcc pkg-config-settings zlib libpng jpeg freetype fontconfig libxcb libx11 libxext libxi libxrender libxrandr mesa"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        export LD=${CROSS_COMPILE}g++
        # unset CFLAGS CXXFLAGS LDFLAGS
        ConfigurePkg \
            -xplatform "linux-g++-${SYSTEM}" \
            -device-option CROSS_COMPILE="${TARGET}-" \
            -device-option SYSTEM_ROOT_DIR="${SYSROOT}" \
            -device-option PKG_CONFIG="${TARGET}-pkg-config" \
            -sysroot "${SYSROOT}" \
            -prefix "${SYSROOT}/qt4" \
            -prefix-install \
            -confirm-license \
            -opensource \
            -continue \
            -static \
            -release \
            -force-pkg-config \
            -nomake examples \
            -nomake tests \
            -nomake demos \
            -nomake docs \
            -fast \
            -pch \
            -script \
            -qpa "xcb" \
            -system-zlib \
            -system-libpng \
            -qt-libjpeg \
            -system-libtiff \
            -system-freetype \
            -fontconfig \
            -opengl desktop \
            -make libs \
            -no-rpath \
            -no-egl \
            -no-openvg \
            -no-glib \
            -no-rpath \
            -no-nis \
            -no-cups \
            -no-iconv \
            -no-icu \
            -no-dbus \
            -no-libmng \
            -no-openssl \
            -no-accessibility \
            -no-sql-sqlite \
            -no-sql-sqlite2 \
            -no-sql-mysql \
            -no-sql-psql \
            -no-sql-odbc \
            -no-sql-tds \
            -no-sql-oci \
            -no-sql-db2 \
            -no-sql-ibase \
            -no-optimized-qmake \
            -no-reduce-exports \
            -no-phonon-backend \
            -no-phonon \
            -no-gstreamer \
            -no-webkit \
            -v
#             -platform "linux-g++-${SYSTEM}" \
#             -prefix "${SYSROOT}/qt4" \
#             -prefix-install \

        BuildPkg -j ${JOBS} -i -k
        InstallPkg install -i -k

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks

        rm -rf "${SYSROOT}/qt4/lib"/*.la
    fi
)

