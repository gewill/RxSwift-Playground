/*:
 [Previous](@previous) - [目录](目录)
 */
import RxSwift
/*:
# 组合操作符
 将多个源“可观察序列”组合成一个“可观察序列”的运算符
## `startWith`
 
 在开始从源“可观察”发出元素之前，发出指定的元素序列。
 插入头部
 [More info](http://reactivex.io/documentation/operators/startwith.html)
![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/startwith.png)
*/
example("startWith") {
    let disposeBag = DisposeBag()
    
    Observable.of("🐶", "🐱", "🐭", "🐹")
        .startWith("1️⃣")
        .startWith("2️⃣")
        .startWith("3️⃣", "🅰️", "🅱️")
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 > 如本示例所示，可以以后进先出的方式链接“ startWith”，即，每个连续的“ startWith”元素都将在之前的“ startWith”元素之前。
 ----
 ## `merge`
 将来自源“可观察”序列的元素组合为一个新的“可观察”序列，并将发出每个源“可观察”序列发出的元素。
 合并后遵循原序列发出元素的时间。
 [More info](http://reactivex.io/documentation/operators/merge.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/merge.png)
 */
example("merge") {
    let disposeBag = DisposeBag()
    
    let subject1 = PublishSubject<String>()
    let subject2 = PublishSubject<String>()
    
    Observable.of(subject1, subject2)
        .merge()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    subject1.onNext("🅰️")
    
    subject1.onNext("🅱️")
    
    subject2.onNext("①")
    
    subject2.onNext("②")
    
    subject1.onNext("🆎")
    
    subject2.onNext("③")
}
/*:
 ----
 ## `zip`
 
 将最多8个源“可观察”序列组合为一个新的“可观察”序列，并将从组合的“可观察”序列中发出相应索引处每个源“可观察”序列的元素。
 按照索引组合
 示例如：九图上传
 [More info](http://reactivex.io/documentation/operators/zip.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/zip.png)
 */
example("zip") {
    let disposeBag = DisposeBag()
    
    let stringSubject = PublishSubject<String>()
    let intSubject = PublishSubject<Int>()
    
    Observable.zip(stringSubject, intSubject) { stringElement, intElement in
        "\(stringElement) \(intElement)"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    stringSubject.onNext("🅰️")
    stringSubject.onNext("🅱️")
    
    intSubject.onNext(1)
    
    intSubject.onNext(2)
    
    stringSubject.onNext("🆎")
    intSubject.onNext(3)
    
    // 元素组合不够时，提前结束
//    intSubject.onCompleted()
//    intSubject.onError(TestError.test)
}
/*:
 ----
 ## `combineLatest`
 
 将多达 8个源"可观察"序列组合成一个新的"可观察"序列，并将开始从合并的"可观察"序列中释放出每个源"可观察"序列的最新元素，一旦所有源序列都发出至少一个元素，并且当任何源"可观察"序列发出新元素时也是如此。
 所有序列都有元素，且有序列发出新元素时，组合所有序列的最后一个元素。
 [More info](http://reactivex.io/documentation/operators/combinelatest.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/combinelatest.png)
 */
example("combineLatest") {
    let disposeBag = DisposeBag()
    
    let stringSubject = PublishSubject<String>()
    let intSubject = PublishSubject<Int>()
    
    Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    stringSubject.onNext("🅰️")
    
    stringSubject.onNext("🅱️")
    intSubject.onNext(1)

    intSubject.onNext(2)

    stringSubject.onNext("🆎")
}
//: 还有一个`combineLatest`的变体，需要`Array`（或任何其他"可观察"序列集合）：
example("Array.combineLatest") {
    let disposeBag = DisposeBag()
    
    let stringObservable = Observable.just("❤️")
    let fruitObservable = Observable.from(["🍎", "🍐", "🍊"])
    let animalObservable = Observable.of("🐶", "🐱", "🐭", "🐹")
    
    Observable.combineLatest([stringObservable, fruitObservable, animalObservable]) {
            "\($0[0]) \($0[1]) \($0[2])"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 > 由于将集合的 `combineLatest` 变体将一系列值传递到选择器函数，因此它要求所有源"可观察"序列的元素为同一类型。
 ----
 ## `switchLatest`
 将序列发出的元素转换为序列，并从最新的内部序列中释放元素。
 二维序列，转可切换的一维序列。切换时发送最后一个元素。
 [More info](http://reactivex.io/documentation/operators/switch.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/switch.png)
 */
example("switchLatest") {
    let disposeBag = DisposeBag()
    
    let subject1 = BehaviorSubject(value: "⚽️")
    let subject2 = BehaviorSubject(value: "🍎")
    
    let subjectsSubject = BehaviorSubject(value: subject1)
        
    subjectsSubject.asObservable()
        .switchLatest()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    subject1.onNext("🏈")
    subject1.onNext("🏀")
    
    subjectsSubject.onNext(subject2)
    
    subject1.onNext("⚾️")
    
    subject2.onNext("🍐")
}
/*:
 > 在此示例中，在将"主题2"添加到"主题"后将⚾️添加到"主题1"中没有效果，因为只有最新的内部序列（"主题2"）才会发出元素。

 ----
 ## `withLatestFrom`
 
 将第一个源的每个元素与来自第二个源的最新元素（如果有的话）合并，将两个可观察到的序列合并为一个可观察的序列。
 适合前面序列驱动，组合后面序列。
 */
example("withLatestFrom") {
    let disposeBag = DisposeBag()
    
    let foodSubject = PublishSubject<String>()
    let drinksSubject = PublishSubject<String>()
    
    foodSubject.asObservable()
        .withLatestFrom(drinksSubject) { "\($0) + \($1)" }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    foodSubject.onNext("🥗")
    
    drinksSubject.onNext("☕️")
    foodSubject.onNext("🥐")
    
    drinksSubject.onNext("🍷")
    foodSubject.onNext("🍔")
    
    foodSubject.onNext("🍟")
    
    drinksSubject.onNext("🍾")
}
/*:
 > 在本示例中，没有打印🥗，因为drinksSubject在收到🥗之前没有发出任何值。最后一杯饮料（🍾）将打印，每当foodSubject将发出另一个事件。
 */

//: [Next](@next) - [目录](目录)
