---
layout:  post
title:   第一篇
category:  blog
description:  我以前其实没写过
tags:  blog
---
###以前写过的都不算哦

我其实是一个很懒的人, 写blog这种事情其实不太适合我, 这里自然地想黑一下那个"note is better for me than blog"(请自行脑补翻译成中文)... 但是昨天看到郭大侠的博客主题那么好看, 觉得用他的主题挂一个博客在github也不是什么坏事. 于是就有了这个博客.

既然使用的是github对吧, 第一件事情就是想试试我写的markdown是不是用github的方言来解释的.
于是我写下了

    ```python
    '''我只是看看这里是不是按照github的md方言解析的'''
    def function(a, b):
        return a + b
    ```
发现结果并不如我所愿.

去翻了一下郭大侠的代码, 才发现高亮需要在markdown里写jinja标签:

```
  {% raw %}
  {% highlight python %}
  '''我只是看看这里是不是按照github的md方言解析的'''
  def function(a, b):
      return a + b
  {% endhighlight %}
  {% endraw %}
```
于是得到了这个结果...

```python
'''我只是看看这里是不是按照github的md方言解析的'''
def function(a, b):
    return a + b
```
{% raw %}
但是我依然不死心, 怎么能那么快放弃[GFM](http://github.github.com/github-flavored-markdown/)而用一直不喜欢的jinja呢! (嘘其实我要解释一下, 我不喜欢jinja仅仅因为不喜欢他的"{%%}", 又总不好去改成自己的...) 于是我找到了另外一个介绍使用redcarpet做markdown parser的文章. 按照文章说明改了改, 结果就出来了.

现在我可以放心输入

    ```python
    ```
来高亮语法了...
{% endraw %}

所以说到现在, 我都依然是在说一些跟代码相关的东西, 我是不是太无聊了...

希望可以写下去这个.
