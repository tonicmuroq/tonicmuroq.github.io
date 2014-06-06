---
layout: post
title: Objective-C
category: blog
---

其实似乎是两年前就开始想学习 iOS/Mac 开发的, 断断续续拖拖停停的至今都没有学会. 究其原因我觉得是因为 UI 那里太难搞了... 似乎我到现在都是不会写跟 UI 相关的东西. 比如客户端, 比如前端页面什么的... 其实页面可以写, 就是丑... Xcode 里提供的 Interface Builder 实在是很难理解, 也可能因为我从来没有尝试去理解. 什么 IBOutlet, IBAction 这些东西, 嗯直接丢这里真的是不好理解. 而且各种动作拖来拖去也很复杂...

不过没关系, 已经不准备去理解他们了... 因为我有了新的方法! 那就是直接在代码里写 UI, 不再跟可怕的 storyboard 打交道了!

经过土豪哥一下午的指点, 大概算是明白了一些原理了. 可以写出这样的代码了:

```objc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button setTitle:@"点我" forState:UIControlStateNormal];
    [_button setFrame:CGRectMake(20, 200, 80, 40)];
    [_button setTag:1];
    [_button addTarget:self
                action:@selector(buttonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
        
    UIButton *info = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [info setTitle:@"别点我" forState:UIControlStateNormal];
    [info setFrame:CGRectMake(100, 200, 80, 40)];
    [info setTag:2];
    [info addTarget:self
             action:@selector(buttonClicked:)
   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:info];
        
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 300, 160, 30)];
    [slider addTarget:self
               action:@selector(progress:)
     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
        
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 400, 80, 40)];
    [label setText:@"00.00"];
    [label setTag:1000];
    [self.view addSubview:label];
}

```

顺便还学习了一下 `CGRectMake` 这样的内联函数的用法, 果然比起 Swift 来我还是更加喜欢 Objective-C, 觉得有一种恶心的性感, 而不是 Swift 那种怪异的性感...

下好了 Xcode6, 准备装一个试试, 据说 5 和 6 可以隔离环境了, 那么我可以直接安装俩了. 一会装好了试试 Swift.

晚上吃烤羊腿的时候大家又说你能不能别走了... 其实没有想过居然真的有人会想留我, 一直觉得我是个很讨人厌的人才对... 我其实也真的很不想走, 离开了豆瓣可能永远也无法有如此好的环境和如此好的队友了. 可是想到一些其他的事情, 人有的时候还是得自私一把的... 唉, 一声叹息...
希望在豆瓣的各位幸福! 希望我离开了也还有豆瓣的老师! T_T

(我为什么突然写这种让我很伤感的东西呢... 整个人都不好了... ><)
