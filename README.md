# vcpkg 使用 FFmpeg 5.1.2 的配置示例

本文档展示了如何通过 vcpkg 的 manifest 模式，使用自定义 registry 来安装指定版本的 FFmpeg（5.1.2）。

## 文件结构

项目根目录

├── vcpkg.json

└── vcpkg-configuration.json


## vcpkg.json

该文件定义了项目的依赖项，并通过 `overrides` 强制指定 FFmpeg 的版本为 `5.1.2#1`。

```json

vcpkg.json
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


vcpkg-configuration.json
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