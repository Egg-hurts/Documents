1、查看某个文件的修改历史：
git blame filename.c 
显示文件的每一行是在那个版本最后修改。

git log --pretty=oneline  charge.lua 
git whatchanged charge.lua 
显示某个文件的每个版本提交信息：提交日期，提交人员，版本号，提交备注（没有修改细节）

git log -p 7aee80cd2afe3202143f379ec671917bc86f9771
git show 7aee80cd2afe3202143f379ec671917bc86f9771 
显示某个版本的修改详情

git show 5aa1be6674ecf6c36a579521708bf6e5efb6795f charge.lua  
显示某个版本的某个文件修改情况

2.清理、重置
git clean -fdx;git reset --hard HEAD