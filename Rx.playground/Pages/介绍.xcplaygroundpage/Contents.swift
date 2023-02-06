/*:
 [Previous](@previous)
 */

import RxSwift

/*:
# 介绍

## 为什么用 RxSwift?

 我们编写的绝大多数代码都涉及对外部事件的响应。当用户操作控件时，我们需要编写一个`@IBAction`处理程序以进行响应。我们需要观察通知以检测键盘何时更改位置。当URL会话响应数据时，我们必须提供闭包来执行。我们使用KVO来检测变量的变化。
 所有这些不同的系统使我们的代码不必要地变得复杂。如果有一个统一的系统来处理我们所有的呼叫/响应代码，这会更好吗？ Rx是这样的系统。
 
 RxSwift 是 Swift 的官方实现 [Reactive Extensions](http://reactivex.io) (aka Rx), [其他语言](http://reactivex.io/languages.html).
*/
/*:
 ## 概念
 
 **每个`Observable`实例只是一个序列。**
 
 与Swift的`Sequence`相比，`Observable`序列的主要优势在于它还可以异步接收元素。这是RxSwift的本质。 其他一切都扩展了这个概念。

 * `Observable` (`ObservableType`)等效于`Sequence`。
 * `ObservableType.subscribe(_:)`方法等效于`Sequence.makeIterator()`。
 * `ObservableType.subscribe(_:)` 使用观察者（ObserverType）参数，该参数将被订阅以自动接收Observable发出的序列事件和元素，而不是在返回的生成器上手动调用`next()`。
 */
/*:
 如果“可观察的”发出下一个事件（“ Event.next（Element）”），则它可以继续发出更多的事件。但是，如果“可观察”序列发出错误事件（“ Event.error（ErrorType）”）或完成事件（“ Event.completed”），则“可观察”序列将无法向观察者发射其他事件。

 序列语法更简洁地说明了这一点：

 `next* (error | completed)?`

 而且，还可以使用图表在视觉上进行解释：

 `--1--2--3--4--5--6--|----> // "|" = 正常终止`

 `--a--b--c--d--e--f--X----> // "X" = 因错误终止`

 `--tap--tap----------tap--> // "|" = 无限期继续，例如一系列的按钮轻击`

 > 这些图解称为弹子图解. 可参考 [RxMarbles.com](http://rxmarbles.com).
*/
/*:
 ### 可监听序列 和 观察者 (订阅者)
 序列没有观者者时，不会执行订阅闭包
 */
example("序列没有观者者") {
    _ = Observable<String>.create { observerOfString -> Disposable in
        print("这里不会打印")
        observerOfString.on(.next("😬"))
        observerOfString.on(.completed)
        return Disposables.create()
    }
}
/*:
 ----
 调用`subscribe(_:)`时订阅闭包才会执行:
 */
example("Observable with subscriber") {
  _ = Observable<String>.create { observerOfString in
            print("Observable created")
            observerOfString.on(.next("😉"))
            observerOfString.on(.completed)
            return Disposables.create()
        }
        .subscribe { event in
            print(event)
    }
}
/*:
 > 在这些示例中，您不必担心这些“可观察的”是如何创建的细节。我们将深入探讨 [next](@next).
 #
 > subscribe（_:)返回一个Disposable实例，该实例代表诸如订阅之类的可消除资源。在前面的简单示例中已将其忽略，但通常应正确处理。这通常意味着将其添加到`DisposeBag`实例中。以后的所有示例都将包含适当的处理方式，因为实践可以使_permanent_🙂。 You can learn more about this in the [Disposing section](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#disposing) of the [Getting Started guide](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md).
 */

//: [Next](@next) - [Table of Contents](Table_of_Contents)
