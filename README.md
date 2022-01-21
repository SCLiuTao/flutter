# myapp
# 安装JWT Auth
# firebase website(pericles) user:otp.pericles@gmail.com pwd:Per1clesNet
# 修改android包名
1. app->build.grale applicationId
2. main->kotlin
3. main->androidManifest.xml
4. debug->androidManifest.xml
5. profile->androidManifest.xml

android打包APK

1. 终端下运行　keytool -genkey -v -keystore sign.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sign 创建jks
2. app->创建key文件夹
3. 移动sign.jks到key目录下
4. 创建key.properties并且写入
    storePassword=123456
    keyPassword=123456
    keyAlias=sign
    storeFile=key/sign.jks
5.  在app->build.gradle写入
    def keystoreProperties = new Properties()
    def keystorePropertiesFile = rootProject.file('key.properties')
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
    }

     signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }


# OPT SMS
Android:
1.　登录　https://firebase.google.com/   新建应用程式
2.　添加 android 应用程序（包名必须和flutter包名一致）
3.　在终端 运行　
    android :
        keytool -list -v  -alias androiddebugkey -keystore C:\Users\Administrator\.android\debug.keystore 
        或
        keytool -list -v  -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
     mac :
        keytool -list -v  -alias androiddebugkey -keystore ~/.android/debug.keystore
     获取SHA-1 (默認密碼　android)
4.　下载 google-service.json 并放入项目的 Android -> App 文件夹中
5.  android->build.gradle内buildscript->dependencies　添加　classpath 'com.google.gms:google-services:4.3.10'
6.　android->app->build.gradle　最后添加　apply plugin: 'com.google.gms.google-services'
7.  一般设定　預設 GCP 資源位置选择　asia-southeast2、支援電子郵件选择预设邮件、新增加sha-256
9.  Firebase 身份认证中启用电话登录。
10.  pubspec.yaml 添加　
 　　 firebase_auth: ^3.2.0
  　　firebase_core: ^1.10.0
11. 在https://console.cloud.google.com/apis/library/androidcheck.googleapis.com中启用当前项目设备连接
12. android->app->build.gradle dependencies内加入　  implementation "androidx.browser:browser:1.3.0"
13. defaultConfig 加入　 multiDexEnabled true

IOS:
1. 项目内拖动 Runner.Xcworkspace到Xcode
2. 拖动googleServer-info.plist到项目IOS-》Runner（与info.plist同级）
3. 终端进入IOS目录，执行 pod install
4. 打开info.plist加入
    <key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>XXXXX</string> XXXX为GoogleServer-Info.plist内REVERSED_CLIENT_ID字符串内容
			</array>
		</dict>
	</array>
5. LaunchImage无效时在 build Setting 内搜索 launch ；在asset catalogo launch image set name 填入 LaunchImage

# 国际化多语言(工具VScode):

1. 添加插件　flutter intl
2. shift+xtrl+p 输入　flutterIntl.initialize　生成generated与|10n文件
3. shift+xtrl+p 输入 flutterIntl.addLocale(zh_CN)生成arb文件
4. 入口文件MaterialApp内添加　
　　localizationsDelegates: const [
        S.delegate, //intl的delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales, //支持的国际化语言
      //locale: const Locale('en'), //当前的语言
      localeListResolutionCallback: (locales, supportedLocales) {
        debugPrint('当前系统语言环境$locales');
        return;
      },
5. 在需要调用语言的地方使用　S.of(context).key key为arb文件内字符串名(arb文件内字符串必须用驼峰命名法，否则不生效)

# Flutter与JS交互

    html
    <div style="text-align: center">
    <button id="button" onclick="send()">jsCallFlutter</button>
    <p style="text-align: center">收到react native发送的数据: <span id="data"></span></p>
    </div>
    </body>
    <script>
        //JS调用flutter JS代码
        function send () {
            try {
                jsCallFlutter.postMessage("我是JS调用Flutter"); //jsCallFlutter是在flutter JavascriptChannel内定义的js名
            }catch (e) {
                
            }
        }
         //JS调用flutter flutter代码
        JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
            return JavascriptChannel(
            name: 'jsCallFlutter',
            onMessageReceived: (JavascriptMessage message) {
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(message.message.toString()),
                    duration: const Duration(seconds: 3),
                ),
                );
            },
            );
        }
        // flutter调用js flutter代码
        flutter 调用方法　_controller.runJavascript("flutterCallJsMethod('message from Flutter!')");
        // flutter调用js js代码
        function flutterCallJsMethod(message) {
            document.getElementById("data").innerText = message;
        }
   
    </script>

# firebase push
    app->src->main->Androidmanifest.xml
    <meta-data
        android:name="io.flutter.embedding.android.SplashScreenDrawable"
        android:resource="@drawable/launch_background"
        />

    <intent-filter>
        <action android:name="FLUTTER_NOTIFICATION_CLICK" />
        <category android:name="android.intent.category.DEFAULT" />
    </intent-filter>

# mac缺失　brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
#　解压　rar文件(没有unrar命令时执行　brew install unrar)
    unrar x 需解压的文件  
# mac解压工具　appstore The Unarchiver   

#　出现　 Command PhaseScriptExecution failed with a nonzero exit code时终端执行
$ sudo gem install cocoapods-deintegrate cocoapods-clean
$ pod deintegrate
$ pod clean

# 创建自定义google play 证书　s
    1.　下载pepk.jar并且移动到创建的　.jks同级目录，终端进入此目录
    2.　java -jar pepk.jar --keystore=sign.jks(jks文件名) --alias=sign --output=output.zip --encryptionkey=eb10fe8f7c7c9df715022017b00c6471f8ba8170b13049a11e6c09ffe3056a104a3bbe4ac5a955f4ba4fe93fc8cef27558a3eb9d2a529a2092761fb833b656cd48b9de6a --signing-keystore=sign.jks(jks文件名) --signing-key-alias=sign(jks别名)

# flutter 升级时ProcessException: Process exited abnormally； 执行git config --global --add remote.origin.proxy ""
mac 连接手同不稳定 sudo killall -STOP -c usbd

pod error :
  sudo arch -x86_64 gem install ffi

    Then

  arch -x86_64 pod install