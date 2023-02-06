import RxSwift
/*:
 # Try Yourself

 It's time to play with Rx 🎉
 */
playgroundShouldContinueIndefinitely()

example("Try yourself") {
    // let disposeBag = DisposeBag()
    _ = Observable.just("Hello, RxSwift!")
        .debug("Observable")
        .subscribe()
    // .disposed(by: disposeBag) // If dispose bag is used instead, sequence will terminate on scope exit
}
