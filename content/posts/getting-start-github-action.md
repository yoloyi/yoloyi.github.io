---
title: "GitHub Actions 入门"
date: 2019-12-30T16:26:12+08:00
lastmod: 2019-12-30T16:26:12+08:00
draft: true
description: "GitHub Actions 是 GitHub 的持续集成服务。在没有这个服务之前，我们一般使用 Travis CI 或者 GitHub CI 等工具来执行推送代码后的一些相关操作。"
show_in_homepage: true
show_description: true
license: ''

tags: [CI/CD, 工具]
categories: [工具]

featured_image: '/images/posts/github_action_1.png'
featured_image_preview: ''

comment: true
toc: true
autoCollapseToc: true
math: false
---

# GitHub Actions 入门

`GitHub Actions` 是在 `GitHub` 上的一个基于事件编排的自动化工作流程，于 2019 年 8 月 推出 beta 版，到目前为止，已经推出了正式版本，供用户使用。

之前，由于 `GitHub` 没有相应的持续化构建的服务，大部分用户，都是使用一些其他的服务，如 `Travis CI`, `GitLab CI`。

前几天，我由于博客的模板由 `Hexo` 更换到 `Hugo`，尝试了一下 `GitHub Actions` 自动化构建 `Hugo` 部署到 `Git Pages` 的一个实验，发现还比较方便。

下面写一下，我使用 `GitHub Actions` 的一些例子，和一些与其他 `CI / CD` 工具的一些区别。

##  （一）GitHub Actions 概念

### 1. GitHub Actions 是什么？

编码只是在软件开发中很小的一部分，在我们编码结束后，我们需要编译、自动化测试、发布。

GitHub Actions 可以帮助你在存储代码的同时，完成一部分构建，测试，打包，发布或部署。

借助 GitHub Actions 我们可以自定义工作流程(workflow)，GitHub Actions 可以在 GitHub 内完成持续集成。

### 2. GitHub Actions 能帮助我们做什么？

我们来理解一下下面这张图的。

![CI/CD](/images/posts/github_action_ci_cd.png)

从上图我们可以看出，开发人员每次在写完代码的时候，会讲代码提交到 Git 或者 SVN 的仓库中，仓库检测到有代码上来了，会做一些处理，比如跑单元测试，当项目单元测试通过后，进行打包。然后发送到环境部署上面。

这里面, `GitHub Actions` 可以帮助你除了代码开发的一些后续的集成。

这里我们插一个小的知识点。

在持续集成当中，建议每天都要提交，而不是攒着一起提交，这样的好处是，因为提交的量很小，在线上环境单元测试没有通过，很容易去找到什么出错的地方在哪里。

这样，我们的提交就会轻巧，合并到主干的时候，也不会有太多的冲突。


### 3. GitHub Actions 优势

1、存在于 GitHub内，我们再企业中，很多时候也是用 GitHub，不需要其他的服务来扩展。

2、世界上最大的代码托管中心。

3、GitHub 把我们一系列的可能会使用到的脚本，变成了独立的 action 也就是一个独立脚本（后面我们会讲到这个）。


### 4. GitHub Actions 基本概念

GitHub Actions 有一些术语。

- workflow （工作流程）：持续集成一次运行的过程，就是一个 workflow。

- job （任务）：一个 workflow 由一个或多个 jobs 构成，含义是一次持续集成的运行，可以完成多个任务。

- step（步骤）：每个 job 由多个 step 构成，一步步完成。

- action （动作）：每个 step 可以依次执行一个或多个命令（action）。

后面会通过例子来讲解这些的具体使用方式。

## （二）例子 Hello World

通过例子来学习是最高效的办法，先跑通例子，然后根据例子的一些行为，再来学习一些语法，个人认为这样学起来更快。

下面我们先进行实操吧。

### 1. 实操

#### 1、我们先新建一个仓库
![New Repository](/images/posts/github_action_new_repository.png)

#### 2、将新的仓库 clone 下来

```shell script
# git clone {YOUR REPOSITORY}
```

#### 3、进入你仓库目录，新建文件夹 .github/workflows

```shell script
mkdir -p .github/workflows 
```

GitHub Actions 的配置文件叫做 workflow 文件，存放在代码仓库的 `.github/workflows`目录。

`workflow` 文件采用 YAML 格式，文件名可以任意取，但是后缀名统一为 `.yml`，比如 `example.yml` 。一个库可以有多个 `workflow` 文件。
GitHub 只要发现 `.github/workflows` 目录里面有 `.yml` 文件，就会自动运行该文件。

#### 4、新建文件 `example.yml`，将下面的脚本复制到文件里面，然后在根目录下新建一个 `text` 文件 里面写上Hello Actions.

```yaml
name: First example
on:
  push:
    branches:
      - master
jobs:
  hello-actions:
    runs-on: ubuntu-18.04
    name: hello-actions
    steps:
      # 每一个不走步骤跟随一个 name ，还有一些其他的参数。
      - name: Checkout Master
        uses: actions/checkout@v1

      - name: Cat text
        run: |
          cat text
```

#### 5、推送到远程master

打开我们的仓库 Actions 标签页

![Actions](/images/posts/github_action_2.png)

得到了第一次提交到 `master` 的构建，我们点击 First example 进入构建详情页面
 
![Actions](/images/posts/github_action_3.png)

我们可以看到，我们第一个构建打印 text 文件成功。

第一个实操结束了，也得到了相应的结果，来看一下每个语法分别的意思。

### 2. Workflow Yaml 语法

* **name**: 工作流名称，也就是这个构建的名称。如果不填，GitHub会将其设置为相对于存储库根目录的工作流文件路径。
    
* **on**: 触发工作流程，也就是我们何时触发 workflow 的条件，必填项。 我们在实操写的意思是，推送到 `master` 分支触发构建。

* **jobs**: 工作组

* **hello-actions:**: 工作的 job，这里 `hello-actions` 可以自己随便填写，一个自己能够看得懂的名称

* **runs-on:**: 运行在什么平台，我们这里指定的是 `ubuntu-18.04`

* **steps:**: 步骤，workflow 会从上到下依次去执行你定义的一些步骤

* **uses:**: uses 可以指定一些，在 GitHub 里面的 Actions，这个 Actions 是别人已经打包好的一些命令，比如 我们这里 `actions/checkout@v1` 意思就是 检出代码

* **run:**: 执行的命令，我们这里 就普通一个 输出

每一个 `step` 必须要有一个 `uses` 或 `run`, 因为你要指定这个步骤是干嘛的。

更多语法可以仔细阅读 [GitHub workflow 语法](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

uses 使用的 Actions 可以在GitHub 上的 商店 里面看到 [https://github.com/marketplace?type=actions](https://github.com/marketplace?type=actions)

下面我们可以自己尝试一下，修改 text 文件 推送到 master 分支他打印的一些东西

## （三）总结

这里我们讲了一些初始的 GitHub Actions 的用法，后面会从 Hugo 搭建博客来实战 GitHub Actions 的一些用法。

uses 可以通过 商店来找到我们的一些已经定义好的 actions，这些 actions 可以简化我们的一些命令，当然，你可以自己在 steps 自己去写一些命令来替代他。但是不要频繁造轮子，别人写的 actions 其实已经包含了你的一些操作。

**后续文章预告，后面我会从 Hugo 搭建博客来讲一下我自己的 Actions 的用法**

[本教程GitHub 仓库](https://github.com/yoloyi/github-actions-getting-start)

## （四）参考资料

* [GitHub Actions](https://help.github.com/en/actions)
* [自动化构建](https://help.github.com/en/actions/automating-your-workflow-with-github-actions)
* [workflow 语法](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions#jobs)








