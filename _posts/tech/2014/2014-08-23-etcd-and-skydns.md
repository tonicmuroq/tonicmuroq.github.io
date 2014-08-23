---
layout: post
category: blog
title: etcd 和 skydns
tags: docker tech
---

围绕着 docker 出了一大批奇怪的幺蛾子项目, 说是幺蛾子真的一点都不为过... 可是这些幺蛾子却又那么好用... 于是只好忍痛来踩坑了...

----

###etcd

这货是一个 go 写的 key-value 的数据库, 看名字就知道了, 是拿来存配置文件的, 是一个分布式的 /etc. 你的所有的文件都可以存在这里面, 对应的还有几个工具, [**etcdctl**](https://github.com/coreos/etcdctl) 以及 [**etcd-fs**](https://github.com/xetorthio/etcd-fs), 这俩一会再介绍.

key-value 数据库我们是用多了, 也踩过很多坑了. 从 MongoDB 的丢数据, 到 Redis 的 AOF 丢最后一次保存后的数据, 到 BeansDB 时不时的丢数据(好黑...), 都已经快绝望了. 可是又不能不用吧, 那么既然这里没有人会维护 BeansDB, 又不想用搓逼 MongoDB, Redis 又不打算拿来持久化, 那就试试这个可怕的 etcd 吧.

etcd 的项目地址在[这里](https://github.com/coreos/etcd). 是的丫也是 coreos 一个体系里的东西. 我们可以直接在[这里](https://github.com/coreos/etcd/releases/)获取编译好的可执行文件, 也可以自己 clone 代码 然后 `go build`. 嗯现在我们有可执行文件了, 那么就开始搭建一个集群吧.

etcd 的集群似乎有点奇葩, 粗略看下文档好像是有两种方式来建立.

1. 启动的时候指定 `-peers`
2. 启动的时候指定 `-discovery`

嗯第二种我其实至今也没明白到底是怎么搞的, 可能需要去翻翻他们的源码, 因为他们写的文档实在是太可怕了, 似乎是一群写代码很牛逼但是基本没办法说人话的人写的... 那我们就试试第一种方法吧. 指定 `-peers` 需要第一个启动那货是leader (别问我为什么不是第一个被加入的 leader, 我也不知道这群 geek 是怎么想的), 所以丫的启动命令跟剩下的不一样:

    $ ./etcd -peer-addr 127.0.0.1:7001 -addr 127.0.0.1:4001 -data-dir machines/machine1 -name machine1
    
看, 他是没有指定 `-peers` 的, 余下其他的需要加上这个参数, 比如:

    $ ./etcd -peer-addr 127.0.0.1:7002 -addr 127.0.0.1:4002 -peers 127.0.0.1:7001,127.0.0.1:7002,127.0.0.1:7003 -data-dir machines/machine2 -name machine2
    $ ./etcd -peer-addr 127.0.0.1:7003 -addr 127.0.0.1:4003 -peers 127.0.0.1:7001,127.0.0.1:7002,127.0.0.1:7003 -data-dir machines/machine3 -name machine3
    
这样这三个家伙就组成了一个集群. 我们可以直接看看集群有多少机器:

    $ curl -L http://127.0.0.1:4001/v2/machines
      http://127.0.0.1:4001, http://127.0.0.1:4002, http://127.0.0.1:4003
    $ curl -L http://127.0.0.1:4001/v2/leader
      http://127.0.0.1:7001
      
写入集群很简单, etcd 的 API 都是 RESTful 的:

    $ http -f PUT http://127.0.0.1:4001/v2/keys/foo value=bar
    
    {
        "action": "set",
        "node": {
            "createdIndex": 4,
            "key": "/foo",
            "modifiedIndex": 4,
            "value": "bar"
        }
    }
    
还没有完全研究, 不过我发现似乎是一个类似主从的结构, 只能往 leader 里写入, 但是由于底下的 raft 来保证强一致性, 从所有节点读取的数据都是相同的. 至于第二种自发现的方式, [这里](https://github.com/coreos/etcd/blob/master/Documentation/cluster-discovery.md)有写文档, 不过可能我智商太低, 按照他写的命令输入都没有成功... 于是就用了自己指定 `-peers` 的方法来启动集群.

---

###让 etcd 运行在 container 里

coreos 另外个奇葩的地方就是他提倡所有东西都运行在 docker container 里, 嗯这不是废话么, 丫就是拿来支持 container 的啊... 于是我在运行过程中踩了几个坑...

1. 跑 container 里似乎没办法搭建集群?

    其实并不是这样的... 我 google 了一下, 发现[这个奇葩文档](https://coreos.com/blog/Running-etcd-in-Containers/)其实有介绍怎么运行在 container 里. 嗯运行在 container 里的 `peer-addr` 和 `addr` 都必须是宿主机的 IP. 我也不明白为什么是这样, 可能因为建立集群的时候他们用这个信息来作为身份标识吧(也可能真的得翻翻源码), 更改成宿主机 IP 后问题解决了

2. 跑 container 里的时候说 connection refused 之类的奇怪问题?

    嗯其实这里似乎又是另外个坑. 每次启动的时候得保证还是用的上次的端口和地址, 否则丫会去读自己目录下的 log 文件, 然后尝试使用上一次的配置. 所以如果你第一次尝试失败了, 最好把整个 `-data-dir` 指定的目录全部清空一次再来第二次尝试. 我其实也不知道这个 log 文件是不是丫的 binlog, 虽然觉得应该不是, 但是为什么从日志看他会用上一次启动的参数呢, 难道不应该是我手动指定的参数优先级最高么... 可能真的需要看看源码, 应该不是我这样的理解...

---

###etcdctl 和 etcd-fs

这俩其实就是好用的工具了. etcdctl 的话, 可以让你不需要再输入类似

    $ http -f PUT 127.0.0.1:4001/v2/keys/xxx value=wawawa
    
这样的命令了(好想说这还是人类用的, 用 curl 只会更加痛不欲生), 你只需要

    $ etcdctl set /xxx wawawa
    
就可以了. 其他支持的命令有 `mk`, `mkdir`, `update`, `get`, `ls`, `rm`, `rmdir` 等.

嗯你可能觉得这样已经很好用了, 但是, 稍等, 还有个更加 NB 的 etcd-fs. 这货可以用 fuse 挂载一个本地的挂载点到整个 etcd 集群! 用起来就好像就是在一个文件系统里一样自然(有没有想到 BeansDB 和 BeansFS 啊嘿嘿).

    $ ./etcd-fs /tmp/xxx http://127.0.0.1:4001
    
那么 etcd 就被挂载到了 `/tmp/xxx`, 然后你进去, 随意 ooxx 丫...

---

###skydns

这是一个好项目, 真的很好... 地址在[这里](https://github.com/skynetservices/skydns). 这是一个依赖 etcd 的 DNS 服务. 当你在 etcd 的某个约定好的路径下写入了对应的 A 记录或者 CNAME 这些之后, 他就可以帮你解析了.

启动的方法非常简单, 用 `-machines` 参数指定或者写 `ETCD_MACHINES` 的环境变量告诉他 etcd 在哪里就行:

    $ export ETCD_MACHINES='http://127.0.0.1:4001,http://127.0.0.2:4002'
    $ ./skydns -addr="0.0.0.0:53" -domain="intra.hunantv.com" -nameservers="8.8.8.8,8.8.4.4" -rcache=1024

约定好的路径就是指你需要解析的地址给反过来, 然后把 . 改成 /, 然后这些都挂在 skydns 这个目录下, 也就是比如 nbetest.intra.hunantv.com 是指向 10.1.217.164 的, 那么直接

    $ etcdctl set /skydns/com/hunantv/intra/nbetest '{"host": "10.1.217.164"}'
    
设置的值是一个 JSON, 除了 host 是必须的外, 还有很多可选的值, 比如 `priority`, `weight`, `ttl` 之类的, host 如果写一个 IP, 那么就认为是一个 A 或者 AAAA 记录, 如果写一个域名, 就认为是一个 CNAME, 很好理解的. 同时 skydns 的配置也可以直接写在 etcd 里, 在 `/skydns/config` 里, 另外要注意的是, 这里 etcd 里的配置是优先级最高的, 而不是手动指定的.

我们来试试结果:

    $ dig @127.0.0.1 nbetest.intra.hunantv.com

    ; <<>> DiG 9.8.3-P1 <<>> @127.0.0.1 nbetest.intra.hunantv.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 25797
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
    
    ;; QUESTION SECTION:
    ;nbetest.intra.hunantv.com.	IN	A
    
    ;; ANSWER SECTION:
    nbetest.intra.hunantv.com. 3600	IN	A	10.1.217.164
    
    ;; Query time: 8 msec
    ;; SERVER: 127.0.0.1#53(127.0.0.1)
    ;; WHEN: Sat Aug 23 15:26:19 2014
    ;; MSG SIZE  rcvd: 59

是不是很赞...

skydns 运行在 docker 里也是比较简单的, 只是要注意暴露端口的时候需要把 53 端口的 tcp 和 udp 协议都暴露出来. 这样:

    $ docker run -d -p 53:53/tcp -p 53:53/udp --name="skydns_53" -e ETCD_MACHINES="http://127.0.0.1:4001,http://127.0.0.1:4002,http://127.0.0.1:4003,http://127.0.0.1:4004,http://127.0.0.1:4005" nbeimage/skydns -addr="0.0.0.0:53" -nameservers="222.246.129.80:53,59.51.78.210:53" -rcache=1024 -domain="intra.hunantv.com"
    
就搞定了.

啊对了, 要补充下, etcd 居然还可以拿来做分布式锁... 真是爱死了 ><

最后再啰嗦几句, 这些东西都是建议运行在 container 里的, 所以默认都没有提供一个 daemon 模式, 所以如果你想用 daemon 又不想丢 container 里, 那么建议用 supervisord 之类的工具来管理, 或者一个叫 [godaemon](https://github.com/fiorix/go-daemon) 的工具来管理 go 写的进程, 其实这样的程序一抓一大把... ¬ ¬
