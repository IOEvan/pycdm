#!/bin/bash

# 获取当前脚本文件的路径
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 获取当前脚本文件的上一级路径
parent_dir=$(dirname "$script_dir")

# 解压目标文件夹
target_dir="$parent_dir/build_snapshot"

# 检查 conan_export.tgz 文件是否存在
if [ -f "$parent_dir/conan_export.tgz" ]; then
    # 解压 conan_export.tgz 压缩包到当前目录
    tar -xzf "$parent_dir/conan_export.tgz" -C "$target_dir"
    echo "$parent_dir/conan_export.tgz untar success."
    # 检查用户输入的参数
    if [ "$1" = "rm_source_package" ]; then
        # 删除原有的 tgz 包
        rm "$parent_dir/conan_export.tgz"
        echo "delete $parent_dir/conan_export.tgz."
    fi
else
    echo "$parent_dir/conan_export.tgz not exist."
fi