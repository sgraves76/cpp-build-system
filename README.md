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
