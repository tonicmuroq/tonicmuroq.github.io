---
layout: post
title: 我们来试试传图吧!
category: blog
tags: photos
---

准确说是前天开始考虑压图上传的. PhotoShop 的安装太过麻烦(呵呵其实就是破解起来麻烦, 我买不起正版 T^T), 于是放弃了这个; 美图秀秀更加是不可以考虑的, 实在是... 降低档次. 于是找到了这么个软件: JPEGmini, 他的 logo 是一个 Diet 可乐, 哈哈就是说给相片瘦身啦! AppStore 里搜了下, 发现有免费的 JPEGmin Lite 版本, 对我这种穷人来说简直如获至宝, 赶紧装上试用.

发现图片压缩之后清晰度下降得挺厉害的, 可能本来也是吧, 一张 10MB 的图片压缩成 500KB, 损失肯定是相当的大的. 不过再怎么说这也比我自己装一个 `PIL` 来压图的好. 嗯其实另外个原因是 `PIL` 压图那个真的惨不忍睹, 压得颜色都变了...

<img src="https://raw.githubusercontent.com/tonicbupt/tonicbupt.github.io/master/images/pic/photo%E6%88%90%E9%83%BD%E9%94%A6%E9%87%8C%E5%9C%B0%E4%B8%8A%E7%9A%84%E6%96%87%E5%AD%971.jpg" style="width:720px;" class="center"/>
<p class="center">锦里. 边上阁楼上的灯光投影下来的文字. 看着昏暗的光线其实挺有意思.</p>

<img src="https://raw.githubusercontent.com/tonicbupt/tonicbupt.github.io/master/images/pic/photo%E6%88%90%E9%83%BD%E9%94%A6%E9%87%8C-%E5%8F%B0%E7%81%AF.jpg" style="width:720px;" class="center"/>
<p class="center">某酒吧的台灯, 配合酒吧里透出来的蓝光, 台灯的黄光显得特别温暖, 他们配合在一起又显得特别柔和.</p>

<img src="https://raw.githubusercontent.com/tonicbupt/tonicbupt.github.io/master/images/pic/photo%E6%88%90%E9%83%BD%E9%94%A6%E9%87%8C-%E5%86%B0%E6%B7%87%E6%B7%8B%E5%BA%97%E8%80%81%E6%9D%BF.jpg" style="width:720px;" class="center"/>
<p class="center">某冰淇淋店的老板. X-E2 的高感好像也不怎么样, 1600 的 ISO 就糊成这样了... (其实是怪你自己相机拿不稳吧喂!)</p>

<img src="https://raw.githubusercontent.com/tonicbupt/tonicbupt.github.io/master/images/pic/photo%E6%88%90%E9%83%BD%E9%94%A6%E9%87%8C-%E7%81%AF%E7%AC%BC.jpg" style="width:720px;" class="center"/>
<p class="center">另外个叫"铜雀台"的酒吧. 里面没什么人, 红色灯笼, 木质窗户都让人觉得这像聊斋里的鬼片...好吧其实就怪我不会调色, 明明可以调得很温暖的嘛...</p>

<img src="https://raw.githubusercontent.com/tonicbupt/tonicbupt.github.io/master/images/pic/photo%E5%B0%8F%E9%A5%AD%E9%A6%86%E9%97%A8%E5%8F%A3%E4%BC%91%E6%81%AF%E7%9A%84%E5%8E%A8%E5%B8%88.jpg" style="width:720px;" class="center"/>
<p class="center">小饭馆门口坐着休息的厨师. 可能我需要一个长焦镜, 或者需要一颗更加不要脸的心.</p>

<img src="https://raw.githubusercontent.com/tonicbupt/tonicbupt.github.io/master/images/pic/photo%E5%85%AD%E5%8F%B7%E7%BA%BF%E5%9C%B0%E9%93%81%E7%9A%84%E7%94%B5%E6%A2%AF.jpg" style="width:720px;" class="center"/>
<p class="center">地铁六号线的电梯, 看多了昏暗环境下的色彩, 看张亮点的吧.</p>

刚刚又打开了下 JPEGmini Lite, 发现他真的不是骗我. 他说付费版是可以压缩无限量的图片, 果然免费版是限量的, 而且不是单次限量... 准备去装一个 ImageMagick 然后直接

    convert -resize 50% dummy.jpg stupid.jpg

妈蛋明明这个 JPEGmini 也是用的 ImageMagick 的库, 丫也不应该收费吧! 好吧我也不知道 ImageMagick 是什么开源协议...

生气地睡觉去了 ><
