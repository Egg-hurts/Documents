##1. Project
###1.1 tips
1. Android通过**package name**区分不同的app
1. xml文件：
 - 定义
     - xml：@+id/foo
 - 引用
     - code：R.id.foo
     - xml：@id/foo
###1.2 Eclipse
1. *miniSDK/targetSDK/complie with*:
 - miniSDK：最低兼容版本，会限制使用new API的新特性
 - targetSDK：在该版本上经过了全面测试，Android不会对该版本进行前向兼容的动作
 - complie with：支持你所使用的所有相关API的最低版本，一般是最新版本
2. project目录结构
 - src：Java code
 - gen：AUTO-GENERATED
 - assets：随程序打包的相关文件，eg. local html page
 - bin：编译时生成的相关文件
 - libs：Jar包，放到该目录下的Jar包都会自动添加到构建路径中，并映射到Android Private Libraries。其他libs索引：
  - Android xx：*android.jar*
  - Android Dependencies：
     - 依赖于其他library类型的project，对应其bin文件夹下的Jar包
     - 如果本project和被引用project用到同一个Jar包，版本需要保持一致，如：依赖于appcompat_v7，而本project和appcompat_v7中的*android-support-v4.jar*不一致，就会出错，可以直接删掉本project的对应Jar包。之后，appcompat_v7/bin映射到该索引，appcompat_v7/libs映射到Android Private Libraries索引。
  -   Referenced Libraries：引用的外部Jar包，不能和Private Libraries引用同一个Jar包
 - res：图片/布局/字符串等资源文件，gen中的R.java通过该目录生成
    - res/raw：该目录下的文件会直接打包进apk，不会编译为二进制
 - AndroidManifest.xml：注册Android四大组件/声明或定义权限等
 - project.properties：AUTO-GENERATED，指定了**project的complie with SDK版本/引用的library**等等
3. 快捷键
###1.3 Android Studio

----------

##2. Intent
###2.1 tips
1. 每个**Intent**(不是intent-filter)只能有一个action，可以有多个category；默认的category是*android.intent.category.DEFEAULT*，`startActivity()`会自动添加该category。
###2.2 intent-filter
1. 主Activity的声明。如果一个App不存在任何具有该声明的Activity，则不会在Launcher显示：
 ```
<intent-filter>
		<action android:name="android.intent.action.MAIN" />
		<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
 ``` 

2. data标签
android:[select from *scheme://host:port/path*]


----------

##3.Activity
###3.1 manifest配置
1. *android:label*
 - 标题栏的内容；主activity的该标签也会成为launcher中的名字
2. *android:theme*
 ```
"@android:style/Theme.Dialog"
 ```
 
3. *android:launchMode*
 - standard
默认。
 - singleTop
确保Activity在task中的top的唯一性。
 - singleTask
确保Activity在task中的唯一性。
 - singleInstance
确保Activity的唯一性。
###3.2 功能/UI
1. 隐藏标题栏
在`onCreate()`中的`setContentView()`之前添加
 ```
requestWindowFeature(Window.FEATURE_NO_TITLE);
``` 

2. 添加menu
(1)创建*res/menu/main.xml*
 ```
<menu xmlns:android="http://schemas.android.com/apk/res/android">
	<item
		android:id="@+id/add_item"
		android:title="Add"/>
	<item
		android:id="@+id/remove_item"
		android:title="Remove"/>
</menu>
 ```
(2)重写`onCreateOptionsMenu()`方法
 ```
public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.main, menu);
		return true;  //允许显示
}
 ```
(3)重写`onOptionsItemSelected()`
 ```
public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		......
		}
}
 ```

3. back键按下会回调`onBackPressed()`
 
###3.3 Activity间数据交互
1. A-->B
A在Intent中通过extra附带数据，`startActivity()`启动B，B通过`getIntent()`拿到启动时的Intent，读取其中的extra。
2. A<--B
 - 前提是A是通过`startActivityForResult(intentFromAToB, requestCode)`启动的B。
 - B在结束或主动`finish()`之前，调用`setResult(resultCode, intentFromBToA)`，根据不同的情况设置*requestCode[RESULT_OK/RESULT_CANCELED]*，创建返回给A的用于承载extra的Intent。
 - 当B销毁，会回调A的`onActivityResult(requestCode, resultCode, intent)`，通过*requestCode*来区分来源，通过*resultCode*得到执行情况，通过*intent*得到extra。

###3.4 Activity被回收后的数据恢复
1. 重写`onSaveInstanceState(Bundle outState)`方法，将需要保存的数据put到*outState*中。
2. 当Activity被回收后重新启动，回调`onCreate(Bundle savedInstanceState)`方法，从*savedInstanceState*中取出之前的数据。

###3.5 


##4.Service
##5.Broadcast
##6.Content Provider

##7.View

> Written with [StackEdit](https://stackedit.io/).
