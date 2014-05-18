---
layout: post
title: 各种变态的程序写法
category: tech
tags: abnormal tech
---

这里可以看到程序的各种奇葩/变态/处女座的写法, 欢迎投稿!

* import 对齐困难

    大家这么写:
    
    ```python
    import sys
    sys.path.insert('/var/shire')
    from datetime import datetime
    from xxx.model.yyy import Yyy
    ```
    
    有些奇葩会觉得那个 `sys.path.insert` 把 import 给隔开了... 于是他会这么写:
    
    ```python
    __import__('sys').path.insert('/var/shire')
    from datetime.import datetime
    from xxx.model.yyy import Yyy
    ```
    
    看, 所有的 import 都在一起了! 同理还有:
    
    ```python
    # 这样写
    __import__('gevent.monkey').patch_all()
    import socket
    
    # 而不是这样写
    import gevent
    gevent.monkey.patch_all()
    import socket
    ```
    
    是不是很难受呢! 处女座们来吧!

* 更高级的 import 强迫症

    大家这么写:

    ```python
    from flask import Flask, url_for, g, request
    ```

    有些变态觉得我靠这没对齐啊, 好难受哦, 他会写成这样:

    ```python
    from flask import g
    from flask import request
    from flask import url_for
    from flask import Flask
    ```

    看, 按照字典顺序哦, 小写在大写前面哦!

欢迎指出更多变态写法!
