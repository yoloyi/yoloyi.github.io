# GitHub Actions 实战 - 用 Hugo 自动构建 搭建 GitHub Pages


<!--more-->


Hugo 是什么，我就不做过多的累述了。这本大体讲解，Actions 如何 自动化构建出 Hugo 的静态页面。

我们再上一篇文章[《GitHub Actions 入门》](https://blog.yoloyi.com/2019/12/30/getting-start-github-action/)入门写了一些关于 `Actions` 的基本语法，下面我们来从头到尾搭建一个简单的 `Hugo` 的站点。

## 初始化 GitHub 仓库

这里我们沿用我们上一篇文章的 GitHub 仓库在做这件事情。

上一篇我们用的是 master 分支，这一次我们起一个 分支名字叫 develop,用来保存我们的 Hugo 的源码。

然后起一个 `gh-pages` 分支，推送到远端，用来当做我们的 GitHub Pages 展示的分支。

GitHub Pages 其实就是一个静态页面展示的一个地方，他利用生成静态页面，直接通过域名来给用户展示。

```shell script
# git checout -b gh-pages
# git push origin gh-pages
# git checkout -b develop
``` 

新建了分支后，我们通过 GitHub 的 Setting 来修改一下 我们的 Source

![git setting](/images/posts/git-setting.png)

![git source](/images/posts/gh-pages.jpg)

我们设置好了 Git Pages 展示的分支后，下面可以开始我们初始化 Hugo了。


## 初始化 Hugo

如果你已经初始化了 Hugo 项目，可以跳过这一步，直接到 Actions 自动构建


### 下载一个主题

Hugo 的开源主题还是挺多的，你可以通过 [主题官网](https://themes.gohugo.io/) 找一个你比较喜欢的主题来搭建自己的博客。

我们这里用 [Kiera](https://themes.gohugo.io/hugo-kiera/) 这个主题

```shell script
# git clone https://github.com/funkydan2/hugo-kiera
```

### 将主题内的 exampleSite 里面的文件，移动到仓库根路径

```shell script
# mv hugo-kiera/exampleSite/* ./
# mkdir themes
# mv hugo-kiera themes
```

### 运行看一看你的博客

```shell script
# hugo -D server
```

根据控制台给出的 url，用浏览器看一看你的博客。

![kiera](/images/posts/hugo-themes-kiera.png)

hugo 的配置语法，不多过累述，如果有想了解的，自行到 google 里面搜索一下即可。

hugo 编译后，会自动生成一个 public 文件夹的静态页面，我们只需要把 public 文件夹里面的东西，提交到 gh_pages 分支，就能够成功构建 GitHub Pages 页面了。

## Actions 自动构建

这里，我们只需要去监听 develop 是否推送就可以了。

* 构建我们需要做一下流程：
    - 1. 检出代码
    - 2. 安装 Hugo 环境
    - 3. 编译 Hugo
    - 4. 将 public 下的文件夹推送到 gh-pages分支
    
我们再 `.github/workflows` 里面新建一个 gh_pages.yml

```yaml
name: GitHub Page Deploy

on:
  push:
    branches:
      - develop
jobs:
  build-deploy:
    runs-on: ubuntu-18.04
    steps:
      - name: Checkout master
        uses: actions/checkout@v1
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.61.0'
          # extended: true

      - name: Build Hugo
        run: |
          hugo

      - name: Deploy Hugo to gh-pages
        uses: peaceiris/actions-gh-pages@v2
        env:
          ACTIONS_DEPLOY_KEY: ${{ secrets.ACTIONS_DEPLOY_KEY }}
          PUBLISH_BRANCH: gh-pages
          PUBLISH_DIR: ./public
```

这些 action 统统可以在 github actions marketplace 里面找到。

我们要巧妙的去搜索一些关于 uses 的一些 actions 这样可以极大的节省我们去写 shell 的时间。

上面代码中，只要配几个参数就可以用。参数之中， 需要我们的秘钥去推送到 gh-pages 分支，使用的是加密变量，需要在项目的settings/secrets菜单里面设置。

具体 我们可以看 [peaceiris/actions-gh-pages@v2](https://github.com/peaceiris/actions-gh-pages) 的文档，里面告诉了我们如何加入到 secrets 里面。

* **特别注意**
我们要去对着 [peaceiris/actions-gh-pages@v2](https://github.com/peaceiris/actions-gh-pages) 去看如何生成，以及加入加密变量。

`ACTIONS_DEPLOY_KEY` 一定要加入到 secrets 里面，否则构建推送会失败。

## 推送到远端

下面我们推送到 develop 分支里面，尝试我们的第一次构建.

![构建成功](/images/posts/success.png)

这样我们就完成了 Hugo 的构建了。然后进入你的 域名就可以看到。

具体详细 可以通过我的仓库看到

[相关 GitHub 仓库](https://github.com/yoloyi/github-actions-getting-start/tree/develop)

## 总结

我们要熟练的使用  `GitHub Actions Marketplace` 因为这里有很多已经很完善的 Actions，拿来即用。

在实际的 CI/CD 中，也基本是通过这种方式来构建，发布。具体看公司的业务流程。


## 参考文献

* [actions-gh-pages](https://github.com/peaceiris/actions-gh-pages#1-add-ssh-deploy-key)

* [阮一峰 GitHub Actions 教程](http://www.ruanyifeng.com/blog/2019/12/github_actions.html)