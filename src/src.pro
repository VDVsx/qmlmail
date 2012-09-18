include(../common.pri)
TARGET = qmlmail
TEMPLATE = app
QT += declarative webkit network

CONFIG += link_pkgconfig \
    mobility

PKGCONFIG += qmfmessageserver \
    qmfclient

packagesExist(mlite) {
    PKGCONFIG += mlite
    DEFINES += HAS_MLITE
} else {
    warning("mlite not available. Some functionality may not work as expected.")
}

OBJECTS_DIR = .obj
MOC_DIR = .moc

SOURCES += \
    emailaccountlistmodel.cpp \
    emailmessagelistmodel.cpp \
    folderlistmodel.cpp \
    emailagent.cpp \
    emailmessage.cpp \
    emailaccountsettingsmodel.cpp \
    emailaccount.cpp \
    htmlfield.cpp \
    main.cpp

HEADERS += \
    emailaccountlistmodel.h \
    emailmessagelistmodel.h \
    folderlistmodel.h \
    emailagent.h \
    emailmessage.h \
    emailaccountsettingsmodel.h \
    emailaccount.h \
    htmlfield.h


target.path = $$[QT_INSTALL_LIBS]
INSTALLS += target

pkgconfig.files += meegoemail.pc
pkgconfig.path += $$[QT_INSTALL_LIBS]/pkgconfig
INSTALLS += pkgconfig
