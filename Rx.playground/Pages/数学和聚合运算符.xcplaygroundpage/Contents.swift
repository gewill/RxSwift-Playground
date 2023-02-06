
/*:
 [Previous](@previous) - [目录](目录)
 */
import RxSwift
/*:
 # 数学和聚合运算符
 对序列发出的所有元素进行操作的运算符。
 ## `toArray`
 将“可观察的”序列转换为数组，将该数组作为新的单元素可观察的序列发出，然后终止。
 [More info](http://reactivex.io/documentation/operators/to.html)
 ![](http://reactivex.io/documentation/operators/images/to.c.png)
 */
example("toArray") {
    let disposeBag = DisposeBag()

    Observable.range(start: 1, count: 10)
        .toArray()
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `reduce`

 从初始值开始，然后将累加器闭包应用于序列发出的所有元素，然后将合计结果作为单元素可观察序列返回。
 和标准库的reduce一样
 [More info](http://reactivex.io/documentation/operators/reduce.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/reduce.png)
 */
example("reduce") {
    let disposeBag = DisposeBag()

    Observable.of(10, 100, 1000)
        .reduce(1, accumulator: +)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `concat`

 以顺序方式连接可观察序列的内部可观察序列中的元素，等待每个序列成功终止，然后再发射下一个序列中的元素。
 串联多个序列的元素。
 [More info](http://reactivex.io/documentation/operators/concat.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/concat.png)
 */
example("concat") {
    let disposeBag = DisposeBag()

    let subject1 = BehaviorSubject(value: "🍎")
    let subject2 = BehaviorSubject(value: "🐶")

    let subjectsSubject = BehaviorSubject(value: subject1)

    subjectsSubject.asObservable()
        .concat()
        .subscribe { print($0) }
        .disposed(by: disposeBag)

    subject1.onNext("🍐")
    subject1.onNext("🍊")

    subjectsSubject.onNext(subject2)

    subject2.onNext("I would be ignored")
    subject2.onNext("🐱")

    subject1.onCompleted()

    subject2.onNext("🐭")
}

example("concat2") {
    let disposeBag = DisposeBag()

    let subject1 = Observable.range(start: 1, count: 3)
    let subject2 = Observable.range(start: 10, count: 3)

    let subjectsSubject = BehaviorSubject(value: subject1)

    subjectsSubject.asObservable()
        .concat()
        .subscribe { print($0) }
        .disposed(by: disposeBag)

    subjectsSubject.onNext(subject2)
}

//: [Next](@next) - [目录](目录)
