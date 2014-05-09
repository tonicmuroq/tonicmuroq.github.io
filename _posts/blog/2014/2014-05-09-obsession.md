---
layout: post
title: 强迫症还是什么?
category: blog
tags: 强迫症
---

作为一个细节癖或者说是强迫症患者, 有些事情不做到想要的效果就很难受, 虽然最后大部分时间我都会告诉自己, 你是一个正常人, 你是一个普普通通的正常人, 你不要因为这些你无法改变的事情而难受. 哦许多时候恰恰是因为我自己认为我可以改变, 所以我才烦恼才难受. 比如今天.

一直觉得自己博客里的代码块很丑, 于是换了个豆瓣的CODE使用的CSS, 换了我喜欢的Panic Sans字体, 字号调到了我在CODE里用的12px. 然后郭大侠和lepture来留言了, 说字太小而且挤在一起很难看. 于是我想到了flask的那些read-the-docs的样式, 比如[这里](http://flask-restful.readthedocs.org/en/latest/quickstart.html#a-minimal-api).
看了看页面结构, 把CSS给拿了出来. 本地改了改字体, 没看出来Menlo和Panic Sans有什么区别(可是我真的记得他们区别还蛮大的... 可能我本地不太对... 谁要我前端知识匮乏...), 于是就开开心心地上了. 然后呢, 就真的看出了区别.

对比上面给的那个restful:

```python
from flask import Flask
from flask.ext import restful

app = Flask(__name__)
api = restful.Api(app)

class HelloWorld(restful.Resource):
    def get(self):
        return {'hello': 'world'}

api.add_resource(HelloWorld, '/')

if __name__ == '__main__':
    app.run(debug=True)
```

你就会发现... 字就是细了那么一点点!!!

<img src="http://muroq.qiniudn.com/emotion-%E6%88%91%E4%B8%8D%E8%A6%81%E5%90%AC.jpg" alt="啊啊啊!" style="width:200px;" class="center"/>

我了个擦啊完全不能忍这样的情况!!

这样原本圆润完美的字体就变瘦了!! 变瘦了就好像变得势单力薄了!! 这样写出来的代码感觉也无法正确运行的样子啊!!!

完全不能忍!! 于是去修改`font-weight`, 手发颤地加了个样式`font-weight: bold;`. 我了个擦! 怎么整个样子全部变粗了! 而且`print`之类的关键字并没有更粗! 那么我更加小心翼翼地改成了`bolder`, 啊哈哈哈哈根本没有区别! 我已经开始怀疑是不是我偷来的CSS哪里做了什么手脚¬ ¬ 
去搜了下`font-weight`的取值, 发现还可以取整数的. 于是我从100开始尝试, 从100到599都没有任何改变, 到了600的时候一下子变bold了. 好可怕啊!!!

<img src="http://muroq.qiniudn.com/emotion-%E6%88%91%E4%B8%8D%E8%A6%81%E5%90%AC.jpg" alt="啊啊啊!" style="width:200px;" class="center"/>

这个时候已经在告诉我自己要放弃了... 

放弃吧你并不是一个前端你搞不定这样的乱七八糟的幺蛾子的...

您猜怎么着? 我真放弃了. 我才不管他粗不粗细不细了, 我又一次地告诉自己, 你只是一个正常人, 你只是一个普普通通的正常人, 你不要因为这些你无法改变的事情而难受.

嗯我现在开心多了!

<img src="http://muroq.qiniudn.com/emotion-alu-laugh.jpg" style="width:100px;" class="center"/>

另外我也不觉得我有强迫症.
