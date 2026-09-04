# Materia KDE — Port a Plasma 6

![Plasma](https://img.shields.io/badge/Plasma-6.x-blue) ![Estado](https://img.shields.io/badge/estado-listo-success) ![Licencia](https://img.shields.io/badge/licencia-GPLv3-lightgrey)

## Introducción

Materia es la lectura que el ecosistema KDE hace del lenguaje visual de Material Design: superficies planas, sombras suaves, esquinas redondeadas consistentes y una paleta de acentos vivos. El diseño visual original del tema pertenece a **PapirusDevelopmentTeam**, que durante años lo mantuvo disponible para Plasma 5 con un alcance muy amplio de componentes (desde el estilo del shell hasta la pantalla de login).

Este repositorio toma esa base visual y la reempaqueta para KDE Plasma 6, sobre Qt6 y KDE Frameworks 6 (KF6). A diferencia de Arc, Materia trae consigo un tema de SDDM propio, lo que introduce una capa adicional de instalación que hay que entender antes de tocarla, porque afecta directamente al gestor de inicio de sesión de tu sistema.

## Qué problema resuelve este port

El salto de Plasma 5 a Plasma 6 no es solamente un cambio de número de versión: es un cambio de runtime (Qt5 a Qt6), de convenciones de metadatos en KPackage y de las rutas exactas donde el sistema busca cada tipo de recurso visual. Un paquete de tema construido para Plasma 5, con su instalador original pensado para esas rutas y ese runtime, no se traslada sin fricción a Plasma 6.

Materia, además, es un tema con una superficie de componentes más amplia que Arc: no solo cubre el shell y la decoración de ventanas, sino también un tema de SDDM completo con tres variantes. Cada uno de esos componentes tiene su propia convención de instalación dentro del ecosistema KDE, y coordinarlos a mano (copiando carpetas manualmente) es exactamente el tipo de trabajo repetitivo y propenso a errores que un sistema de build como CMake existe para resolver.

## Qué se conserva y qué se moderniza

La identidad visual de Materia —colores, geometría, las tres variantes (estándar, Dark y Light)— se conserva sin alteraciones. Este port no reinterpreta el diseño de PapirusDevelopmentTeam; solo cambia cómo el proyecto se construye e instala.

Lo que se moderniza es la infraestructura de empaquetado: se centraliza toda la instalación en un único `CMakeLists.txt`, apoyado en Extra CMake Modules (ECM) y en las variables de instalación estandarizadas de KDE (`KDEInstallDirs`), en lugar de depender de scripts de instalación heredados o de copias manuales de carpetas.

## Componentes incluidos

- **Look-and-Feel**: `com.github.varlesh.materia`, `com.github.varlesh.materia-dark` y `com.github.varlesh.materia-light`. Agrupan la apariencia global completa bajo cada variante.
- **Plasma Desktop Theme**: `Materia` y `Materia-Color`. Definen el aspecto del propio shell de Plasma (paneles, plasmoides, OSDs).
- **Decoración de ventanas (Aurorae)**: `Materia`, `Materia-Dark` y `Materia-Light`.
- **Esquemas de color**: `MateriaDark.colors` y `MateriaLight.colors`.
- **Konsole**: `Materia.colorscheme` y `MateriaDark.colorscheme`.
- **Kvantum**: `Materia`, `MateriaDark` y `MateriaLight`.
- **SDDM**: temas `materia`, `materia-dark` y `materia-light` para la pantalla de login.
- **Wallpapers**: `Materia` y `Materia-Dark`.
- **Yakuake**: skins `materia-dark` y `materia-light`.

## Organización del repositorio

```text
materia-kde/
├── CMakeLists.txt
├── aurorae/
│   └── themes/
│       ├── Materia/
│       ├── Materia-Dark/
│       └── Materia-Light/
├── color-schemes/
│   ├── MateriaDark.colors
│   └── MateriaLight.colors
├── konsole/
│   ├── Materia.colorscheme
│   └── MateriaDark.colorscheme
├── Kvantum/
│   ├── Materia/
│   ├── MateriaDark/
│   └── MateriaLight/
├── plasma/
│   ├── desktoptheme/
│   │   ├── Materia/
│   │   └── Materia-Color/
│   └── look-and-feel/
│       ├── com.github.varlesh.materia/
│       ├── com.github.varlesh.materia-dark/
│       └── com.github.varlesh.materia-light/
├── sddm/
│   └── themes/
│       ├── materia/
│       ├── materia-dark/
│       └── materia-light/
├── wallpapers/
│   ├── Materia/
│   └── Materia-Dark/
└── yakuake/
    └── skins/
        ├── materia-dark/
        └── materia-light/
```

Cada carpeta corresponde a un tipo de recurso que un subsistema distinto de KDE resuelve de forma independiente: KWin resuelve Aurorae, Plasma Shell resuelve Look-and-Feel y Desktop Theme, SDDM resuelve su propio directorio de temas, y así sucesivamente.

## Decisiones técnicas de CMake

```cmake
cmake_minimum_required(VERSION 3.16)

project(materia-kde
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
```

**`LANGUAGES NONE`** cumple aquí la misma función que en Arc: le indica a CMake que no busque ni configure un compilador de C/C++, porque este repositorio tampoco compila código, solo instala recursos estáticos.

**Por qué Materia usa ECM y `KDEInstallDirs` en lugar de `GNUInstallDirs`.** Arc, al depender únicamente de `GNUInstallDirs`, obtiene variables genéricas de instalación estilo GNU/Linux (`CMAKE_INSTALL_DATADIR`, etc.), suficientes porque todos sus destinos son subcarpetas directas de `share/`. Materia, en cambio, instala un componente que no forma parte del estándar genérico de GNU: un tema de SDDM. `KDEInstallDirs`, el módulo de rutas de instalación que trae Extra CMake Modules (ECM), extiende las variables de `GNUInstallDirs` con variables adicionales pensadas específicamente para el ecosistema KDE (equivalentes a `KDE_INSTALL_DATADIR`, entre otras), y además ajusta su comportamiento según la plataforma de destino, algo que `GNUInstallDirs` por sí solo no contempla. `find_package(ECM 6.0 REQUIRED NO_MODULE)` es lo que hace disponibles esos módulos (`KDEInstallDirs`, `KDECMakeSettings`) para que `include()` pueda cargarlos; sin ECM instalado en el sistema, la configuración de este proyecto falla intencionalmente, porque no hay forma de resolver esas rutas de forma consistente con el resto del ecosistema KDE.

`KDECMakeSettings` complementa esto aplicando un conjunto de configuraciones recomendadas por el proyecto KDE para proyectos que usan ECM (por ejemplo, ajustes de compilación por defecto), aunque en un proyecto sin código compilado como este su efecto práctico es menor que en un proyecto de software con C++.

## Requisitos

- CMake >= 3.16
- Extra CMake Modules (ECM) >= 6.0
- KDE Plasma 6
- Qt6 (entorno de ejecución; este repositorio no compila contra Qt)

En sistemas basados en openSUSE, ECM suele estar disponible bajo un paquete como `extra-cmake-modules`; verifica el nombre exacto en el gestor de paquetes de tu distribución.

## Compilación e instalación

Primero obtén el código fuente. Sustituye `<usuario-de-github>` por la cuenta u organización real donde esté alojado el repositorio:

```bash
git clone https://github.com/freyesb01/materia-kde.git
cd materia-kde
```

Con el código ya en tu máquina:

```bash
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build
sudo cmake --install build
```

- `cmake -S . -B build` configura el proyecto y coloca todos los archivos generados en `build/`, separado del árbol de fuentes. Esto te permite borrar por completo esa carpeta sin afectar el repositorio, y mantener configuraciones distintas (por ejemplo, una para `/usr` y otra para `$HOME/.local`) en directorios de build independientes.
- `cmake --build build` invoca el sistema de construcción generado. Como el proyecto declara `LANGUAGES NONE`, no hay nada que compilar; este paso procesa los targets internos de CMake (incluido el de instalación) sin generar binarios.
- `cmake --install build` es el paso que efectivamente copia los archivos a su destino final, combinando cada `DESTINATION` con `CMAKE_INSTALL_PREFIX`. Como el prefijo por defecto en el ejemplo es `/usr`, directorio propiedad de `root`, este comando necesita `sudo`.

## Instalación de usuario en `$HOME/.local`

```bash
cmake -S . -B build-user -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build build-user
cmake --install build-user
```

Instalar en `$HOME/.local` es preferible cuando solo quieres probar el tema: no requiere privilegios de administrador, no interfiere con archivos gestionados por el paquete de tu distribución, y revertirlo es tan simple como borrar la carpeta correspondiente. Ten en cuenta que el tema de SDDM instalado bajo este prefijo **no será detectado por SDDM**, porque SDDM se ejecuta antes de que exista una sesión de usuario y solo lee temas desde rutas del sistema (normalmente bajo `/usr/share/sddm/themes`); para probar el tema de login necesitas instalarlo con `CMAKE_INSTALL_PREFIX=/usr`.

## Cómo probar la instalación

Para los componentes de sesión (Look-and-Feel, Plasma Desktop Theme, Aurorae, colores, Konsole, Kvantum, Yakuake), reinicia el shell de Plasma:

```bash
kquitapp6 plasmashell && kstart plasmashell
```

Para el tema de SDDM, la única forma real de probarlo es cerrar sesión (o reiniciar el servicio `sddm`) y observar la pantalla de login.

## Cómo verificar las rutas instaladas

```bash
cat build/install_manifest.txt
```

```bash
find "$HOME/.local/share" -iname '*materia*'
```

o, para una instalación en todo el sistema:

```bash
find /usr/share -iname '*materia*'
```

Como en Arc, este `CMakeLists.txt` solo copia lo que está explícitamente declarado en sus reglas `install()`. Archivos de documentación como `README.md`, `LICENSE` o `AUTHORS` permanecen en el repositorio y no forman parte de la instalación.

## Cómo activar cada componente desde KDE

1. **Apariencia global**: Apariencia → Apariencia global → **Materia**, **Materia Dark** o **Materia Light**.
2. **Estilo de Plasma**: Apariencia → Estilo de Plasma → **Materia** o **Materia-Color**.
3. **Decoración de ventanas**: Apariencia → Decoración de ventanas → **Materia**, **Materia-Dark** o **Materia-Light**.
4. **Colores**: Apariencia → Colores → **MateriaDark** o **MateriaLight**.
5. **Kvantum**: Kvantum Manager → **Materia**, **MateriaDark** o **MateriaLight**.
6. **SDDM**: ver la sección siguiente, porque este paso requiere permisos administrativos.

## Consideraciones de SDDM, Kvantum, Konsole y Yakuake

**SDDM.** El tema de login no se activa desde Configuración del sistema como el resto de los componentes: SDDM lee su configuración desde archivos bajo `/etc/sddm.conf.d/`, que pertenecen a `root`. Cambiar el tema de SDDM significa modificar el comportamiento del gestor de inicio de sesión de **todo el sistema**, no solo de tu usuario, así que el cambio requiere permisos administrativos por diseño:

```bash
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=materia" | sudo tee /etc/sddm.conf.d/theme.conf
sudo systemctl restart sddm
```

Ten presente que `sudo systemctl restart sddm` cierra la sesión gráfica activa de inmediato si la estás ejecutando desde una sesión que corre sobre SDDM; guarda tu trabajo antes de ejecutarlo.

**Kvantum.** Instalar los archivos del tema no lo activa automáticamente como estilo Qt; necesitas seleccionarlo desde Kvantum Manager o desde la configuración de estilo de `qt6ct`.

**Konsole.** Los esquemas de color quedan disponibles en la lista de Konsole, pero tienes que asignarlos manualmente al perfil que uses, desde la pestaña de apariencia del editor de perfiles.

**Yakuake.** Igual que Konsole: la skin queda instalada, pero se selecciona manualmente desde la configuración de apariencia de Yakuake.

## Limpieza, reinstalación y desinstalación

Reinstalar no requiere borrar nada primero: puedes volver a ejecutar `cmake --build` y `cmake --install` sobre el mismo directorio de build.

Para partir de cero en la configuración (no en los archivos ya instalados):

```bash
rm -rf build
rm -rf build-user
```

Para desinstalar los archivos que sí quedaron copiados en el sistema:

```bash
sudo xargs rm -v < build/install_manifest.txt
```

Si desinstalas el tema de SDDM y este estaba activo, recuerda revertir también `/etc/sddm.conf.d/theme.conf` a un tema válido antes de reiniciar `sddm`, o la pantalla de login podría fallar al iniciar.

Reconstruir la caché de KDE con `kbuildsycoca6 --noincremental` no es obligatorio en cada instalación; solo es útil si, después de instalar o quitar un componente, Plasma parece no reflejar el cambio.

## Problemas conocidos o límites

- El tema de SDDM instalado bajo `$HOME/.local` no será detectado por SDDM, ya que este último no lee rutas de usuario. Esto no es un defecto del port, sino una limitación inherente a cómo funciona SDDM.
- No existe una matriz de pruebas documentada por distribución; si encuentras un problema en tu configuración particular, repórtalo en el repositorio.
- `TODO`: confirmar en el repositorio (archivo `AUTHORS` o `LICENSE`) si el espacio de nombres `com.github.varlesh.materia*` corresponde a una atribución adicional que deba documentarse aquí junto a PapirusDevelopmentTeam.

## Créditos y licencia

- Diseño visual original del tema Materia: **PapirusDevelopmentTeam**.
- Port a Plasma 6 y mantenimiento de este repositorio: **Fredy Reyes**.

Licencia: **GPLv3**. Consulta el archivo `LICENSE` del repositorio para el texto completo.
