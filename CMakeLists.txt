cmake_minimum_required(VERSION 3.16)

project(materia-kde-plasma6
    VERSION 6.0.0
    LANGUAGES NONE
)

find_package(ECM 6.0 REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)

install(
    DIRECTORY
        plasma/look-and-feel/com.github.varlesh.materia
        plasma/look-and-feel/com.github.varlesh.materia-dark
        plasma/look-and-feel/com.github.varlesh.materia-light
    DESTINATION
        ${KDE_INSTALL_DATADIR}/plasma/look-and-feel
)

install(
    DIRECTORY
        plasma/desktoptheme/Materia
        plasma/desktoptheme/Materia-Color
    DESTINATION
        ${KDE_INSTALL_DATADIR}/plasma/desktoptheme
)

install(
    FILES
        color-schemes/MateriaDark.colors
        color-schemes/MateriaLight.colors
    DESTINATION
        ${KDE_INSTALL_DATADIR}/color-schemes
)

install(
    FILES
        konsole/Materia.colorscheme
        konsole/MateriaDark.colorscheme
    DESTINATION
        ${KDE_INSTALL_DATADIR}/konsole
)

install(
    DIRECTORY aurorae/themes/
    DESTINATION
        ${KDE_INSTALL_DATADIR}/aurorae/themes
)

install(
    DIRECTORY sddm/themes/
    DESTINATION
        ${KDE_INSTALL_DATADIR}/sddm/themes
)

install(
    DIRECTORY wallpapers/
    DESTINATION
        ${KDE_INSTALL_DATADIR}/wallpapers
)

install(
    DIRECTORY Kvantum/
    DESTINATION
        ${KDE_INSTALL_DATADIR}/Kvantum
)

install(
    DIRECTORY yakuake/skins/
    DESTINATION
        ${KDE_INSTALL_DATADIR}/yakuake/skins
)
