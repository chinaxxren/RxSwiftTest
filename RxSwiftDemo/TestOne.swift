//
//  TestOne.swift
//  RxSwiftDemo
//
//  Created by 赵江明 on 2022/3/10.
//

import RxSwift

struct TestOne {
    
    let disposeBag = DisposeBag()
    
    func flat() {
        
        let test = Observable.of("1", "2", "3", "4", "5").flatMap { Observable.just($0) }
        test.subscribe(onNext: {
            print($0)
        })
        .disposed(by:disposeBag)
        
        let A = BehaviorSubject(value: "A的默认消息")
        let B = BehaviorSubject(value: "B的默认消息")

        Observable.of(A,B)
        .flatMap {$0}
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)

        A.onNext("A-2")
        A.onNext("A-3")
        B.onNext("B-2")
        B.onNext("B-3")
        B.onNext("B-4")
    }
    
    func sample() {
        let firstSubject = PublishSubject<String>()
        let secondSubject = PublishSubject<String>()

        // 一同成对出现
        firstSubject.sample(secondSubject).subscribe(onNext: { (memo) in
            print(memo)
        }).disposed(by:disposeBag)


        firstSubject.onNext("1")

        secondSubject.onNext("A")
        firstSubject.onNext("2")
        secondSubject.onNext("B")
        secondSubject.onNext("C")
        firstSubject.onNext("3")
        firstSubject.onNext("4")
        secondSubject.onNext("D")
        firstSubject.onNext("5")
    }
    
    func withLatestFrom() {
        let firstSubject = PublishSubject<String>()
        let secondSubject = PublishSubject<String>()

        firstSubject.withLatestFrom(secondSubject){
                  (first, second) in
                  return first + second
        }
        .subscribe(onNext: { print($0) })
        .disposed(by:disposeBag)

        firstSubject.onNext("1")
        
        secondSubject.onNext("A")
        
        firstSubject.onNext("2")
        
        secondSubject.onNext("B")
        secondSubject.onNext("C")
        secondSubject.onNext("D")
        
        firstSubject.onNext("3")
        firstSubject.onNext("4")
        firstSubject.onNext("5")
    }
    
    func merge() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()

//        Observable.of(subject1, subject2)
//            .merge()
//            .subscribe(onNext: { print("订阅到：\($0)") })
//            .disposed(by: disposeBag)

        Observable.merge([subject1,subject2]).map({ (str) -> String in
            print(str)
            return str
        }).subscribe(onNext: { print("订阅到：\($0)") }).disposed(by: disposeBag)
        subject1.onNext("🅰️")
        subject1.onNext("🅱️")
        subject2.onNext("①")
        subject2.onNext("②")
        subject1.onNext("🆎")
        subject2.onNext("③")
    }
}
