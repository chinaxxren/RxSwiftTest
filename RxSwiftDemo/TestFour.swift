//
//  TestFour.swift
//  RxSwiftDemo
//
//  Created by 赵江明 on 2022/3/10.
//


import Foundation
import RxSwift

struct TestFour {
   
    enum TestError: Error {
       case errorA
       case errorB
    }
   
    struct Person {
        var name:String!
        var age:Int!
        
        init(dic:Dictionary<String,Any>) {
            self.name = dic["name"] as? String
            self.age = dic["age"] as? Int
        }
    }
    
    let disposeBag = DisposeBag()

    // 通过一个转换函数，将 Observable 的每个元素转换一遍
    func map() {
        let arr:[Dictionary<String,Any>] = [
                    ["name":"张三","age":23],
                    ["name":"李四","age":33],
                    ["name":"王五","age":22],]
                
        Observable.from(arr)
            .map { Person(dic: $0) }
            .subscribe(onNext: { print($0.name!) })
            .disposed(by: disposeBag)
    }
    
    // C是一个领班，A和B是工人，领班通过 flatMap把A和B招进来，然后当AB工作时(onNext)，领班就能知道A和B都做了什么。
    func flatMap() {
        let A = BehaviorSubject(value: "A的默认消息")
        let B = BehaviorSubject(value: "B的默认消息")

        Observable.of(A,B)//同时观察了A，B
        .flatMap {$0} //将Observable的元素转换成其他的Observable"，把对 A/B 的观察" 转成 "A/B 观察的字符串"
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)

        A.onNext("A-2")
        A.onNext("A-3")
        B.onNext("B-2")
        B.onNext("B-3")
        B.onNext("B-4")
    }
    
    // A比B先进工厂 ，在B还没进工厂前，领班C需要看着A。B进工厂后，领班觉得A做得熟练了，就不管A了，只看着B。
    func flatMapLast() {
        let A = BehaviorSubject(value: "A的默认消息")
        let B = BehaviorSubject(value: "B的默认消息")

        Observable.of(A,B)
        .flatMapLatest {$0}
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)

        A.onNext("A-2")
        A.onNext("A-3")
        B.onNext("B-2")
        B.onNext("B-3")
        B.onNext("B-4")
    }
    
    
    // 在第一个Observable 元素onCompleted()后，第二个Observable 元素可以发出第一个结束前发出的最后一个onNext()
    func contactMap() {
        let A = BehaviorSubject(value: "A的默认消息")
        let B = BehaviorSubject(value: "B的默认消息")

        Observable.of(A,B)
        .concatMap {$0}
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)

        A.onNext("A-2")
        B.onNext("B-2")
        B.onNext("B-3")
        A.onCompleted()
        A.onNext("A-3")
        B.onNext("B-4")
    }
    
    /*
     scan操作符将对第一个元素应用一个函数，将结果作为第一个元素发出。
     然后，将结果作为参数填入到第二个元素的应用函数中，创建第二个元素。
     以此类推，直到遍历完全部的元素 相当于求总和sum
     */
    func scan() {
        let disposeBag = DisposeBag()

        Observable.of(10, 100, 1000)
        .scan(0) { aValue, newValue in
            aValue + newValue
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    }
}
