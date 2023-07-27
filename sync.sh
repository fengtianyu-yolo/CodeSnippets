#! /bin/bash

cp -rfv ~/Library/Developer/Xcode/Templates/* ./XcodeTemplates/Templates

echo "工程模板同步完成" 

cp -rfv ~/Library/Developer/Xcode/UserData/CodeSnippets/ ./CodeSnippets/

echo "代码片段同步完成，及时推送到Github" 


