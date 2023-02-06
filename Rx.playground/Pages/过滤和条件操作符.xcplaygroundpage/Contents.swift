
/*:
 [Previous](@previous) - [目录](目录)
 */
import RxSwift
/*:
 # 过滤和条件操作符
  从源可观察序列中选择性地发出元素的运算符。
 ## `filter`
  仅从满足指定条件的可观察序列中发出那些元素。
  [More info](http://reactivex.io/documentation/operators/filter.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/filter.png)
 */
example("filter") {
    let disposeBag = DisposeBag()

    Observable.of(
        "🐱", "🐰", "🐶",
        "🐸", "🐱", "🐰",
        "🐹", "🐸", "🐱")
        .filter {
            $0 == "🐱"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
  ----
 ## `distinctUntilChanged`
  禁止由可观察序列发出的顺序重复元素。
  连续元素不可重复
  [More info](http://reactivex.io/documentation/operators/distinct.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/distinct.png)
 */
example("distinctUntilChanged") {
    let disposeBag = DisposeBag()

    Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `elementAt`
 仅在可观察序列发出的所有元素的指定索引处发出该元素。
 [More info](http://reactivex.io/documentation/operators/elementat.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/elementat.png)
 */
example("elementAt") {
    let disposeBag = DisposeBag()

    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .elementAt(1)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `single`
 仅发射可观察序列发出的第一个元素（或满足条件的第一个元素）。
 如果`Observable`序列没有发出正好一个元素，将抛出一个错误。
 */
example("single") {
    let disposeBag = DisposeBag()

    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .single()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    // 🐱
    // Unhandled error happened: Sequence contains more than one element.
    // 谨慎使用，会有多余错误
}

example("single with conditions") {
    let disposeBag = DisposeBag()

    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .single { $0 == "🐸" }
        .subscribe { print($0) }
        .disposed(by: disposeBag)

    // next(🐸)
    // completed

    Observable.of("🐱", "🐰", "🐶", "🐱", "🐰", "🐶")
        .single { $0 == "🐰" }
        .subscribe { print($0) }
        .disposed(by: disposeBag)

    // next(🐰)
    // error(Sequence contains more than one element.)
    // 谨慎使用，会有多余错误

    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .single { $0 == "🔵" }
        .subscribe { print($0) }
        .disposed(by: disposeBag)

    // error(Sequence doesn't contain any elements.)
}

/*:
 ----
 ## `take`
 从可观察序列的开头仅发射指定数量的元素。
 [More info](http://reactivex.io/documentation/operators/take.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/take.png)
 */
example("take") {
    let disposeBag = DisposeBag()

    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .take(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `takeLast`
 从可观察序列的末尾仅发出指定数量的元素。
 [More info](http://reactivex.io/documentation/operators/takelast.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takelast.png)
 */
example("takeLast") {
    let disposeBag = DisposeBag()

    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .takeLast(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `takeWhile`
 只要指定条件评估为true，就从可观察序列的开头发出元素。
 一旦条件为false，就停止发出。即使后面还有符合条件的元素。条件仅仅是分割线。
 [More info](http://reactivex.io/documentation/operators/takewhile.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takewhile.png)
 */
example("takeWhile") {
    let disposeBag = DisposeBag()

    Observable.of(1, 2, 3, 4, 5, 2, 6)
        .takeWhile { $0 < 4 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `takeUntil`
 从源可观察序列中发射元素，直到引用可观察序列发出元素。
 后者发出元素关闭开关。
 [More info](http://reactivex.io/documentation/operators/takeuntil.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takeuntil.png)
 */
example("takeUntil") {
    let disposeBag = DisposeBag()

    let sourceSequence = PublishSubject<String>()
    let referenceSequence = PublishSubject<String>()

    sourceSequence
        .takeUntil(referenceSequence)
        .subscribe { print($0) }
        .disposed(by: disposeBag)

    sourceSequence.onNext("🐱")
    sourceSequence.onNext("🐰")
    sourceSequence.onNext("🐶")

    referenceSequence.onNext("🔴")

    sourceSequence.onNext("🐸")
    sourceSequence.onNext("🐷")
    sourceSequence.onNext("🐵")
}

/*:
 ----
 ## `skip`
 抑制从可观察序列的开头发出指定数量的元素。
 [More info](http://reactivex.io/documentation/operators/skip.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/skip.png)
 */
example("skip") {
    let disposeBag = DisposeBag()

    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .skip(2)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `skipWhile`
 抑制从符合指定条件的"可观察"序列的开头发射元素。
 即使后面有不符合条件的元素。条件仅仅是分割线。
 [More info](http://reactivex.io/documentation/operators/skipwhile.html)
 ![](http://reactivex.io/documentation/operators/images/skipWhile.c.png)
 */
example("skipWhile") {
    let disposeBag = DisposeBag()

    Observable.of(1, 2, 3, 4, 5, 2, 6)
        .skipWhile { $0 < 4 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `skipWhileWithIndex`
 抑制从符合指定条件的可观察序列的开始发射元素，并发射剩余元素。
 闭包包含每个元素的索引。
 */
example("skipWhileWithIndex") {
    let disposeBag = DisposeBag()

    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .enumerated()
        .skipWhile { $0.index < 3 }
        .map { $0.element }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `skipUntil`
 抑制从源"可观察"序列中发射元素，直到引用"可观察"序列发出元素。
 后者发出元素打开开关。
 [More info](http://reactivex.io/documentation/operators/skipuntil.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/skipuntil.png)
 */
example("skipUntil") {
    let disposeBag = DisposeBag()

    let sourceSequence = PublishSubject<String>()
    let referenceSequence = PublishSubject<String>()

    sourceSequence
        .skipUntil(referenceSequence)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

    sourceSequence.onNext("🐱")
    sourceSequence.onNext("🐰")
    sourceSequence.onNext("🐶")

    referenceSequence.onNext("🔴")

    sourceSequence.onNext("🐸")
    sourceSequence.onNext("🐷")
    sourceSequence.onNext("🐵")
}

//: [Next](@next) - [目录](目录)
