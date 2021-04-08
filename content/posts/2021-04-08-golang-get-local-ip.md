---
title: "Golang 获取主机网卡IP"
date: 2021-04-08T11:44:41+08:00
draft: false
description: "Golang 获取主机网卡IP"
show_in_homepage: true
show_description: true
license: ''

tags: ["Golang", "微服务"]
categories: ["Golang"]

featured_image: ''
featured_image_preview: ''

comment: true
toc: true
autoCollapseToc: true
math: false
---

在微服务中，服务注册里面会把服务的一些基本信息，如 `IP`，`Port`，`Name` 发送到注册中心内保存起来。
在Api Gateway 调用某些服务的时，在注册中心内取该服务下该服务所有注册的IP、端口然后尝试链接。那么我们如何获取主机IP呢？

## 代码

```golang

package main

import (
	"log"
	"net"
	"strings"
)

func main() {
	localIp := getLocalIpV4()
	log.Println("主机当前IPv4 ", localIp)
}

// getLocalIpV4 获取 IPV4 IP，没有则返回空
func getLocalIpV4() string {
	inters, err := net.Interfaces()
	if err != nil {
		panic(err)
	}
	for _, inter := range inters {
		// 判断网卡是否开启，过滤本地环回接口
		if inter.Flags&net.FlagUp != 0 && !strings.HasPrefix(inter.Name, "lo") {
			// 获取网卡下所有的地址
			addrs, err := inter.Addrs()
			if err != nil {
				continue
			}
			for _, addr := range addrs {
				if ipnet, ok := addr.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
					//判断是否存在IPV4 IP 如果没有过滤
					if ipnet.IP.To4() != nil {
						return ipnet.IP.String()
					}
				}
			}
		}
	}
	return ""
}

```

