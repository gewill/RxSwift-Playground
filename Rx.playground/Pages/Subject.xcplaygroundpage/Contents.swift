/*:
 [Previous](@previous) - [Table of Contents](Table_of_Contents)
 */
import RxSwift
/*:
 # 使用Subject
 主题是一种在Rx的某些实现中可用的桥梁或代理，它既充当观察者又充当可观察序列。因为它是观察者，所以可以订阅一个或多个序列，并且由于它是序列，因此可以通过释放观察到的事件来传递它们，并且还可以发出新的事件。 [More info](http://reactivex.io/documentation/subject.html)
 */
extension ObservableType {
    /// 添加带有`id`的观察者并打印每个发出的事件。
    func addObserver(_ id: String) -> Disposable {
        subscribe { print("观察者:", id, "事件:", $0) }
    }
}

/*:
 ## PublishSubject
 从订阅开始向所有观察者广播新事件。
 ![PublishSubject](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishsubject.png "PublishSubject")
 */
example("PublishSubject") {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()

    subject.addObserver("1").disposed(by: disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")

    subject.addObserver("2").disposed(by: disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
    
    subject.onCompleted()
}

/*:
 ## ReplaySubject
 向所有观察者广播新事件，并向新观察者广播之前指定的`bufferSize`大小的事件数。
 ！[](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replaysubject.png)
 */
example("ReplaySubject") {
    let disposeBag = DisposeBag()
    let subject = ReplaySubject<String>.create(bufferSize: 1)

    subject.addObserver("1").disposed(by: disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")

    subject.addObserver("2").disposed(by: disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
    
    subject.onCompleted()
}

/*:
  ----
 ## BehaviorSubject
 向所有观察者广播新事件，并向新观察者广播最新（或初始）值。
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/behaviorsubject.png)
 */
example("BehaviorSubject") {
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject(value: "🔴")

    subject.addObserver("1").disposed(by: disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")

    subject.addObserver("2").disposed(by: disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")

    subject.onCompleted()
}
/*:
  ----
 ## Relay
 在保持其replay行为的同时包装了subject。与其他subject不同，可以使用 `accept(_:)` 添加值，而非 `onNext(_:)`。这是因为Relay只能接受值，即不能向它们添加错误或已完成的事件。
*/
import RxRelay

example("PublishRelay") {
    let disposeBag = DisposeBag()
    let subject = PublishRelay<String>()

    subject.addObserver("1").disposed(by: disposeBag)
    subject.accept("🐶")
    subject.accept("🐱")

    subject.addObserver("2").disposed(by: disposeBag)
    subject.accept("🅰️")
    subject.accept("🅱️")
}

example("BehaviorRelay") {
    let disposeBag = DisposeBag()
    let subject = BehaviorRelay<String>(value: "🔴")

    subject.addObserver("1").disposed(by: disposeBag)
    subject.accept("🐶")
    subject.accept("🐱")

    subject.addObserver("2").disposed(by: disposeBag)
    subject.accept("🅰️")
    subject.accept("🅱️")
}

//: [Next](@next) - [Table of Contents](Table_of_Contents)
