#!/bin/sh

[ -z "${TURBOJPEG_VER}" ] && exit 1

(
    PKG=libjpeg-turbo
    PKG_VERSION=${TURBOJPEG_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=libjpeg-turbo-${PKG_VERSION}.tar.gz
    PKG_URL="http://downloads.sourceforge.net/project/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        ConfigurePkgInBuildDir \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS}

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

