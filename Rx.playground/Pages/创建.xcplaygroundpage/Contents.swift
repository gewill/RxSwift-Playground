/*:
 [Previous](@previous) - [Table of Contents](Table_of_Contents)
 */
import RxSwift
/*:
 # Creating and Subscribing to `Observable`s
 There are several ways to create and subscribe to `Observable` sequences.
 ## never
 创建一个永远不会结束和发送任何事件的序列 [More info](http://reactivex.io/documentation/operators/empty-never-throw.html)
 */
example("never") {
    let disposeBag = DisposeBag()
    let neverSequence = Observable<String>.never()

    let neverSequenceSubscription = neverSequence
        .subscribe { _ in
            print("This will never be printed")
        }

    neverSequenceSubscription.disposed(by: disposeBag)
}

/*:
 ----
 ## empty
 创建一个仅发送完成事件的序列 [More info](http://reactivex.io/documentation/operators/empty-never-throw.html)
 */
example("empty") {
    let disposeBag = DisposeBag()

    Observable<Int>.empty()
        .subscribe { event in
            print(event)
        }
        .disposed(by: disposeBag)
}

/*:
 > This example also introduces chaining together creating and subscribing to an `Observable` sequence.
 ----
 ## just
 创建一个仅发送一个元素和完成的序列 [More info](http://reactivex.io/documentation/operators/just.html)
 */
example("just") {
    let disposeBag = DisposeBag()

    Observable.just("🔴")
        .subscribe { event in
            print(event)
        }
        .disposed(by: disposeBag)
}

/*:
 ----
 ## of
 创建动态大小的元素的序列
 */
example("of") {
    let disposeBag = DisposeBag()

    Observable.of("🐶", "🐱", "🐭", "🐹")
        .subscribe(onNext: { element in
            print(element)
        })
        .disposed(by: disposeBag)
}

/*:
  > 这里使用便利方法，可以分开处理onNext和onCompleted等事件
  ```
  someObservable.subscribe(
      onNext: { print("Element:", $0) },
      onError: { print("Error:", $0) },
      onCompleted: { print("Completed") },
      onDisposed: { print("Disposed") }
  )
 ```
  ----
  ## from
  从“序列”创建“可观察序列“，例如“数组”，“字典”或“集合”。
  */
example("from") {
    let disposeBag = DisposeBag()
    let array = ["🐶", "🐱", "🐭", "🐹", "🐱"]
    Observable.from(array)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

    Observable.from(["A": 2, "B": 1])
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

    let set = Set(array)
    Observable.from(set)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
  > 此示例还演示了如何使用默认参数名称`$0`，而不是显式命名参数。
 ----
  ## create
 创建一个自定义的可观察序列，利用闭包。 [More info](http://reactivex.io/documentation/operators/create.html)
 */
example("create") {
    let disposeBag = DisposeBag()

    let myJust = { (element: String) -> Observable<String> in
        Observable.create { observer in
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        }
    }

    myJust("🔴")
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}

/*:
 ----
 ## range
 创建一个`Observable`序列，该序列发出一定范围的连续整数，然后终止。 [More info](http://reactivex.io/documentation/operators/range.html)
 */
example("range") {
    let disposeBag = DisposeBag()

    Observable.range(start: 1, count: 5)
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}

/*:
 ----
 ## repeatElement
 创建一个“可观察”序列，该序列无限期地发出给定元素。 [More info](http://reactivex.io/documentation/operators/repeat.html)
 */
example("repeatElement") {
    let disposeBag = DisposeBag()

    Observable.repeatElement("🔴")
        .take(6)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 > 这个例子还介绍了使用`take`运算符从序列开始处返回指定数量的元素。不然就会无限发出元素。
 ----
 ## generate
 创建一个“可观察”序列，该序列会在提供的条件评估为“真”的情况下生成值。
 像C语言中for循环。
 */
example("generate") {
    let disposeBag = DisposeBag()

    Observable.generate(
        initialState: 0,
        condition: { $0 < 10 },
        iterate: { $0 + 2 }
    )
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)
}

/*:
 ----
 ## deferred
 为每个观察者创建一个新的“可观察”序列。有几个观察者就会创建几次序列。 [More info](http://reactivex.io/documentation/operators/defer.html)
 */
example("deferred") {
    let disposeBag = DisposeBag()
    var count = 1

    let deferredSequence = Observable<String>.deferred {
        print("第\(count)次创建序列")
        count += 1

        return Observable.create { observer in
            print("发出...")
            observer.onNext("🐶")
            observer.onNext("🐱")
            observer.onNext("🐵")
            return Disposables.create()
        }
    }

    deferredSequence
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

    deferredSequence
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    deferredSequence
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## error
 创建一个“可观察”序列，该序列不发出任何元素，并立即终止并显示错误。
 */
example("error") {
    let disposeBag = DisposeBag()

    Observable<Int>.error(TestError.test)
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}

/*:
 ----
 ## doOn
 为每个发出的事件调用一个副作用动作，并返回（透传）原始事件。
 类似forEach。[More info](http://reactivex.io/documentation/operators/do.html)
 */
example("doOn") {
    let disposeBag = DisposeBag()

    Observable.of("🍎", "🍐", "🍊", "🍋")
        .do(onNext: { print("拦截元素:", $0) }, afterNext: { print("拦截元素之后:", $0) }, onError: { print("拦截 错误:", $0) }, afterError: { print("拦截错误之后:", $0) }, onCompleted: { print("完成事件") }, afterCompleted: { print("完成事件之后") })
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

//: > 也有`doOnNext（_:)`，`doOnError（_:)`和`doOnCompleted（_:)`便捷方法来拦截这些特定事件，以及`doOn（onNext:onError:onCompleted:）`来拦截一个特定事件。一次通话中有更多事件。

//: [Next](@next) - [Table of Contents](Table_of_Contents)
