

/*:
 [Previous](@previous) - [目录](目录)
 */

import Foundation
import RxSwift

extension Date {
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}

playgroundShouldContinueIndefinitely()
/*:
 # 可连接运算符

  可连接的可观察序列类似于普通的可观察序列，不同之处在于它们在订阅时不会开始发出元素，而是仅在调用其`connect()`方法时才开始发出元素。这样，您可以等待所有预期的订阅者订阅可连接的可观察序列，然后再开始发射元素。
  >
  在此页面上的每个示例中，都有一个注释掉的方法。取消注释该方法以运行示例，然后再次对其进行注释以停止运行该示例。
  #
  在学习可连接运算符之前，让我们看一个不可连接运算符的示例：
 */
func sampleWithoutConnectableOperators() {
    printExampleHeader(#function)

    let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        .map { "\($0), 创建于\(Date().time)" }

    _ = interval
        .subscribe(onNext: { print("观察者: 1, 接收于\(Date().time), Event: \($0)") })

    delay(3) {
        _ = interval
            .subscribe(onNext: { print("观察者: 2, 接收于\(Date().time), Event: \($0)") })
    }

    // 观察者2订阅的晚，但是仍然从0开始接收元素，但是有3秒延迟，落后于观察者1。
    // 元素创建时间也是晚的
//    观察者: 1, 接收于15:13:38, Event: 0, 创建于15:13:38
//    观察者: 1, 接收于15:13:39, Event: 1, 创建于15:13:39
//    观察者: 1, 接收于15:13:40, Event: 2, 创建于15:13:40
//    观察者: 1, 接收于15:13:41, Event: 3, 创建于15:13:41
//    观察者: 2, 接收于15:13:41, Event: 0, 创建于15:13:41
//    观察者: 1, 接收于15:13:42, Event: 4, 创建于15:13:42
//    观察者: 2, 接收于15:13:42, Event: 1, 创建于15:13:42
//    观察者: 1, 接收于15:13:43, Event: 5, 创建于15:13:43
//    观察者: 2, 接收于15:13:43, Event: 2, 创建于15:13:43
}

//sampleWithoutConnectableOperators() // ⚠️ Uncomment to run this example; comment to stop running
/*:
 > `interval`创建一个`Observable`序列，该序列在指定的调度程序上的每个`period`之后发出元素。
 [More info](http://reactivex.io/documentation/operators/interval.html)
 ![](http://reactivex.io/documentation/operators/images/interval.c.png)
 ----
 ## `publish`

 将源可观察序列转换为可连接序列。
 [More info](http://reactivex.io/documentation/operators/publish.html)
 ![](http://reactivex.io/documentation/operators/images/publishConnect.c.png)
 */
func sampleWithPublish() {
    printExampleHeader(#function)

    let intSequence = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        .map { "\($0), 创建于\(Date().time)" }
        .publish() // 改为可连接序列，但是当前为未连接的状态，观察者接收不到事件

    print("创建Observable", Date().time)
    _ = intSequence
        .subscribe(onNext: { print("观察者 1:, 接收于\(Date().time), Event: \($0)") })

    delay(6) {
        print("开始连接，观察者开始接收事件", Date().time)
        _ = intSequence.connect()
    }

    delay(8) {
        _ = intSequence
            .subscribe(onNext: { print("观察者 2:, 接收于\(Date().time), Event: \($0)") })
    }

    delay(10) {
        _ = intSequence
            .subscribe(onNext: { print("观察者 3:, 接收于\(Date().time), Event: \($0)") })
    }

    // 观察者1在connect()前订阅，从0开始接收元素，connect之后才真正开始创建元素
    // 观察者2订阅的晚，从1开始接收元素，订阅晚的只能接受当前的元素
    // 观察者3订阅的更晚，从3开始接收元素

//    创建Observable 15:16:37
//    开始连接，观察者开始接收事件 15:16:44
//    观察者 1:, 接收于15:16:45, Event: 0, 创建于15:16:45
//    观察者 1:, 接收于15:16:46, Event: 1, 创建于15:16:46
//    观察者 2:, 接收于15:16:46, Event: 1, 创建于15:16:46
//    观察者 1:, 接收于15:16:47, Event: 2, 创建于15:16:47
//    观察者 2:, 接收于15:16:47, Event: 2, 创建于15:16:47
//    观察者 1:, 接收于15:16:48, Event: 3, 创建于15:16:48
//    观察者 2:, 接收于15:16:48, Event: 3, 创建于15:16:48
//    观察者 3:, 接收于15:16:48, Event: 3, 创建于15:16:48
//    观察者 1:, 接收于15:16:49, Event: 4, 创建于15:16:49
//    观察者 2:, 接收于15:16:49, Event: 4, 创建于15:16:49
//    观察者 3:, 接收于15:16:49, Event: 4, 创建于15:16:49
//    观察者 1:, 接收于15:16:50, Event: 5, 创建于15:16:50
//    观察者 2:, 接收于15:16:50, Event: 5, 创建于15:16:50
//    观察者 3:, 接收于15:16:50, Event: 5, 创建于15:16:50
}

// sampleWithPublish() // ⚠️ Uncomment to run this example; comment to stop running

//: > Schedulers are an abstraction of mechanisms for performing work, such as on specific threads or dispatch queues. [More info](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Schedulers.md)

/*:
 ----
 ## `replay`
 将源可观察序列转换为可连接序列，并将向每个新观察者重播先前发射的“ bufferSize”数量。
 [More info](http://reactivex.io/documentation/operators/replay.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replay.png)
 */
func sampleWithReplayBuffer() {
    printExampleHeader(#function)

    let intSequence = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        .map { "\($0), 创建于\(Date().time)" }
        .replay(5)

    _ = intSequence
        .subscribe(onNext: { print("观察者 1:, 接收于\(Date().time), Event: \($0)") })

    delay(2) { _ = intSequence.connect() }

    delay(4) {
        _ = intSequence
            .subscribe(onNext: { print("观察者 2:, 接收于\(Date().time), Event: \($0)") })
    }

    delay(8) {
        _ = intSequence
            .subscribe(onNext: { print("观察者 3:, 接收于\(Date().time), Event: \($0)") })
    }
    
    // 观察者3，开始订阅时一下接收到5个缓存元素0～4，并且是之前创建的。
    
//    观察者 1:, 接收于15:33:38, Event: 0, 创建于15:33:38
//    观察者 2:, 接收于15:33:39, Event: 0, 创建于15:33:38
//    观察者 1:, 接收于15:33:39, Event: 1, 创建于15:33:39
//    观察者 2:, 接收于15:33:39, Event: 1, 创建于15:33:39
//    观察者 1:, 接收于15:33:40, Event: 2, 创建于15:33:40
//    观察者 2:, 接收于15:33:40, Event: 2, 创建于15:33:40
//    观察者 1:, 接收于15:33:41, Event: 3, 创建于15:33:41
//    观察者 2:, 接收于15:33:41, Event: 3, 创建于15:33:41
//    观察者 1:, 接收于15:33:42, Event: 4, 创建于15:33:42
//    观察者 2:, 接收于15:33:42, Event: 4, 创建于15:33:42
//    观察者 3:, 接收于15:33:43, Event: 0, 创建于15:33:38
//    观察者 3:, 接收于15:33:43, Event: 1, 创建于15:33:39
//    观察者 3:, 接收于15:33:43, Event: 2, 创建于15:33:40
//    观察者 3:, 接收于15:33:43, Event: 3, 创建于15:33:41
//    观察者 3:, 接收于15:33:43, Event: 4, 创建于15:33:42
//    观察者 1:, 接收于15:33:43, Event: 5, 创建于15:33:43
//    观察者 2:, 接收于15:33:43, Event: 5, 创建于15:33:43
//    观察者 3:, 接收于15:33:43, Event: 5, 创建于15:33:43
//    观察者 1:, 接收于15:33:44, Event: 6, 创建于15:33:44
//    观察者 2:, 接收于15:33:44, Event: 6, 创建于15:33:44
//    观察者 3:, 接收于15:33:44, Event: 6, 创建于15:33:44
}

// sampleWithReplayBuffer() // ⚠️ Uncomment to run this example; comment to stop running

/*:
 ----
 ## `multicast`
 Converts the source `Observable` sequence into a connectable sequence, and broadcasts its emissions via the specified `subject`.
 将源可观察序列转换为可连接序列，并通过指定的`subject`广播其发射。
 相互投射
 */
func sampleWithMulticast() {
    printExampleHeader(#function)

    let subject = PublishSubject<String>()

    _ = subject
        .subscribe(onNext: { print("Subject:, 接收于\(Date().time)， \($0)") })

    let intSequence = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { "\($0), 创建于\(Date().time)" }
            .multicast(subject)

    _ = intSequence
        .subscribe(onNext: { print("\t观察者 1:, 接收于\(Date().time), Event: \($0)") })

    delay(2) { _ = intSequence.connect() }

    delay(4) {
        _ = intSequence
            .subscribe(onNext: { print("\t观察者 2:, 接收于\(Date().time), Event: \($0)") })
    }

    delay(6) {
        _ = intSequence
            .subscribe(onNext: { print("\t观察者 3:, 接收于\(Date().time), Event: \($0)") })
    }
    
    subject.onNext("88")
    
//    Subject:, 接收于13:04:29， 88
//        观察者 1:, 接收于13:04:29, Event: 88
//    Subject:, 接收于13:04:33， 0, 创建于13:04:33
//        观察者 1:, 接收于13:04:33, Event: 0, 创建于13:04:33
//    Subject:, 接收于13:04:34， 1, 创建于13:04:34
//        观察者 1:, 接收于13:04:34, Event: 1, 创建于13:04:34
//        观察者 2:, 接收于13:04:34, Event: 1, 创建于13:04:34
//    Subject:, 接收于13:04:35， 2, 创建于13:04:35
//        观察者 1:, 接收于13:04:35, Event: 2, 创建于13:04:35
//        观察者 2:, 接收于13:04:35, Event: 2, 创建于13:04:35
//    Subject:, 接收于13:04:36， 3, 创建于13:04:36
//        观察者 1:, 接收于13:04:36, Event: 3, 创建于13:04:36
//        观察者 2:, 接收于13:04:36, Event: 3, 创建于13:04:36
//        观察者 3:, 接收于13:04:36, Event: 3, 创建于13:04:36
//    Subject:, 接收于13:04:37， 4, 创建于13:04:37
//        观察者 1:, 接收于13:04:37, Event: 4, 创建于13:04:37
//        观察者 2:, 接收于13:04:37, Event: 4, 创建于13:04:37
//        观察者 3:, 接收于13:04:37, Event: 4, 创建于13:04:37

}

// sampleWithMulticast() // ⚠️ Uncomment to run this example; comment to stop running

//: [Next](@next) - [目录](目录)
