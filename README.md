# cpp-build-system

A cross-platform C++ project template and lightweight package manager built on **CMake**, **Docker**, and **Jenkins CI**.  


Designed to produce **single-binary, statically linked executables** on Linux using **musl-libc**, and **MinGW64** builds that are **as static as possible** — all reproducibly built inside **Alpine Linux containers**.  


Supports **embedding Flutter UIs** directly within native C++ applications.  


All builds are orchestrated through project scripts — **direct CMake invocation is not supported.**

---

### ✨ Features

- **Cross-Platform Build Targets**
  - 🧱 **Linux (musl-libc)** — fully static binaries built inside **Alpine containers**
  - 🪟 **Windows (MinGW64)** — cross-compiled from Alpine, mostly static except core Win32 runtime
  - 🧩 **Windows (MSYS2)** — native dynamic builds for testing or fallback
  - 🍎 **macOS** — native x86-64 and arm64 builds

- **Build & Automation**
  - 🐳 **Alpine-based Docker environments** ensure fully reproducible builds  
  - 🤖 **Unified Jenkins pipelines** for Linux, Windows, and macOS targets  
  - 🧰 **Root-level project generator** (`create_project.sh` / `.cmd`) for instant scaffolding  

- **Development & Integration**
  - 💠 Optional **Flutter embedding** for hybrid C++/Flutter UIs  
  - 🧼 Integrated with **clangd**, **clang-format**, and **clang-tidy** for modern IDEs and CI  
  - 🪟 **Inno Setup** integration for automated Windows installer generation


---

## 🚀 Getting Started

### 1️⃣ Clone the Build System
```bash
git clone https://git.fifthgrid.com/sgraves/cpp-build-system.git
git clone https://github.com/sgraves76/cpp-build-system.git
cd cpp-build-system
```

---

### 2️⃣ Create a New Project
Run the root-level `create_project.sh` with:
1. The **project name**
2. The **parent directory** where the new project should live

Example:
```bash
./create_project.sh MyApp ~/dev
```
This creates:
```
~/dev/MyApp/
```

The new directory contains:
- A preconfigured cross-platform C++ project structure  
- A `scripts/` folder for building and packaging  

> 🧩 After creation, you'll work entirely within your new project — **cpp-build-system** remains the master template.

> ⚠️ Do **not** run `cmake` directly — always use the provided scripts.
---

### 3️⃣ Configure the Project

In your new project directory (`~/dev/MyApp/`), edit these two files before your first build:

> ⚠️ **Important Notice:**  
> Do **not modify** the root `CMakeLists.txt` file in your project.  
> All changes, targets, and configurations must be made in **`project.cmake`** only.  
> The top-level `CMakeLists.txt` is managed by cpp-build-system and is required for
> correct cross-platform builds, packaging, and CI integration.

#### **`config.sh`**
Defines your project’s **identity, features, and build behavior**:

- **Identity & versioning:**  
  `PROJECT_NAME`, `PROJECT_DESC`, `PROJECT_URL`,  
  `PROJECT_MAJOR_VERSION`, `PROJECT_MINOR_VERSION`, `PROJECT_REVISION_VERSION`, `PROJECT_RELEASE_VERSION`, `PROJECT_ITERATION_VERSION`
- **Apps & testing:**  
  `PROJECT_APP_LIST` and `PROJECT_ENABLE_TESTING`
- **Build/link behavior:**  
  `PROJECT_STATIC_LINK` (defaults to ON), `PROJECT_ENABLE_*` flags for dependencies such as Boost, Curl, FUSE, JSON, libsodium, OpenSSL, RocksDB, SQLite, spdlog, etc.
- **Platform-specific settings:**  
  `PROJECT_ENABLE_WIN32_LONG_PATH_NAMES`, macOS bundle identifiers, app icons, bundle names
- **Security, signing, and keys:**  
  `PROJECT_PUBLIC_KEY`, `PROJECT_PRIVATE_KEY`
- **Optional Flutter integration:**  
  `PROJECT_FLUTTER_BASE_HREF`
- **Overrides:**  
  A local `override.sh` (if present) is automatically sourced for per-machine customizations and is, by default, ignored in `.gitignore`

#### **`project.cmake`**
Owns your project’s **CMake build graph** — defining what gets built and how:

- **Targets:** Add **executables** and **libraries** (static/shared as needed)
- **Sources & includes:** Declare additional source lists and include paths
- **Config & resources:** Bundle configuration files and runtime assets

Together, `config.sh` (identity & features) and `project.cmake` (targets & wiring) define a complete, reproducible build configuration across all platforms.

---

### 4️⃣ Build the Project

Use the provided build wrappers — they take two arguments:
```
<arch> <config>
```

> Default \<arch\> is `x86_64` if not specified

> Default \<configuration\> is `RelWithDebInfo` if not specified

#### 🐧 Unix/Linux/macOS (via Alpine containers)
```bash
./scripts/make_unix.sh # x86_64 RelWithDebInfo
./scripts/make_unix.sh x86_64 Release
./scripts/make_unix.sh aarch64 Debug
```

#### 🪟 Windows (MinGW64 or MSYS2)
```bash
# Cross-compile Windows x64 using MinGW64 (preferred)
./scripts/make_win32.sh  x86_64 RelWithDebInfo

# Build on Windows via MSYS2 (dynamic, for testing)
./scripts/make_win32.cmd x86_64 Debug
```

> `make_unix.sh` automatically builds inside **Alpine containers** for reproducible static binaries using **musl-libc** unless `PROJECT_STATIC_LINK=OFF`.  
> `make_win32.*` supports both **MinGW64 cross-builds** (mostly static) and **MSYS2** builds (dynamic fallback).

---

## 🧹 Package Cleanup & Restore

- **Automatic cleanup on first compile:**  
  After you configure `config.sh` and run your **first successful build**, the project’s `cleanup.sh` will run to **remove any packages you set to `OFF`**. This reduces dependency bloat to exactly what your project needs.

- **Manual cleanup (optional):**  
  You can also run cleanup manually at any time from your project directory:  
  ```bash
  ./scripts/cleanup.sh
  ```

- **Restoring removed packages:**  
  If you later want to **add back packages** you previously turned off (and which `cleanup.sh` removed), run the **template’s** update script from the `cpp-build-system` repository root, pointing it at your project path:  
  ```bash
  # from the cpp-build-system repo root
  ./update_project.sh ~/dev/MyApp
  ```
  This will **restore all template-managed packages and scripts** (including `cleanup.sh`) into your project so you can re-enable dependencies via `config.sh` and rebuild.

---

## 🧱 Linking Strategy

| Target | Linking Model | Build Environment | Notes |
|---------|----------------|------------------|-------|
| **Linux (musl)** | Fully static | Alpine | No shared libs — single binary |
| **Linux (MinGW64)** | Static as possible | Alpine | Only core Win32 runtime dynamically linked |
| **Windows (MSYS2)** | Dynamic | MSYS2 | Fallback/test build |
| **macOS** | Static as possible | Native | Standard Apple toolchain behavior |

> 💡 *Goal: portable, reproducible, single-binary builds across platforms.*

---

Default `project.cmake`:
```cmake
# NOTE: For Windows Inno Setup support, create the following '.iss' file in:
#  "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/${PROJECT_NAME}.iss.in"

add_project_library(lib${PROJECT_NAME} "" "" "${PROJECT_ADDITIONAL_SOURCES}")

add_project_executable(${PROJECT_NAME} lib${PROJECT_NAME} lib${PROJECT_NAME})
if (PROJECT_IS_DARWIN AND EXISTS "${CMAKE_SOURCE_DIR}/${PROJECT_NAME}/Info.plist")
  set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/Info.plist
  )
endif()

add_project_test_executable(${PROJECT_NAME}_test lib${PROJECT_NAME} lib${PROJECT_NAME})
```

Default `config.sh`:
```bash
#!/usr/bin/env bash

PROJECT_NAME="test"

PROJECT_COMPANY_NAME=""
PROJECT_COPYRIGHT=""
PROJECT_DESC=""
PROJECT_URL=""

PROJECT_MACOS_BUNDLE_ID="com.test.${PROJECT_NAME}"
# IMPORTANT: File must be placed in assets/ folder (assets/icons.icns)
# PROJECT_MACOS_ICNS_NAME="icons.icns"
PROJECT_MACOS_ICNS_NAME=""

PROJECT_MAJOR_VERSION=0
PROJECT_MINOR_VERSION=0
PROJECT_REVISION_VERSION=1
PROJECT_RELEASE_NUM=0
PROJECT_RELEASE_ITER=alpha

PROJECT_APP_LIST=(${PROJECT_NAME})

PROJECT_PRIVATE_KEY=${DEVELOPER_PRIVATE_KEY}
PROJECT_PUBLIC_KEY=${DEVELOPER_PUBLIC_KEY}

PROJECT_STATIC_LINK=ON

PROJECT_MINGW64_COPY_DEPENDENCIES+=()
PROJECT_MSYS2_PACKAGE_LIST+=()

PROJECT_ENABLE_V2_ERRORS=ON
PROJECT_ENABLE_WIN32_LONG_PATH_NAMES=OFF

PROJECT_ENABLE_BACKWARD_CPP=OFF
PROJECT_ENABLE_BOOST=OFF
PROJECT_ENABLE_CLI11=OFF
PROJECT_ENABLE_CPP_HTTPLIB=OFF
PROJECT_ENABLE_CURL=OFF
PROJECT_ENABLE_CXXOPTS=OFF
PROJECT_ENABLE_DTL=OFF
PROJECT_ENABLE_FLAC=OFF
PROJECT_ENABLE_FMT=OFF
PROJECT_ENABLE_FONTCONFIG=OFF
PROJECT_ENABLE_FREETYPE2=OFF
PROJECT_ENABLE_FUSE=OFF
PROJECT_ENABLE_FZF=OFF
PROJECT_ENABLE_GTKMM=OFF
PROJECT_ENABLE_JSON=OFF
PROJECT_ENABLE_LIBBITCOIN_SYSTEM=OFF
PROJECT_ENABLE_LIBDSM=OFF
PROJECT_ENABLE_LIBEVENT=OFF
PROJECT_ENABLE_LIBICONV=OFF
PROJECT_ENABLE_LIBJPEG_TURBO=OFF
PROJECT_ENABLE_LIBPNG=OFF
PROJECT_ENABLE_LIBSODIUM=OFF
PROJECT_ENABLE_LIBTASN=OFF
PROJECT_ENABLE_NANA=OFF
PROJECT_ENABLE_NUSPELL=OFF
PROJECT_ENABLE_OGG=OFF
PROJECT_ENABLE_OPENAL=OFF
PROJECT_ENABLE_OPENSSL=OFF
PROJECT_ENABLE_PUGIXML=OFF
PROJECT_ENABLE_ROCKSDB=OFF
PROJECT_ENABLE_SAGO_PLATFORM_FOLDERS=OFF
PROJECT_ENABLE_SDL=OFF
PROJECT_ENABLE_SECP256K1=OFF
PROJECT_ENABLE_SFML=OFF
PROJECT_ENABLE_SPDLOG=OFF
PROJECT_ENABLE_SQLITE=OFF
PROJECT_ENABLE_STDUUID=OFF
PROJECT_ENABLE_TESTING=ON
PROJECT_ENABLE_TPL=OFF
PROJECT_ENABLE_VLC=OFF
PROJECT_ENABLE_VORBIS=OFF
PROJECT_ENABLE_WINFSP=OFF
PROJECT_ENABLE_WXWIDGETS=OFF

PROJECT_KEEP_BACKWARD_CPP=1

if [ "${PROJECT_ENABLE_TESTING}" == "ON" ]; then
  PROJECT_APP_LIST+=(${PROJECT_NAME}_test)
fi

if [ -f "./override.sh" ]; then
  . ./override.sh
fi
```
