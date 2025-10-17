# cpp-build-system

A cross-platform C++ project template and lightweight package manager built on **CMake**, **Docker**, and **Jenkins CI**.  


Designed to produce **single-binary, statically linked executables** on Linux using **musl-libc**, and **MinGW64** builds that are **as static as possible** — all reproducibly built inside **Alpine Linux containers**.  


Supports **embedding Flutter UIs** directly within native C++ applications.  


All builds are orchestrated through project scripts — **direct CMake invocation is not supported.**

---

## ✨ Features

- 🧱 **Static Linux builds** using **musl-libc** inside **Alpine containers**
- 🪟 **MinGW64 cross-builds** from Alpine (static except core Win32 runtime)
- 🧩 **MSYS2 builds** as fallback or for testing
- 🐳 **Alpine-based Docker environments** for reproducible builds
- 🤖 **Single Jenkins pipeline** orchestrating Win64 + Linux x64 + Linux aarch64
- 🤖 **Single Jenkins pipeline** orchestrating macOS x86-64 + macOS aarch64
- 💠 **Flutter embedding support** for modern native UIs
- 🧰 **Root-level project generator** (`create_project.sh` / `.cmd`)
- 🧼 Ready for `clang-format`, `clang-tidy`, and CI automation

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
- Default toolchains, configs, and dependency layout  

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
- **Sources & includes:** Declare source lists, include paths, compiler flags, and definitions
- **Linkage:** Link enabled third-party dependencies (toggled in `config.sh`)
- **Config & resources:** Install or bundle configuration files and runtime assets
- **Install/export:** Define `install()` rules, export targets, generate package metadata
- **Conditionals:** Wrap optional targets behind `PROJECT_ENABLE_*` feature flags

Default `project.cmake`:
```cmake
add_project_library(lib${PROJECT_NAME} "" "" "${PROJECT_ADDITIONAL_SOURCES}")

add_project_executable(${PROJECT_NAME} lib${PROJECT_NAME} lib${PROJECT_NAME})

add_project_test_executable(${PROJECT_NAME}_test lib${PROJECT_NAME} lib${PROJECT_NAME})
```

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

> `make_unix.sh` automatically builds inside **Alpine containers** for reproducible static binaries using **musl-libc**.  
> `make_win32.*` supports both **MinGW64 cross-builds** (mostly static) and **MSYS2** builds (dynamic fallback).

---
