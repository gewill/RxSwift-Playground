import RxCocoa

/*:
 [Previous](@previous) - [目录](目录)
 */
import RxSwift
/*:
 # 变形操作符
 转换序列发出的元素的操作符。
 ## `map`
 对"可观察"序列发射的元素应用转换闭包，并返回转换元素的新"可观察"序列。 [More info](http://reactivex.io/documentation/operators/map.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/map.png)
 */
example("map") {
    let disposeBag = DisposeBag()
    Observable.of(1, 2, 3)
        .map { $0 * $0 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

/*:
 ----
 ## `flatMap` and `flatMapLatest`

 将序列发出的元素转换为新的序列，并将所有序列的合并为单个序列。
 
 例如，当您有一个"可观察"序列，该序列本身会发出序列，并且您希望能够对来自任一序列的新排放做出反应时，这也是有用的。`flatMap`和`flatMapLatest`的区别在于，`flatMapLatest`只会从最新的内部序列中发射元素。
 [More info](http://reactivex.io/documentation/operators/flatmap.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/flatmap.png)
 */
example("flatMap and flatMapLatest") {
    let disposeBag = DisposeBag()

    struct Player {
        init(score: Int) {
            self.score = BehaviorSubject(value: score)
        }

        let score: BehaviorSubject<Int>
    }

    let 👦🏻 = Player(score: 80)
    let 👧🏼 = Player(score: 90)

    let player = BehaviorSubject(value: 👦🏻)

    player.asObservable()
        .flatMap { $0.score.asObservable() } // Change flatMap to flatMapLatest and observe change in printed output
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

    👦🏻.score.onNext(85)

    player.onNext(👧🏼)

    👦🏻.score.onNext(95) // Will be printed when using flatMap, but will not be printed when using flatMapLatest

    👧🏼.score.onNext(100)

    print("--- flatMap example ---")
    
    let arrayObservable: Observable<[Int]> = Observable.from([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
    ])
    let intObservable = arrayObservable.flatMap { nums in
        nums.last.map(Observable.just) ?? Observable.empty()
    }
    intObservable
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

/*:
 >
 在此示例中，使用`flatMap`可能会产生意想不到的后果。将👧🏼分配给`player.value`后，"👧🏼.score"将开始发射元素，但之前内部的序列（"👦🏻.score"）仍将发射元素。通过将`flatMap`更改为`flatMapLatest`，只有最新的内部序列（"👧🏼.score"）才会发出元素，即将"👦🏻.score.value"设置为"95"没有效果。
 #
 > `flatMapLatest` 是 `map` 和 `switchLatest` 的组合。
 */
/*:
 ----
 ## `scan`
 
 从初始种子值开始，然后将累加闭包于可观察序列发出的每个元素，并以单个元素"可观察"序列返回每个中间结果。
 像reduce
 [More info](http://reactivex.io/documentation/operators/scan.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/scan.png)
 */
example("scan") {
    let disposeBag = DisposeBag()

    Observable.of(10, 100, 1000)
        .scan(1) { aggregateValue, newValue in
            aggregateValue + newValue
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

//: [Next](@next) - [目录](目录)
