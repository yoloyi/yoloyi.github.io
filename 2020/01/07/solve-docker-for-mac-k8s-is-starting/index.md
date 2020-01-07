# 【坑】Docker for MAC 中一直 Kubernetes is starting，不能正确开启


<!--more-->

## 开启 Docker Desktop Kubernetes 坑

点击 `Docker` 图标，选择 `Preferences... > Kubernetes` 进入 `Kubernetes` 配置页：

![k8s start](/images/posts/k8s_is_running.png)

点击 Enable Kubernetes 后，等待了大半个小时，右下角一直展示 `Kubernetes is starting`，就是开启不了。

找了一圈的原因，发现在 开启 `K8S` 后需要拉取一些镜像。因为国内网络的问题，拉取不下来。

后面用了 `阿里镜像` 来代替 `Docker` 默认的镜像。

阿里的镜像有一个坑，就是必须要注册后才能使用。

替换好了之后，`Restart` 和 `Rest Kubernetes cluster`  重启了一下，又等了几个小时，发现还是打开不了。

## 解决方法


又继续找问题啊。

后面在 `docker/for-mac` 仓库的 [ISSUE](https://github.com/docker/for-mac/issues/2990) 里面找到了解决办法。

![solver](/images/posts/k8s-solver.png)

执行：

```shell script
# rm -rf ~/Library/Group\ Containers/group.com.docker/pki/
# rm -rf ~/.kube
```

成功开启。

![waiting](/images/posts/waiting.jpeg)



