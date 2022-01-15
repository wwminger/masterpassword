主密码方法的安全性

离线全平台设计

flutter优势

整合架构的后的优势：

* ffi直接调用c语言，避免了jni虚拟机，加密计算速度更快
* dart语言+c一套主代码，全平台通用，不需要移植
* 不使用数据库，所有数据即时计算，最核心的主密码不留存在任何终端，无法被木马病毒轻易窃取
* 不同网站生成不同密码，避免被撞库攻击
* 图形界面设计较为成熟，控件库资源丰富

![image1](resource:doc/assets/image-20211103083419-x0gt9jh.png)

## 摘要

目前个人密码的使用存在几个严重的安全隐患，XXXX，为了避免此类问题，提出了本地stateless 的基于flutter主密码方法跨平台实现，。此方法在多端使用了同一套代码，不留存任何任何，为不同网站提供了高安全的单独密码，为保护用户网络帐号密码安全提供了一套可靠的解决方案。

keywords:图像界面设计 javascript前端

## 引言

目前密码撞库攻击+密码泄漏，为了安全起见，为不同网站应用分配了不同的密码，但是在信息时代面对浩如星海的网站应用，如何记住并妥善保存这些密码成为了一个棘手的问题。有人选择密码管理器，例如1password、、、 这些付费或者免费的应用都是通过加密文件存储所有密码信息，还存在类似企业导致的安全风险。为了避免文件留存，主密码方法应运而生。主密码通过与不同网址加密计算衍生出了每个网址的子密码，在算法逻辑上保证了子密码的强度切避免了撞库攻击与暴力破解的可能性。

## 算法原理

主密码以无状态的方式解决密码问题，同时继续保证甚至在一定程度上为您的网站实施良好的安全性。

如图1所示，计算每个子密码需要三个输入：用户名，网站地址与主密码，通过对输入的三次加密，得到对应网站的密码。

### 第一次加密

利用用户名与主密码生成用户密钥（userKey）。我们使用 SCRYPT 加密函数从用户名和主密码中使用一组固定的参数派生出一个 64 字节的加密密钥。

```json
masterKey = SCRYPT ( key, seed, N, r, p, dkLen ) 
key = <master password>
seed = LEN(<name>) . <name> 

N = 32768
r = 8
p = 2
dkLen = 64
```

### 第二次加密

```json
siteKey = HMAC-SHA-256 ( key, seed )
key = <master key>
seed =  LEN(<site name>) . <site name> . <counter>
```

使用用户密钥与目标网址生产一组网址密钥sitekey。其中种子由目标网址与计数器counter生成，counter可以应为该子密码泄漏之后的密码重新生成的需求。

### 第三次加密

依据siteKey与选择的密码模板，生成符合要求的密码。

```json
template = templates [ <site key>[0] % LEN( templates ) ] 
for i in 0..LEN( template )
 passChars = templateChars [ template[i] ]
 passWord[i] = passChars[ <site key>[i+1] % LEN( passChars ) ]
```

## 跨平台方案

Flutter是Google打造的高性能、跨平台的UI框架。它可以给开发者提供简单、高效的方式来构建和部署跨平台、高性能移动应用；给用户提供漂亮、无平台区分的app体验。

Flutter被设计成一个可扩展，分层的系统。它包含了一系列依赖其下层的独立库。其示意图见下图。

![image2](resource:doc/assets/image-20211103111106-ndl08wh.png)

其中，framework层中的每一个组件均是可选的和可以代替的。从上图可知，Flutter系统总共可以分为三层。上层的框架（Framework），中层的引擎（Engine），以及底层的嵌入层（Embedder）。

* 框架（Framework）：框架层是纯dart语言实现的一个响应式框架，开发者平常需要通过该层和Flutter系统交互。
* 引擎（Engine）：引擎层绝大部分是用C++实现的，其为Flutter系统的核心。引擎提供了一系列Flutter核心API的底层实现，例如图形（通过Skia），文字布局，文件等，是连接框架和系统（Andoird/iOS）的桥梁。
* 嵌入层（Embedder）：嵌入层基本是由平台对应的语言实现的，例如：在Android上是由Java和C++实现；在iOS是由Objective-C/Objective-C++实现。嵌入层为Flutter系统提供了一个入口，Flutter系统通过该入口访问底层系统提供的服务，例如输入法，绘制surface等。

其中，Framework是我们这一系列文章主要关注的部分。从下到上，其主要包括：

* 基础模块（foundational）及基础服务，例如animation，painting，以及gestures，这三种基础服务是为了方便上层调用对基础模块的抽象。
* Rendering 层，为处理图层提供了抽象组件。通过这一层，你能构建一棵可绘制对象的树。你可以动态操作这些对象，这棵树可以根据你的修改自动更新这棵树。
* Widgets层，是组件的抽象。每个render对象都有对应的widget对象。除此之外，widgets层允许你定义你能重复使用的组合组件。同时，此层引入了响应式编程模型。
* Material和Cupertino库提供了一系列Material和iOS设计风格的组件。

### 方案对比

目前市面上主要有H5+原生，JavaScript+原生渲染，自绘UI+原生。三种跨平台技术，其对比结果如下。

Flutter 最大的优势，是其出色的性能。根据 Google 官方的宣传，其性能是可以媲美原生的。这一点我们可以通过以下结构示意图看出来。

原生应用是由其框架直接通过 Skia 调用 GPU 进行绘制，但是 RN 等 JavaScript + 原生渲染跨平台技术是需要由其框架先调用原生框架，再通过原生框架调用 Skia，最后调用至 GPU 进行绘制的。因此，其调用步骤上相对于原生多了一层，理论上其绘制性能将比原生差。

但是 Flutter 则不同，由于其应用也是由 Flutter 框架直接通过 Skia 调用 GPU 进行绘制，因此只要其框架的性能能媲美原生框架的性能，则其绘制性能就可以媲美原生。不仅如此，由于 Skia 是 Flutter 自带的，其升级非常方便，而 Android 系统相对而言升级比较缓慢，因此如果 Flutter 使用了更高性能的 Skia 库，其绘制性能甚至可能超过原生。

## 实验结果

![image3](resource:doc/assets/image-20211103112659-0cl2cjx.png)

## 结论