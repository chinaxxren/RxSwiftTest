//
//  TestFive.swift
//  RxSwiftDemo
//
//  Created by 赵江明 on 2022/3/10.
//


import RxSwift

struct TestFive {
   
    enum TestError: Error {
       case errorA
       case errorB
    }
   
    let disposeBag = DisposeBag()

    // 发出 Observable 中通过判定的元素
    

    func filter() {
        let disposeBag = DisposeBag()

        Observable.of(2, 30, 22, 5, 60, 1)
                  .filter { $0 > 10 }
                  .subscribe(onNext: { print($0) })
                  .disposed(by: disposeBag)
    }

    // 从 Observable 中发出头 n 个元素
    func take() {
        let disposeBag = DisposeBag()

        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .take(3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // 从 Observable 中发出尾部 n 个元素
    func takeLast() {
        
        let disposeBag = DisposeBag()

        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .takeLast(3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // 只发出 Observable 中的第 n 个元素
    func elementAt() {
        
        let disposeBag = DisposeBag()

        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .element(at:3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // 跳过 Observable 中头 n 个元素
    func skip() {
        let disposeBag = DisposeBag()

        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .skip(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }

    // 跳过 Observable 中头几个元素，直到元素的判定为否
    func skipWhile() {
        let disposeBag = DisposeBag()

        Observable.of(1, 2, 3, 4, 3, 2, 1)
            .skip(while: { (val) -> Bool in
                val < 4
            })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // 跳过 Observable 中头几个元素，直到另一个 Observable 发出一个元素
    func skipUtil() {
        let disposeBag = DisposeBag()

        let A = PublishSubject<String>()
        let B = PublishSubject<String>()

        A.skip(until: B)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        A.onNext("A - 1")
        A.onNext("A - 2")
        A.onNext("A - 3")

        B.onNext("B - 1")

        A.onNext("A - 4")
        A.onNext("A - 5")
        A.onNext("A - 6")
    }
    
    // 只取头几个满足判定的元素
    func takeWhile() {
        let disposeBag = DisposeBag()

        Observable.of(1, 2, 3, 4, 3, 2, 1)
            .take(while: { (val) -> Bool in
                val < 4
            })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // 与skipUntil 相反，只发送另外一个Observable发出第一个元素前发出的元素
    func takeUtil() {
        let disposeBag = DisposeBag()

        let A = PublishSubject<String>()
        let B = PublishSubject<String>()

        A.take(until:B)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        A.onNext("A - 1")
        A.onNext("A - 2")
        A.onNext("A - 3")

        B.onNext("B - 1")

        A.onNext("A - 4")
        A.onNext("A - 5")
        A.onNext("A - 6")
    }
    
    /*
     阻止 Observable 发出相同的元素
     
     distinctUntilChanged 操作符将阻止 Observable 发出相同的元素。
     如果后一个元素和前一个元素是相同的，那么这个元素将不会被发出来。
     如果后一个元素和前一个元素不相同，那么这个元素才会被发出来。
     s
     */
    func distinctUntilChanged() {
        let disposeBag = DisposeBag()

        Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
            .distinctUntilChanged()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}
