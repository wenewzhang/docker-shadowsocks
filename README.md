# docker-shadowsocks

[shadowsocks-libev][]服务器端的docker容器镜像构建，[Docker Hub][hub]。

shadowsocks-libev 版本: 3.0.6

镜像tag即表明其运行的shadowsocks-libev版本。

### 使用

通过设定环境变量来改变ss-server的运行参数

```
docker run -d --env SS_PWD=MY_PASSWORD -p 8388:8388 jinnlynn/shadowsocks
```

可配置的环境变量及其默认值

```
SS_ADDR     0.0.0.0
SS_PORT     8388
SS_PWD
SS_METHOD   aes-256-cfb
SS_TIMEOUT  300
SS_DNS      8.8.8.8
SS_DNS2     8.8.4.4
```

密码： SS_PWD默认为空，如果未指定将随机生成。

一般情况下只要设置SS_PWD即可。

`docker logs <CONTAINER_ID>`可以查看当前运行的配置信息

[shadowsocks-libev]: https://github.com/shadowsocks/shadowsocks-libev
[hub]: https://hub.docker.com/r/jinnlynn/shadowsocks/
