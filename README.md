# JFBubbleView

* JFBubbleItem 
* JFInputBubbleItem
* JFBubbleView
* JFEditBubbleViw
* JFSelectBubbleView

自定义 BubbleItem:JFBubbleItem 对 气泡的样式和选中样式进行自定义， 选中 item 时调用 BubbleView的代理中的 didSelectItem 方法，普通的样式代码非常简单，参考 UITableView 和 UITableViewCell 的用法。

参考 demo 中 `JFSelectBubbleView` 的实现，在自定义类中对 单个气泡的样式进行自定义，包括文字颜色，边框，圆角等。

Base 类: **JFBubbleItem**, **JFBubbleView** , **JFInputBubbleItem** 是一个可输入文字的气泡。
其他类都是派生类，多少含有一些业务需求、、


## JFBubbleItem

默认样式


自定义子类来覆写默认样式，选中样式

示例参照 `JFSelectBubbleView.m` 中的 **JFSelectBubbleItem**

## JFBubbleView

用法类似 TableView，示例参考 **JFSelectBubbleView**

## JFBubbleViewController

是一个类似微信标签设置页的页面，上面一个输入页面，下面是一个所有标签页，两个页面需要数据联动，逻辑处理完毕，使用这个页面时，只需要修改两个单独的视图(命名如此差，不能忍，必须新建一个类啊） **DemoEditBubbleView** 和 **DemoSelectBubbleView** 中的数据源**读取**即可


