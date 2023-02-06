import AppKit
/*:
 [上一页](@previous) - [目录](目录)
 */
import RxSwift
/*:
 # 并发 Concurrency
 [Swift Concurrency Documentation](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/SwiftConcurrency.md)
 */

example("Awaiting a throwing sequence") {
    Task {
        let observable = Observable.of("🐶", "🐱", "🐭", "🐹")
        for try await value in observable.values {
            print("example 1. Got a value:", value)
        }
    }
}

example("Awaiting a non-throwing sequence") {
    Task {
        let infalliable = Observable.of("🐶", "🐱", "🐭", "🐹").asInfallible(onErrorJustReturn: "--")
        for await value in infalliable.values {
            print("example 2. Got a value:", value)
        }
    }
}

example("Awaiting a single value") {
    Task {
        let value1 = try await Observable.of("🐶").asSingle().value // Element
        print("example 3. single", value1)
        let value2 = try await Observable.of("🐶").asMaybe().value // Element?
        print("example 3. maybe", value2)
        let value3 = try await Completable.error(TestError.test).value // Void
        print("example 3. completable", value3)
        let value4 = try await Completable.empty().value // Void
        print("example 3. completable", value4)
    }
}

//: [下一页](@next) - [目录](目录)
