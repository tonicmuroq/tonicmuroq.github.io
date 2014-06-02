---
layout: post
category: blog
title: Magic Method
---

啊上次说要写个 Python 的 magic method 的东西的, 刚好刚刚睡醒什么都不想做, 脑子里一片空白, 写这个好了...

* 首先最熟悉的, 应该是 `__init__` 了. 每个开始写 Python 的人都会无数次的用到它. 它是做什么的呢? 初始化一个对象的实例. 比如:

    ```python
    class WTF(object):

        def __init__(self):
            self.a = 'a'
            self.b = 'b'
    
    w = WTF()
    print w.a # a
    print w.b # b
    ```

* 然后会想到, `__init__` 是不是就是构造函数了呢? 其实不是的... 真正负责新建一个实例的方法是 `__new__`. 比如:

    ```python
    class A(object):
        
        def __new__(self, *a, **kw):
            print 'new called'
            print a
            print kw
            return super(self, A).__new__(self, *a, **kw)
    
        def __init__(self, a, b):
            print 'init called'
            self.a = a
            self.b = b
    
    In [1]: a = A(3, b=4)
    new called
    init called
    (3, )
    {'b': 4}
    
    In [2]: a.a
    Out[2]: 3
    
    In [3]: a.b
    Out[3]: 4
    ```

    啊, 所以其实是实例化一个类的时候会调用 `__new__`, 并且把参数传给 `__init__` 再调用一次. 也就是 `c = A(*a, **kw)` 等价于 `c = A.__new__(*a, **kw)` + `c.__init__(*a, **kw)`

    稍微改一下可以实现单例模式, 虽然其实 Python 里单例并不需要这么复杂... 比如这样:

    ```python
    class A(object):

        __instance = None

        def __new__(self, *a, **kw):
            if not self.__instance:
                self.__instance = super(self, A).__new__(self, *a, **kw)
            return self.__instance
    In [1]: a = A()
    In [2]: b = A()
    In [3]: a is b
    Out[3]: True
    ```

    不过还是少搞这种幺蛾子为好¬ ¬

* 既然 init 和 new 都有了, 那么也少不了 `__del__`, 不过这里有一点是, `del xxx` 并不会调用 `xxx.__del__()`, 后者的调用是在引用计数为0的时候, 另外这个里面最好不要再跟 `self` 这个变量挂钩了, 很可能这时候 `self` 已经被 gc 了. 其实我没玩过这个方法, 一般都比较信赖系统自己的 gc...

* `__str__` 和 `__repr__`. 分别被 `str` 和 `repr` 调用. 在 `print` 的格式化串中他们分别为 `%s` 和 `%r`.
    官方对 `__repr__` 的定义是, 它应该返回一个合法的 Python 表达式, 如果不是一个表达式, 那么需要返回一个格式为"<...有效信息...>"的字符串. 这个表达式可以通过 `eval` 求值再次得到这个实例. 也就是说 `o == eval(repr(o))` 在 `__repr__` 返回表达式的时候应该成立. 例如:

    ```python
    class A(object):
        
        def __repr__(self):
            return 'repr'

        def __str__(self):
            return 'str'
    In [1]: a = A()
    In [2]: a
    Out[2]: repr
    In [3]: print a
    Out[3]: str
    In [4]: print '%s' % a
    Out[4]: str
    In [5]: print '%r' % a
    Out[5]: repr
    ```

* 然后是一些比较大小的方法... 有:

    ```python
    object.__lt__(self, other)
    object.__le__(self, other)
    object.__eq__(self, other)
    object.__ne__(self, other)
    object.__gt__(self, other)
    object.__ge__(self, other)
    object.__cmp__(self, other)
    object.__hash__(self, other)
    ```

    上面那些字面意思已经很明白了, 他们分别被<, <=, ==, !=或者<>, >, >=调用. 返回值是True/False.

    `__cmp__` 稍微不同点, 如果 `self < other`, 返回负数; 如果 `self == other`, 0; `self > other`, 正数. 其实跟 C/C++ 里的 cmp 函数差不多.

    `__hash__` 被 `hash` 调用. 当有需要求哈希值的时候, 他都会被调用, 比如往一个 set 或者 dict 里塞的时候. 返回值是一个整数. 所以我们现在有好几个方法判断俩实例是不是相等了. 可以实现eq方法, 可以实现cmp, 也可以实现hash. 不过其实一般情况下我们用系统帮我们生成的就好了...

* 自定义的属性方法, 有:

    ```python
    object.__getattr__(self, name)
    object.__getattribute__(self, name)
    object.__delattr__(self, name)
    ```

    他们分别被 `getattr`, `setattr`, `delattr` 调用. 也就是我们的表达式里的 `x.y`, `x.y = 1`, `del x.y`.

    `__getattr__` 只有在属性没有被正常方式找到的时候才被调用. 之后会提到属性的查找顺序...

    `object.__setattr__(self, name, value)` 是一个更加强的属性查找方法, 如果定义了这个, 那么 `__getattr__` 就哭瞎了, 不仅它哭了, 其他的查找方式都哭瞎了... 因为丫是最高优先级拦截的. 所以一般情况下我们不需要定义这个方法, 如果定义了, 要注意这个方法内不能有任何 `self.xxx` 的表达式, 否则很快爆栈了... 要使用 `object.__getattribute__(self, name)`

* Descriptor:

    ```python
    object.__get__(self, obj, obj_type)
    object.__set__(self, obj, value)
    object.__delete__(self, obj)
    ```

    定义这三个方法的就是一个 descriptor 啦. 要说这个... 可以扯到更多的东西上... 比如 unbound method 和 bound method, 以及方法的调用, 和那个神奇的 `self` 参数, 还有 `@classmethod`, `@staticmethod`, `@property`, `@xxx.setter` 之类的装饰器... 啊又犯懒了, 先不写这些了. 大概就简单说下吧.

    如果一个类A定义了至少是 `__get__` 的描述符方法, 那么丫就是一个描述符. 那么如果A的实例a被某实例的属性查找的时候命中了(不能是在实例的 `__dict__` 里), 那么这时候会去调用 `a.__get__`. 代码说就是这样:

    ```python
    class A(object):
        def __get__(self, obj, obj_type):
            print obj, obj_type
            return 'x'

    class B(object):
        a = A()

    class C(object):
        def __init__(self):
            self.a = A()
    ```

    上面的代码, A 就是一个描述符. 只有 B 里的描述符才会起作用. 当我们说 `B().a` 的时候, 其实是 `a.__get__(B(), B)` 酱, 而 `C().a` 只是简单返回了 `a`. 啊说到这里又要说那个属性查找顺序了. 那么实际上, 在一个o里查找属性n, 顺序是是酱的:

        1. __getattribute__
        2. o.__dict__
        3. type(o).__dict__ 也就是 O.__dict__
        4. O 的父类的 __dict__
        5. __getattr__

    从第三步开始, 如果找到的是一个至少实现了 `__get__` 方法的描述符, 那么会调用描述符而不是简单返回属性.
    嗯这也是为什么 `__getattribute__` 那么猛了... 还是少碰这种奇异的生物的好¬ ¬

    哦刚刚还说方法绑定什么的, descriptor 的用法和特性一搜一大把, 我就不瞎逼逼了... 其实就是我懒了... 写起来真的好累的好么!

* slots. `__slots__` 这属性可以节省你大把的内存! 当一个实例挂什么属性上去的时候, 会在 `__dict__` 里写一个记录. 这尼玛也是要内存的啊! 如果你定义了 `__slots__`, 那么你只能往实例上挂slots里的属性. 同时也不生成 `__dict__` 了. 你可以写个只有一个属性的类, 用slots和不用的区别是, 一个用 `sys.getsizeof` 出来是56, 一个是64. 如果你有大量这样的实例, 同时属性又不会随意乱挂, 那么slots是你最佳选择, 省好多内存的哪! 你看是不是巨小气会过日子! 其实就是穷, 买不起服务器的表现... (已哭瞎...)

* state. `__getstate__` 和 `__setstate__`, 被 pickle 的时候会调用 `__getstate__`, 而在 unpickle 的时候会调用 `__setstate__`, 对于需要自定义哪些要序列化哪些不要序列化的场景有很好的效果. 有些地方可能比较穷, memcache 都没多少内存可以用, 那么就只把需要丢缓存的东西给用state来返回, 反序列化的时候恢复回来...

擦我真的没动力写下去了... 本来脑子就一片空白还想睡觉, 写了半天居然还有那么多的 magic method 没写... 已经弃坑, 留个[链接](https://docs.python.org/2/reference/datamodel.html)想看的自己去看吧¬ ¬ 按顺序看下来真的是可以看到我失去了耐心... 谁 tm 要 Python 那么多 magic method 的我日... 嗯算了, 反正会的人就是会了, 不会的人怎么写怎么看也不会... 这么一想开心多了, 安心弃坑!

饿了都... 觅食去...
