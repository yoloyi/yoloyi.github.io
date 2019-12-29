# 一、命令备忘录 - Cheat


<!--more-->

# Cheat？

## 与 Cheat 相遇

有一天，我写了几行 `PHP` 的代码，由于业务需求，我需要测试通过 FPM 能够承受的最大并发量是多少。

于是我在脑海里面搜索，在脑海的最深处，我想起来了一个很久没有用过的命令 `ab`。

于是，我写下了第一行关于 ab 的命令。

```shell script
$ ab --help
ab: wrong number of arguments
Usage: ab [options] [http[s]://]hostname[:port]/path
Options are:
    -n requests     Number of requests to perform
    -c concurrency  Number of multiple requests to make at a time
    -t timelimit    Seconds to max. to spend on benchmarking
                    This implies -n 50000
    -s timeout      Seconds to max. wait for each response
                    Default is 30 seconds
    -b windowsize   Size of TCP send/receive buffer, in bytes
    -B address      Address to bind to when making outgoing connections
    -p postfile     File containing data to POST. Remember also to set -T
    -u putfile      File containing data to PUT. Remember also to set -T
    -T content-type Content-type header to use for POST/PUT data, eg.
                    'application/x-www-form-urlencoded'
                    Default is 'text/plain'
    -v verbosity    How much troubleshooting info to print
    -w              Print out results in HTML tables
    -i              Use HEAD instead of GET
    -x attributes   String to insert as table attributes
    -y attributes   String to insert as tr attributes
    -z attributes   String to insert as td or th attributes
    -C attribute    Add cookie, eg. 'Apache=1234'. (repeatable)
    -H attribute    Add Arbitrary header line, eg. 'Accept-Encoding: gzip'
                    Inserted after all normal header lines. (repeatable)
    -A attribute    Add Basic WWW Authentication, the attributes
                    are a colon separated username and password.
    -P attribute    Add Basic Proxy Authentication, the attributes
                    are a colon separated username and password.
    -X proxy:port   Proxyserver and port number to use
    -V              Print version number and exit
    -k              Use HTTP KeepAlive feature
    -d              Do not show percentiles served table.
    -S              Do not show confidence estimators and warnings.
    -q              Do not show progress when doing more than 150 requests
    -l              Accept variable document length (use this for dynamic pages)
    -g filename     Output collected data to gnuplot format file.
    -e filename     Output CSV file with percentages served
    -r              Don't exit on socket receive errors.
    -m method       Method name
    -h              Display usage information (this message)
    -I              Disable TLS Server Name Indication (SNI) extension
    -Z ciphersuite  Specify SSL/TLS cipher suite (See openssl ciphers)
    -f protocol     Specify SSL/TLS protocol
                    (TLS1, TLS1.1, TLS1.2 or ALL)
    -E certfile     Specify optional client certificate chain and private key
```

返回了一大堆，我不怎么关心的东西，我只想要一个最简单的使用方法。于是，我用了第二个关于 ab 的命令

```shell script
$ man ab
```

在反反复复的，ab --help 和 man ab 以及输入命令之后，五分钟后，我通过文档得到了下面，我需要的命令及参数

```shell script
$ ab -n 1000 -c 1000 http://127.0.0.1 
```

为什么这样一个简单的命令，需要花费我这么大量的时间？

我不由的陷入了沉思。

![沉思](/images/posts/thinking.jpeg)

难道这个命令，我以前没有用过？

难道我之前没有做过笔记吗？

我不由又陷入了沉思。

![沉思](/images/posts/thinking.jpeg)

在反反复复的沉思之后，我想做一个工具，来帮助我们退化的脑子记录一些基本使用的命令。

捉摸，这个软件应该怎么设计，应该怎么使用。

结果。在一个不经意间，我发现了 [Cheat](https://github.com/cheat/cheat)


## Cheat 登场

> cheat allows you to create and view interactive cheatsheets on the command-line. It was designed to help remind *nix system administrators of options for commands that they use frequently, but not frequently enough to remember.

![cheat](/images/posts/cheat.png)


上面几句话是照抄 Github 里面的。没啥用，凑字数的。

大致意思就是，cheat 能够帮助你使用一些命令。基本就是一个备忘录功能。


## 说说体验

刚刚遇见了这个工具，我就在 自己的个人电脑上安装了 Cheat 。

我尝试了几个命令，比如 `ab`。


```shell script
$ cheat ab
cheat 返回
# To send 100 requests with a concurency of 50 requests to a URL:
ab -n 100 -c 50 <url>

# To send requests for 30 seconds with a concurency of 50 requests to a URL:
ab -t 30 -c 50 <url>

```

cheat 打印了一些基本的例子，极大的方便了我对于一些工具的使用。


## 如何安装配置 Cheat？

### 1、下载
- Mac:
    `brew install cheat`
    
- 通用方式（Mac, Linux, Windows）：
[下载](https://github.com/cheat/cheat/releases) 根据对应的平台，下载然后放入 `PATH` 中。

安装好了之后，需要初始化一些响应的命令

### 2、下载 命令提示包

下载社区 命令备注包

```shell script
$ mkdir -p ~/.dotfiles && cd ~/.dotfiles && git clone git@github.com:cheat/cheatsheets.git
```

### 3、初始化 cheat
```shell script
$ mkdir -p ~/.config/cheat && cheat --init > ~/.config/cheat/conf.yml
```
### 4、修改配置 

将 `~/.config/cheat/conf.yml` 里面的 `name: community` 下面的 `path` 更改成 我们在 2 中文件夹。

然后将 `work` 和 `personal` 给注释掉，即可使用

如下:

```vim
cheatpaths:

  # Paths that come earlier are considered to be the most "global", and will
  # thus be overridden by more local cheatsheets. That being the case, you
  # should probably list community cheatsheets first.
  #
  # Note that the paths and tags listed below are just examples. You may freely
  # change them to suit your needs.
  - name: community
    path: ~/.dotfiles/cheat
    tags: [ community ]
    readonly: true

  # Maybe your company or department maintains a repository of cheatsheets as
  # well. It's probably sensible to list those second.
  #- name: work
  # path: ~/.dotfiles/cheat/work
  # tags: [ work ]
  # readonly: false

  # If you have personalized cheatsheets, list them last. They will take
  # precedence over the more global cheatsheets.
  #- name: personal
  # path: ~/.dotfiles/cheat/personal
  # tags: [ personal ]
  # readonly: false
```

## 结尾

这里顺带讲一下 `cheat` 的原理

cheat 和 我们在 （2、下载 命令提示包） 里面其实二者是互相依赖的关系，当然，我们可以自定义自己的工具包。

- 运行 cheat 内部逻辑

当我们在运行 `cheat ab` 的时候，其实 cheat 会找到你配置的 cheatpaths 目录，然后到目录里面，找到你所搜索的命令，我们这里是 ab。然后 cheat 会内部使用 print 把文件里面的 ab 打印出来。

当我们了解了 cheat 的原理，我们再写自己的一些命令备注的时候，就会相对来说简单一些。

cheatsheets 和 cheat 的关系就是，一个是社区的命令备注包，就是一个个文本文件，还有一个是 工具。

有兴趣可以去看一看 cheat 的源码，Golang 写的，编译跨平台。



