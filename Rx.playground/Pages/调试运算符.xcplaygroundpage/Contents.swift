
/*:
 [上一页](@previous) - [目录](目录)
 */
import RxSwift
/*:
 # 调试运算符
 运算符可帮助调试Rx代码。
 ## `debug`
 打印所有订阅，事件和消除。
 */
example("debug") {
    let disposeBag = DisposeBag()
    var count = 1
    
    let sequenceThatErrors = Observable<String>.create { observer in
        observer.onNext("🍎")
        observer.onNext("🍐")
        observer.onNext("🍊")
        
        if count < 5 {
            observer.onError(TestError.test)
            print("Error encountered")
            count += 1
        }
        
        observer.onNext("🐶")
        observer.onNext("🐱")
        observer.onNext("🐭")
        observer.onCompleted()
        
        return Disposables.create()
    }
    
    sequenceThatErrors
        .retry(3)
        .debug()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `RxSwift.Resources.total`
 提供所有Rx资源分配的计数，这对于在开发过程中检测泄漏很有用。
 */
#if NOT_IN_PLAYGROUND
#else
example("RxSwift.Resources.total") {
    print(RxSwift.Resources.total)
    
    let disposeBag = DisposeBag()
    
    print(RxSwift.Resources.total)
    
    let subject = BehaviorSubject(value: "🍎")
    
    let subscription1 = subject.subscribe(onNext: { print($0) })
    
    print(RxSwift.Resources.total)
    
    let subscription2 = subject.subscribe(onNext: { print($0) })
    
    print(RxSwift.Resources.total)
    
    subscription1.dispose()
    
    print(RxSwift.Resources.total)
    
    subscription2.dispose()
    
    print(RxSwift.Resources.total)
}
    
print(RxSwift.Resources.total)
#endif
//: > `RxSwift.Resources.total` 默认情况下未启用，并且通常不应在发布版本中启用。 [Click here](Enable_RxSwift.Resources.total) for instructions on how to enable it.

//: [下一页](@next) - [目录](目录)
