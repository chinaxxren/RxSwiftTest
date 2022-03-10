//
//  TestSeven.swift
//  RxSwiftDemo
//
//  Created by 赵江明 on 2022/3/10.
//

import Foundation

import RxSwift

struct TestSeven {
   
    enum TestError: Error {
       case errorA
       case errorB
    }
   
    // 从一个错误事件中恢复，将错误事件替换成一个备选序列
    func catchError() {
        let a = PublishSubject<String>()
        let b = PublishSubject<String>()
        
        a.catch {
            print("===\($0)==")
            return b
            }.subscribe(onNext: { (str) in
                print(str)
            }).disposed(by: disposeBag)
        
        a.onNext("a-1")
        a.onNext("a-2")
        a.onError(TestError.errorA)
        b.onNext("b-1")
    }
    
    // catchErrorJustReturn 操作符会将error事件替换成其他的一个元素，然后结束该序列。
    func catchErrorJustReturn() {
        let a = PublishSubject<String>()
//        let b = PublishSubject<String>()

        a.catchAndReturn("❌").subscribe(onNext: { (str) in
                print(str)
            }).disposed(by: disposeBag)

        a.onNext("a-1")
        a.onNext("a-2")
        a.onError(TestError.errorA)
//        b.onNext("b-1")
    }
    
    func retry() {
        var count = 1

        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("🍎")
            observer.onNext("🍐")
            observer.onNext("🍊")

            if count == 1 {
                observer.onError(TestError.errorA)
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
            .retry()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func retry2() {
        var count = 1

        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("🍎")
            observer.onNext("🍐")
            observer.onNext("🍊")

            if count < 5 {
                observer.onError(TestError.errorA)
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
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
}
