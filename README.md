本文档展示如何通过 vcpkg 的 manifest 模式，使用本仓库（自定义 git registry）安装指定版本的依赖。

## 文件结构

项目根目录

├── vcpkg.json

└── vcpkg-configuration.json


# vcpkg 使用 log-cpp 1.0.0 的配置示例

源码：https://github.com/feng9201/log-cpp  
当前 baseline：`1.0.0`（port-version 0）。相对 0.0.2 是一次不兼容升级：格式从 `printf` 改为 fmt `{}`，必须显式 `init`，默认倾向动态库。

## features

| feature | 作用 |
|---------|------|
| （无） | 链接方式跟 triplet：`x64-windows` → 动态，`x64-windows-static` → 静态 |
| `shared` | 强制编成动态库（即使 triplet 是 static）。多模块共用一份日志单例时建议打开 |
| `qt` | 打开 `QString` / `QByteArray` 的 fmt formatter，并拉 `qt5-base` |
| `sqlite` | 打开 SQLite sink，并拉 `sqlitecpp` |

可组合：`log-cpp[shared,qt]`、`log-cpp[qt,sqlite]`。

## vcpkg.json

```json
{
  "dependencies": [
    {
      "name": "log-cpp",
      "features": ["shared", "qt"]
    }
  ]
}
```

只要静态库、不要 Qt：

```json
{
  "dependencies": [
    "log-cpp"
  ]
}
```

需要钉死旧版 0.0.2 时用 `overrides`（API 仍是旧的 `%s` 宏）：

```json
{
  "dependencies": [
    "log-cpp"
  ],
  "overrides": [
    {
      "name": "log-cpp",
      "version": "0.0.2",
      "port-version": 4
    }
  ]
}
```

## vcpkg-configuration.json

`packages` 里必须列出 `log-cpp`，否则会去默认 registry 找。`baseline` 用本仓已包含 `1.0.0` 的提交。

```json
{
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/feng9201/vcpkg.git",
    "baseline": "74a04a88ea10fc2bca3fbfa4eb15f4168a4da43e"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/feng9201/vcpkg-registrys.git",
      "baseline": "0c50ae6d8b6dc6abf5ae5c47f3a491083a735029",
      "packages": ["log-cpp"]
    }
  ]
}
```

和本仓其它包一起用时，把名字并进同一个 registry 即可，例如 `"packages": ["log-cpp", "mtpool", "ffmpeg", "mttool"]`。

## CMake

```cmake
find_package(log-cpp CONFIG REQUIRED)
target_link_libraries(main PRIVATE log-cpp::log-cpp)
```

安装时的 `shared` / `qt` / `sqlite` 已写进 `log-cppConfig.cmake`，消费端不必再设 `LOGCPP_BUILD_SHARED`、`LOGCPP_ENABLE_QT`。

## 最小用法（1.0.0）

```cpp
#include "w_log_cpp.h"

int main() {
    w_log_cpp::InitConfig cfg;
    cfg.file_path = "./log/app.log";
    cfg.console_level = w_log_cpp::Level::Debug;
    cfg.file_level = w_log_cpp::Level::Info;
    if (!w_log_cpp::init(cfg)) {
        return 1;
    }

    LOG_INFO("uptime {}", 1);
    LOG_ERR("open failed: {}", "EACCES");

    w_log_cpp::shutdown();
}
```

格式必须用 `{}`，不要再用 `%s`。更完整的 named logger、去重、Qt 示例见源码仓 README。


# vcpkg 使用 mtpool 1.0.0 的配置示例

源码：https://github.com/feng9201/mtPool  
当前 baseline：`1.0.0#1`（version 1.0.0，port-version 1）。进程级 C++17 线程池；延迟任务和动态库都是可选 feature，默认都不开。

## port 号（port-version）

vcpkg 里版本显示为 `1.0.0#1`，`#` 后面的数字就是 port-version：库源码没变、但 port 或源码修复有更新时递增。用它区分拉的是哪一版：

| port-version | 内容 |
|--------------|------|
| `1.0.0#0` | 首个版本 |
| `1.0.0#1` | Shutdown 丢弃未到期任务并唤醒等待者；`WaitUntilIdle` 去掉轮询；Cancel 立即唤醒调度，被取消/丢弃任务的 future 抛 `broken_promise` |

不指定时默认装 baseline 指向的最新 port-version。要钉旧版用 `overrides`：

```json
{
  "dependencies": [
    "mtpool"
  ],
  "overrides": [
    {
      "name": "mtpool",
      "version": "1.0.0",
      "port-version": 0
    }
  ]
}
```

## features

| feature | 作用 |
|---------|------|
| （无） | 只有线程池。链接方式跟 triplet：`x64-windows` → 动态，`x64-windows-static` → 静态 |
| `shared` | 强制编成动态库（即使 triplet 是 static）。多模块共用一份 `pool()` / `delayed()` 时建议打开 |
| `delayed` | 打开墙钟延迟任务：`mtPool::delayed().PostDelayedTask` / `SequenceToken` |

可组合：`mtpool[delayed]`、`mtpool[shared]`、`mtpool[delayed,shared]`。

注意：port 名是 `mtpool`，CMake 包名是 `mtPool`。

## vcpkg.json

需要延迟任务、多模块共用一份池：

```json
{
  "dependencies": [
    {
      "name": "mtpool",
      "features": ["delayed", "shared"]
    }
  ]
}
```

只要线程池、链接方式跟 triplet：

```json
{
  "dependencies": [
    "mtpool"
  ]
}
```

## vcpkg-configuration.json

`packages` 里必须列出 `mtpool`，否则会去默认 registry 找。`baseline` 用本仓已包含 `1.0.0` 的提交。

```json
{
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/feng9201/vcpkg.git",
    "baseline": "74a04a88ea10fc2bca3fbfa4eb15f4168a4da43e"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/feng9201/vcpkg-registrys.git",
      "baseline": "fcb7929aa64c292de6a349172f493cfba591b816",
      "packages": ["mtpool"]
    }
  ]
}
```

和本仓其它包一起用时，把名字并进同一个 registry 即可，例如 `"packages": ["log-cpp", "mtpool", "ffmpeg", "mttool"]`。

## CMake

```cmake
find_package(mtPool CONFIG REQUIRED)
target_link_libraries(main PRIVATE mtPool::mtPool)
```

安装时的 `delayed` / `shared` 已写进 `mtPoolConfig.cmake` 和目标的接口宏（`MTPOOL_ENABLE_DELAYED`、`MTPOOL_SHARED`）。消费端不必再设 CMake option。未开 `delayed` 时不要调用 `mtPool::delayed()`。

## 最小用法

```cpp
#include <mtPool/MtPool.h>

int main() {
    mtPool::pool().detach_task([] { /* 立即异步 */ });

#if defined(MTPOOL_ENABLE_DELAYED)
    mtPool::delayed().PostDelayedTask([] { /* 约 5s 后在线程池里跑 */ },
                                      std::chrono::seconds(5));
    mtPool::delayed().WaitUntilIdle();
#endif
}
```

更完整的 SequenceToken、Cancel、`SubmitDelayed` 见源码仓 README。


# vcpkg 使用 FFmpeg 5.1.2 的配置示例

## vcpkg.json

该文件定义了项目的依赖项，并通过 `overrides` 强制指定 FFmpeg 的版本为 `5.1.2#1`。

```json

{
  "dependencies": [
    {
      "name": "ffmpeg",
      "features": [
        "ffmpeg"
      ]
    }
  ],
  "overrides": [
    {
      "name": "ffmpeg",
      "version-string": "5.1.2#1"
    }
  ]
}
```

## vcpkg-configuration.json
```json
{
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/feng9201/vcpkg.git",
    "baseline": "74a04a88ea10fc2bca3fbfa4eb15f4168a4da43e"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/feng9201/vcpkg-registrys.git",
      "baseline": "e70b336fdd667c21444b2cee5fa26d7422ebe6ea",
      "packages": ["ffmpeg"]
    }
  ]
}
```

# vcpkg 使用 FFmpeg 7.1.4 的配置示例

## vcpkg.json

该文件定义了项目的依赖项，并通过 `overrides` 强制指定 FFmpeg 的版本为 `7.1.4#0`。

```json
{
  "dependencies": [
    {
      "name": "ffmpeg",
      "features": [
        "ffmpeg"
      ]
    }
  ],
  "overrides": [
    {
      "name": "ffmpeg",
      "version-string": "7.1.4#0"
    }
  ]
}
```

## vcpkg-configuration.json
```json
{
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/feng9201/vcpkg.git",
    "baseline": "74a04a88ea10fc2bca3fbfa4eb15f4168a4da43e"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/feng9201/vcpkg-registrys.git",
      "baseline": "1b4c81f762e9d2e92860d20d2e82e56227cfcc41",
      "packages": ["ffmpeg"]
    }
  ]
}
```
