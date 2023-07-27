#! /bin/bash

cp -rfv ./XcodeTemplates/Templates ~/Library/Developer/Xcode/

echo "工程文件模板配置完成" 

cp -rfv ./CodeSnippets/* ~/Library/Developer/Xcode/UserData/CodeSnippets/

echo "代码片段拷贝完成"

echo "重启Xcode，Enjoy👨🏻‍💻"
