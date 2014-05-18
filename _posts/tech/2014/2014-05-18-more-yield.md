---
layout: post
title: 更加进阶的 Generator
category: tech
tags: tech python
---

我了个擦, 我可能是凌晨三四点才睡着, 早上一大早又爬了起来... 昨天晚上看幺蛾子代码真是越看越来劲, 结果睡觉的时候都一直是 yield this, yield that 的. 今天晚上又会有失眠恐惧了, 唔, 不要给自己睡觉的压力...

好吧昨天说到了更加进阶的 generator, 我们来看看有没有什么更有意思的玩法.

### Coroutine Pipelines

这其实是引用的[教授](http://www.douban.com/people/hongqn/)的原话. 我们来看一个简单的管道吧.

```python
def source(target):
    target.next() # evquivalent to target.send(None)
    for d in data:
        target.send(d)
    target.close()

def filter(target):
    target.next()
    try:
        while 1:
        data = yield
        data = process(data)
        target.send(data)
    except GeneratorExit:
        target.close()

def sink():
    while 1:
        data = yield
        data = process(data)
        do_something_to_write(data)

source(filter1(filter2(filter3(sink()))))
```

你看, source 源源不断地发数据给 filter1, filter1 处理完了发给 filter2, 以此类推到最后的 sink, 完成整个管道操作. 这么写有个缺点其实是... 代码有点丑(这尼玛不就是函数式编程的样子么! 竟敢说它丑!), 不太方便. 于是推荐一个有意思的库, [Pipe](https://github.com/JulienPalard/Pipe).

看看代码会发现他的实现其实也很有意思. 基本上就是每个函数其实都被装饰成了一个类, 这个类实现了 `__ror__` 和 `__call__` 方法, 对这个类的运算重载了 `|` 操作符, 让代码写起来更顺畅.

```python
class Pipe(object)

    def __init__(self, function):
        self.function = function

    def __ror__(self, other):
        return self.function(other)

    def __call__(self, *args, **kwargs):
        return Pipe(lambda x: self.function(x, *args, **kwargs))

@Pipe
def take(iterable, qte):
    "Yield qte of elements in the given iterable."
    for item in iterable:
        if qte > 0:
            qte -= 1
            yield item
        else:
            return

@Pipe
def concat(iterable, separator=", "):
    return separator.join(map(str,iterable))

>>> (1, 2, 3, 4, 5) | take(2) | concat
'1, 2'
```

这里其实最左边的就是 source, 只不过不是由他主动 `send` 给 filter, 而是 filter 来拿他的数据, 最后的 concat 就类似一个 sink 了.

另外还可以做基于文件描述符的 coroutine. 例如:

```python
def co_sendto(f):
    try:
        while 1:
            item = yield
            pickle.dump(item, f)
            f.flush()
    except StopIteration:
        f.close()

def co_recvfrom(f, target):
    try:
        while 1:
            item = pickle.load(f)
            target.send(item)
    except EOFError:
        target.close()
```
f 可以是一个 pipe, 可以是一个 unix socket 等, 用法可以是

```python
type_fd_mapping = {
    type1: fd1,
    type2: fd2,
    type3: fd3,
}

def sender():
    for d in data:
        f = type_fd_mapping[get_data_type(d)]
        co_sendto(f)

# g1, g2, g3 是三个filter
co_recvfrom(fd1, g1)
co_recvfrom(fd2, g2)
co_recvfrom(fd3, g3)
# 三个filter最后sink成结果
```

不过其实一般不会自己去写这样的 coroutine, 因为实在太多现成的库了... [Greenlet](https://github.com/python-greenlet/greenlet), 以及基于他的[gevent](http://www.gevent.org/), [eventlet](http://eventlet.net/), [concurrence](http://opensource.hyves.org/concurrence/)等. 轻松用同步思维写异步代码, 实乃居家旅行杀人放火必备良品!

--------------

肚子饿了, 准备去做饭吃了... 

可能会再写一个 Python magic method 的东西, 这些东西真的是又爱又恨...
