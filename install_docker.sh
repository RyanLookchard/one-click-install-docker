#!/bin/bash
# 一键安装 Docker 脚本
# 支持系统：Debian、Ubuntu、CentOS
# 仅限 root 用户执行

# 设置脚本基本信息
SCRIPT_NAME="Docker 安装脚本"
VERSION="2.0"
LOG_FILE="/tmp/docker_install.log"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DEFAULT='\033[0m'

# 分隔线
Separator() {
    echo -e "\n${BLUE}==================================================${DEFAULT}\n"
}

# ASCII 艺术标题
AsciiTitle() {
    echo -e "${CYAN}"
    echo -e "  ██████╗███████╗███████╗████████╗    ██╗     ██╗     ███╗   ███╗"
    echo -e "  ██╔════╝██╔════╝██╔════╝╚══██╔══╝    ██║     ██║     ████╗ ████║"
    echo -e "  ██║     █████╗  ███████╗   ██║       ██║     ██║     ██╔████╔██║"
    echo -e "  ██║     ██╔══╝  ╚════██║   ██║       ██║     ██║     ██║╚██╔╝██║"
    echo -e "  ██████╗███████╗███████║   ██║       ███████╗███████╗██║ ╚═╝ ██║"
    echo -e "  ╚══════╝╚══════╝╚══════╝   ╚═╝       ╚══════╝╚══════╝╚═╝     ╚═╝"
    echo -e "${DEFAULT}"
    echo -e "${YELLOW}脚本由 deepseek-distilled-qwen-32b 模型生成${DEFAULT}"
}

# 检测当前用户是否为 root
CheckRoot() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}错误：此脚本必须以 root 用户身份运行！${DEFAULT}"
        exit 1
    fi
}

# 检测系统类型
DetectOS() {
    Separator
    echo -e "${BLUE}检测系统类型...${DEFAULT}"
    if grep -qi "ubuntu" /etc/os-release; then
        OS="ubuntu"
        echo -e "${GREEN}检测到系统：Ubuntu${DEFAULT}"
    elif grep -qi "debian" /etc/os-release; then
        OS="debian"
        echo -e "${GREEN}检测到系统：Debian${DEFAULT}"
    elif grep -qi "centos" /etc/os-release; then
        OS="centos"
        echo -e "${GREEN}检测到系统：CentOS${DEFAULT}"
    else
        echo -e "${RED}错误：不支持的系统类型！${DEFAULT}"
        exit 1
    fi
}

# 检查 Docker 是否已安装
CheckDockerInstall() {
    Separator
    echo -e "${BLUE}检查 Docker 安装状态...${DEFAULT}"
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker 已安装！${DEFAULT}"
        echo -e "${BLUE}请选择操作：${DEFAULT}"
        echo -e "${GREEN}[1] ${BLUE}完全卸载 Docker"
        echo -e "${GREEN}[2] ${BLUE}修复 Docker 环境"
        echo -e "${GREEN}[3] ${BLUE}保留现有安装${DEFAULT}"
        read -p "输入选择： " choice
        case "$choice" in
            1 ) 
                UninstallDocker
                ;;
            2 ) 
                FixDockerEnvironment
                ;;
            3 ) 
                echo -e "${GREEN}保留现有 Docker 安装。${DEFAULT}"
                exit 0
                ;;
            * ) 
                echo -e "${RED}错误：无效输入，退出脚本。${DEFAULT}"
                exit 1
                ;;
        esac
    else
        echo -e "${YELLOW}Docker 未安装。${DEFAULT}"
        ReadInstallChoice
    fi
}

# 询问是否安装 Docker
ReadInstallChoice() {
    read -p "是否需要安装 Docker？[Y/n] " install_choice
    case "$install_choice" in
        [Yy] ) 
            echo -e "${GREEN}准备安装 Docker...${DEFAULT}"
            ;;
        [Nn] ) 
            echo -e "${YELLOW}用户选择不安装 Docker，脚本退出。${DEFAULT}"
            exit 0
            ;;
        * ) 
            echo -e "${RED}错误：无效输入，退出脚本。${DEFAULT}"
            exit 1
            ;;
    esac
}

# 完全卸载 Docker
UninstallDocker() {
    Separator
    echo -e "${RED}开始完全卸载 Docker...${DEFAULT}"
    if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
        echo -e "${BLUE}卸载 Docker 相关包...${DEFAULT}"
        apt-get purge docker* -y >> "$LOG_FILE" 2>&1 || { echo -e "${RED}卸载失败！${DEFAULT}"; exit 1; }
        echo -e "${BLUE}清理残留配置...${DEFAULT}"
        rm -rf /etc/docker /var/lib/docker >> "$LOG_FILE" 2>&1 || { echo -e "${RED}清理配置失败！${DEFAULT}"; exit 1; }
    elif [ "$OS" == "centos" ]; then
        echo -e "${BLUE}卸载 Docker 相关包...${DEFAULT}"
        yum remove docker* -y >> "$LOG_FILE" 2>&1 || { echo -e "${RED}卸载失败！${DEFAULT}"; exit 1; }
        echo -e "${BLUE}清理残留配置...${DEFAULT}"
        rm -rf /etc/docker /var/lib/docker >> "$LOG_FILE" 2>&1 || { echo -e "${RED}清理配置失败！${DEFAULT}"; exit 1; }
    fi
    echo -e "${GREEN}Docker 完全卸载完成。${DEFAULT}"
    exit 0
}

# 修复 Docker 环境
FixDockerEnvironment() {
    Separator
    echo -e "${BLUE}开始修复 Docker 环境...${DEFAULT}"
    if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
        echo -e "${BLUE}修复依赖包...${DEFAULT}"
        apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >> "$LOG_FILE" 2>&1 || { echo -e "${RED}修复失败！${DEFAULT}"; exit 1; }
        echo -e "${BLUE}重启 Docker 服务...${DEFAULT}"
        systemctl restart docker >> "$LOG_FILE" 2>&1 || { echo -e "${RED}重启服务失败！${DEFAULT}"; exit 1; }
    elif [ "$OS" == "centos" ]; then
        echo -e "${BLUE}修复依赖包...${DEFAULT}"
        yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >> "$LOG_FILE" 2>&1 || { echo -e "${RED}修复失败！${DEFAULT}"; exit 1; }
        echo -e "${BLUE}重启 Docker 服务...${DEFAULT}"
        systemctl restart docker >> "$LOG_FILE" 2>&1 || { echo -e "${RED}重启服务失败！${DEFAULT}"; exit 1; }
    fi
    echo -e "${GREEN}Docker 修复完成。${DEFAULT}"
    exit 0
}

# 安装 Docker
InstallDocker() {
    Separator
    echo -e "${BLUE}开始安装 Docker...${DEFAULT}"
    if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
        echo -e "${BLUE}更新系统包列表...${DEFAULT}"
        apt-get update -y >> "$LOG_FILE" 2>&1 || { echo -e "${RED}更新系统包列表失败！${DEFAULT}"; exit 1; }

        echo -e "${BLUE}安装必要的依赖包...${DEFAULT}"
        apt-get install -y curl apt-transport-https ca-certificates software-properties-common gnupg >> "$LOG_FILE" 2>&1 || { echo -e "${RED}安装依赖包失败！${DEFAULT}"; exit 1; }

        echo -e "${BLUE}添加 Docker 的 GPG 密钥...(如有弹窗请选Y)${DEFAULT}"
        curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg >> "$LOG_FILE" 2>&1 || { echo -e "${RED}添加 GPG 密钥失败！${DEFAULT}"; exit 1; }
        echo -e "${BLUE}注意：如果文件已存在，将覆盖旧文件。${DEFAULT}"

        echo -e "${BLUE}添加 Docker 的官方仓库...${DEFAULT}"
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null >> "$LOG_FILE" 2>&1 || { echo -e "${RED}添加仓库失败！${DEFAULT}"; exit 1; }

        echo -e "${BLUE}更新仓库索引...${DEFAULT}"
        apt-get update >> "$LOG_FILE" 2>&1 || { echo -e "${RED}更新仓库索引失败！${DEFAULT}"; exit 1; }

        echo -e "${BLUE}安装 Docker CE 和相关工具...${DEFAULT}"
        apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >> "$LOG_FILE" 2>&1 || { echo -e "${RED}安装 Docker 失败！${DEFAULT}"; exit 1; }

    elif [ "$OS" == "centos" ]; then
        echo -e "${BLUE}安装必要的依赖包...${DEFAULT}"
        yum install -y yum-utils >> "$LOG_FILE" 2>&1 || { echo -e "${RED}安装依赖包失败！${DEFAULT}"; exit 1; }

        echo -e "${BLUE}添加 Docker 的官方仓库...${DEFAULT}"
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo >> "$LOG_FILE" 2>&1 || { echo -e "${RED}添加仓库失败！${DEFAULT}"; exit 1; }

        echo -e "${BLUE}安装 Docker CE 和相关工具...${DEFAULT}"
        yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >> "$LOG_FILE" 2>&1 || { echo -e "${RED}安装 Docker 失败！${DEFAULT}"; exit 1; }
    fi

    echo -e "${BLUE}启动并启用 Docker 服务...${DEFAULT}"
    systemctl enable docker >> "$LOG_FILE" 2>&1 || { echo -e "${RED}启用 Docker 失败！${DEFAULT}"; exit 1; }
    systemctl start docker >> "$LOG_FILE" 2>&1 || { echo -e "${RED}启动 Docker 失败！${DEFAULT}"; exit 1; }

    # 确保 docker 组存在
    if ! grep -q '^docker:' /etc/group; then
        echo -e "${BLUE}创建 docker 组...${DEFAULT}"
        groupadd docker >> "$LOG_FILE" 2>&1 || { echo -e "${RED}创建 docker 组失败！${DEFAULT}"; exit 1; }
    fi

    # 添加当前用户到 docker 组
    echo -e "${BLUE}允许非 root 用户运行 Docker 命令...${DEFAULT}"
    usermod -aG docker $USER >> "$LOG_FILE" 2>&1 || { echo -e "${RED}设置用户组失败！${DEFAULT}"; exit 1; }

    # 更新用户组信息
    echo -e "${BLUE}更新用户组信息...${DEFAULT}"
    sg docker -c "echo '用户已切换到 docker 组'" >> "$LOG_FILE" 2>&1 || { echo -e "${RED}更新用户组失败！${DEFAULT}"; exit 1; }
    echo -e "${GREEN}非 root 用户权限设置完成。${DEFAULT}"
}

# 验证安装
VerifyInstall() {
    Separator
    echo -e "${BLUE}验证 Docker 安装...${DEFAULT}"
    if docker --version &> /dev/null; then
        echo -e "${GREEN}Docker 安装成功！${DEFAULT}"
        echo -e "${BLUE}Docker 版本信息：${DEFAULT}"
        docker --version
        echo -e "${BLUE}运行测试容器以验证 Docker 是否正常工作...${DEFAULT}"
        docker run hello-world >> "$LOG_FILE" 2>&1
        echo -e "${GREEN}测试容器运行成功！${DEFAULT}"
    else
        echo -e "${RED}错误：Docker 安装失败！请查看日志文件：$LOG_FILE${DEFAULT}"
        exit 1
    fi
}

# 主程序
Main() {
    AsciiTitle
    Separator
    echo -e "${GREEN}=== $SCRIPT_NAME (v$VERSION) ===${DEFAULT}"
    Separator
    CheckRoot
    DetectOS
    CheckDockerInstall
    InstallDocker
    VerifyInstall
    Separator
    echo -e "${GREEN}脚本执行完毕！${DEFAULT}"
}

# 执行主程序
Main
