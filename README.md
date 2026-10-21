# zircon (Docker image)

Docker image for [Zircon Mir3 Server](https://github.com/raphaelcheung/zircon-legend-server)（皓石传奇三 服务器端）。

上游在 release 中发布预编译的服务端 zip，本仓库把这些 zip 放进 .NET 8 ASP.NET 运行时镜像：

- `ghcr.io/dockers-x/zircon:v{版本}`（例如 `v1.14.0`）
- `ghcr.io/dockers-x/zircon:latest`

## ⚠️ 运行数据必须自备

上游把**运行必需的地图 / 运营数据（约 800 MB）放在百度网盘和 QQ 群文件里**，不在 GitHub Release，因此镜像内不含这些数据。启动前必须自行下载并解压到容器的 `/zircon/datas` 目录（含 `Map/` 与 `Server.ini`）。上游内置测试账号 `zrf@zrf.zrf` / `raphael@gm.gm`，密码均为 `123456`。

## 端口

| 端口 | 用途 |
| --- | --- |
| 7000 | 游戏服务端口（客户端连接） |
| 7080 | Web 管理后台 |
| 3000 | 在线人数查询 |

## 运行

```bash
docker run -d --name zircon \
  -p 7000:7000 -p 7080:7080 \
  -v /path/to/datas:/zircon/datas \
  -e TZ=Asia/Shanghai \
  ghcr.io/dockers-x/zircon:latest
```

## 自动更新

`.github/workflows/build.yml` 每天检查上游最新 release，构建 `linux/amd64` 并推送 `v{版本}` 与 `latest`；已构建的版本用 git tag 记录，不会重复构建。

## 许可

AGPL-3.0（上游）。上游声明仅供学习游戏技术，禁止商用及非法用途。