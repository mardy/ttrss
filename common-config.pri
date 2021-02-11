INSTALL_PREFIX=/usr

!CONFIG(desktop) {
    CONFIG(qtc) {
        INSTALL_PREFIX = /
    } else {
        INSTALL_PREFIX = $${TOP_BUILD_DIR}/
    }
    unix:CLICK_ARCH = $$system("dpkg-architecture -qDEB_HOST_ARCH")
}

!isEmpty(PREFIX) {
    INSTALL_PREFIX=$${PREFIX}
}

INSTALL_BIN_DIR = $${INSTALL_PREFIX}/bin
linux:HOST_MULTIARCH = $$system("dpkg-architecture -qDEB_HOST_MULTIARCH")
INSTALL_LIB_DIR = $${INSTALL_PREFIX}/lib/$${HOST_MULTIARCH}
RELATIVE_DATA_DIR = ""
contains(INSTALL_PREFIX, "^/usr") {
    INSTALL_DATA_DIR = $${INSTALL_PREFIX}/share/$${APPLICATION_NAME}
    INSTALL_ICON_DIR = $${INSTALL_PREFIX}/share/icons/hicolor/scalable/apps
    INSTALL_DESKTOP_DIR = $${INSTALL_PREFIX}/share/applications
    RELATIVE_DATA_DIR = "../share/$${APPLICATION_NAME}"
} else:CONFIG(desktop) {
    INSTALL_DATA_DIR = $${INSTALL_PREFIX}/share
    INSTALL_ICON_DIR = $${INSTALL_DATA_DIR}
    INSTALL_DESKTOP_DIR = $${INSTALL_DATA_DIR}
    macos {
        RELATIVE_DATA_DIR = "../Resources"
    } else {
        RELATIVE_DATA_DIR = "../share"
    }
} else {
    INSTALL_DATA_DIR = $${INSTALL_PREFIX}
    RELATIVE_DATA_DIR = ".."
}

DATA_DIR = data
