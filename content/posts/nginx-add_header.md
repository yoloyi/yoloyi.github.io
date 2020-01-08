---
title: "【坑】Nginx add_header 因为继承特性不生效"
date: 2020-01-08T20:52:21+08:00
lastmod: 2020-01-08T20:52:21+08:00
draft: false
description: ""
show_in_homepage: true
show_description: false
license: ''

tags: [踩坑, Nginx]
categories: [踩坑]

featured_image: ''
featured_image_preview: ''

comment: true
toc: true
autoCollapseToc: true
math: false
---

<!--more-->

## 前言

今天发生了一件很玄学的事情。

今天业务在群里面发消息说："客服今天收到客户反馈一个网站：https://www.*****.**/，点进去之后，发现进入的是我们商城的前台，一模一样，也可以进入chat聊天。我们在这个网站测试下了个订单，发现提交后，我们后台也是可以搜到这个订单的： 这个网站是我们的吗？只是域名不同吗？

我们全体开发仔细盯了盯然后思考了一下，这个网站不是我们的啊。然后开始研究了这个网站，发现这个网站就是用 `iframe` 嵌入了我们的网站。"

就是下面这种代码

```html
<iframe title="****" src="https://www.****.com/****.html" height="100%" width="100%" frameborder="0"></iframe>
```

这是个大问题啊，万一误导客户以后这类似的网站做一些钓鱼的链接把我们的名声搞坏就不得了了。要想办法杜绝这种类似的问题。

## 正文

后面想到用 Response Header 头来解决这个问题，就是增加一个 `X-Frame-Options` 的头信息
```shell script
X-Frame-Options: deny

X-Frame-Options: sameorigin

X-Frame-Options: allow-from https://example.com/
```


- deny：表示该页面不允许在 frame 中展示，即便是在相同域名的页面中嵌套也不允许。
- sameorigin：表示该页面可以在相同域名页面的 frame 中展示。
- allow-from URI 表示该页面可以在指定来源的 frame 中展示。

具体其他的描述可以看 [X-Frame-Options 资料](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/X-Frame-Options)

在代码中写 `Header` 头和在 `nginx` 里面增加请求头我们选择了后者。

后面再 Nginx 里面的 的 http 里面增加了一个 `add_header X-Frame-Options: sameorigin` 后面 `reload` 了 `nginx` 后发现怎么都不管用，在本地就有用。

后面又回到了无聊的翻 `nginx` 文档的时候。翻到了下面这句话。

> There could be several add_header directives. These directives are inherited from the previous level if and only if there are no add_header directives defined on the current level. 

大致意思就是，**如果当前级别没有定义 add_header 则会继承上一级，如果定义了 add_header 则不会去理会上一级。**

如果这句话看不懂，下面我们来看下面的例子。

下面在响应中返回头信息包含什么？

- 1、
```
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    add_header A aa
    server {
        ...
        add_header B bb
    }
}
```
- 2、
```
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    add_header A aa
    server {
         ...
         location ~
         {
            add_header C cc
         }
    }
}
```

- 3、
  
```
http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  add_header A aa
  server {
     ...
     add_header B bb
     ...
     location ~
     {
        add_header C cc
     }
  }
}
```

- 答案：

1、请求头上会增加  B aa 把  A aa 放弃。

2、请求头上会增加  C cc 把  A aa 放弃。

2、请求头上会增加  C cc 把  A aa 和 B bb 放弃。

这个坑就是 Nginx 的继承的一个特性，当子层级设置了 `add_header`，会直接不使用父级的 `add_header`。

同样的指令还有 `add_trailer` 和 `expires`

想了解更多可以[Module ngx_http_headers_module](http://nginx.org/en/docs/http/ngx_http_headers_module.html)

## 总结

还是得多看文档啊。
 