Deepseek生成的docker安装脚本，已经过检验

Example：

  ██████╗███████╗███████╗████████╗    ██╗     ██╗     ███╗   ███╗
  ██╔════╝██╔════╝██╔════╝╚══██╔══╝    ██║     ██║     ████╗ ████║
  ██║     █████╗  ███████╗   ██║       ██║     ██║     ██╔████╔██║
  ██║     ██╔══╝  ╚════██║   ██║       ██║     ██║     ██║╚██╔╝██║
  ██████╗███████╗███████║   ██║       ███████╗███████╗██║ ╚═╝ ██║
  ╚══════╝╚══════╝╚══════╝   ╚═╝       ╚══════╝╚══════╝╚═╝     ╚═╝

脚本由 deepseek-distilled-qwen-32b 模型生成

==================================================

=== Docker 安装脚本 (v2.0) ===

==================================================


==================================================

检测系统类型...
检测到系统：Debian

==================================================

检查 Docker 安装状态...
Docker 未安装。
是否需要安装 Docker？[Y/n] Y
准备安装 Docker...

==================================================

开始安装 Docker...
更新系统包列表...
安装必要的依赖包...
添加 Docker 的 GPG 密钥...(如有弹窗请选Y)
File '/usr/share/keyrings/docker-archive-keyring.gpg' exists. Overwrite? (y/N) y
注意：如果文件已存在，将覆盖旧文件。
添加 Docker 的官方仓库...
更新仓库索引...
安装 Docker CE 和相关工具...
启动并启用 Docker 服务...
允许非 root 用户运行 Docker 命令...
更新用户组信息...
非 root 用户权限设置完成。

==================================================

验证 Docker 安装...
Docker 安装成功！
Docker 版本信息：
Docker version 27.5.1, build 9f9e405
运行测试容器以验证 Docker 是否正常工作...
测试容器运行成功！

==================================================

脚本执行完毕！
