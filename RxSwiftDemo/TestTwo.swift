//
//  TestTwo.swift
//  RxSwiftDemo
//
//  Created by 赵江明 on 2022/3/10.
//

import Foundation
import RxSwift

struct TestTwo {
    
    let disposeBag = DisposeBag()
    
    // 一旦观察者有监听到error事件，那么就会在触发onError:闭包结束后，停止监听 并不会执行后面的onCompleted或者其他事件
    // Observable 可监听的
    func create() {
        
        enum MyError: Error {
            case errorA
            case errorB
        }
        
        //创建序列
        let testOB = Observable<String>.create { ob in
            //发送next事件
            ob.onNext("test1")
            ob.onNext("test2")
            ob.onNext("test3")
            //发送error事件
            ob.onError(MyError.errorA)
            //发送completed事件
            ob.onCompleted()
            return Disposables.create()
        }
        
        //订阅序列
        testOB.subscribe(onNext: { (str) in
            print(str)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        }).disposed(by: disposeBag)
    }
    
    // Any Observer 事件监听
    func observer() {
        let observer: AnyObserver<String> = AnyObserver { (event) in
            switch event {
            case .next(let str):
                print("next event: \(str)")
            case .error(let error):
                print("have an error: \(error)")
            case .completed:
                print("observer complete")
            }
        }
        
//        let ob:Observable<String> = Observable.just("this is a message from just")
        let ob:Observable<String> = Observable.of("this is a message from of")
        ob.subscribe(observer).disposed(by: disposeBag)
    }
    
    func mutlOberver() {
        enum MyError: Error {
            case errorA
            case errorB
        }
        
        let observer: AnyObserver<String> = AnyObserver { (event) in
            switch event {
            case .next(let str):
                print("next event: \(str)")
            case .error(let error):
                print("have an error: \(error)")
            case .completed:
                print("observer complete")
            }
        }
        
        let ob:Observable<String> = Observable.just("this is a message from just")
        ob.subscribe(observer).disposed(by: disposeBag)
        
        //只发送一个error
        let ob2 = Observable<String>.error(MyError.errorA)
        ob2.subscribe(observer).disposed(by: disposeBag)
        
        //只发送一个completed
        let ob3 =  Observable<String>.empty()
        ob3.subscribe(observer).disposed(by: disposeBag)
    }
    
    func binder() {
        //创建序列
       let testOB = Observable<String>.create { ob in
           ob.onNext("this is label text")
           ob.onCompleted()
           return Disposables.create()
       }
       
       //订阅序列
       testOB.subscribe(onNext: { (str) in
           print("str = \(str)")
       }).disposed(by: disposeBag)
    }
}
