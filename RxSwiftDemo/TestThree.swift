//
//  TestThree.swift
//  RxSwiftDemo
//
//  Created by 赵江明 on 2022/3/10.
//

/*
 AsyncSubject ：只发最后一个元素给观察者，有error只出error
 PublishSubject：只发订阅后的元素给观察者，会把error前的元素发出来
 ReplaySubject ：会把订阅前的n个元素以及订阅后的元素发给观察者，会把error前的元素发出来
 BehaviorSubject：有一个默认值如果订阅前没发过元素，就会发默认值，有error只出error
 ControlProperty：专门用于描述UI控件属性，不会出error，一定在主线程上操作
 */
import Foundation
import RxSwift
import RxRelay

struct TestThree {
    
    enum TestError: Error {
        case errorA
        case errorB
    }
    
    let disposeBag = DisposeBag()
    
    /*
     
     它会对随后的观察者发出最终元素。如果Observabl 因为产生了一个 error 事件而中止，
     AsyncSubject 就不会发出任何元素，而是将这个 error 事件发送出来。
     
     1,无Error 无Completed 只有onNext,就是什么都没有,什么也不会触发
     2,无Error 有onNext 有Completed,触发最后一条消息和Completed
     3,只有Completed触发只Completed
     4,有Error触发只Error
     
     */
    func async() {

        let asyncSubject = AsyncSubject<String>()

        asyncSubject.subscribe{print($0)}.disposed(by: disposeBag)

        asyncSubject.onNext("这是第一条消息，不会打印出来")
        asyncSubject.onNext("这是第二条消息，不会打印出来")
        asyncSubject.onError(TestError.errorA)
        asyncSubject.onNext("这是第三条消息")
//        asyncSubject.onCompleted()
    }
    
    /*
     
     只发订阅后的元素给观察者，会把error前的元素发出来
     
     1,无error 无Completed 触发订阅后的所有消息
     2,无error 有Completed 触发订阅后的所有消息和Completed
     3,有error 触发订阅后的所有消息到error位置的消息
     
     */
    func publish() {
        let publishSubject = PublishSubject<String>()

        publishSubject.onNext("订阅前的消息")

        publishSubject.subscribe{print($0)}.disposed(by: disposeBag)

        publishSubject.onNext("订阅后的消息")
        publishSubject.onError(TestError.errorA)
        publishSubject.onNext("再来一条订阅后的")

//        publishSubject.onCompleted()
    }
    
    // ReplaySubject，有的只会将最新的 n 个元素(这个n由我们自己定)发送给观察者，有的只会将限制时间段内最新的元素发送给观察者。
    // 会把订阅前的n个元素以及订阅后的元素发给观察者，会把error前的元素发出来
    func replay() {
        //bufferSize 就是我们上文提到的n
        let replaySubject = ReplaySubject<String>.create(bufferSize: 1)

        replaySubject.onNext("订阅前的消息1")
        replaySubject.onNext("订阅前的消息2")
        replaySubject.onNext("订阅前的消息3")

        replaySubject.subscribe{print($0)}.disposed(by: disposeBag)

        replaySubject.onNext("订阅后的消息")
        //replaySubject.onError(TestError.errorA)
        replaySubject.onNext("再来一条订阅后的")

        replaySubject.onCompleted()
    }
    
    /*
     有一个默认值如果订阅前没发过元素，就会发默认值，有error只出error
     */
    func behavior() {
        let behaviorSubject = BehaviorSubject<String>(value: "默认值")
        //behaviorSubject.onNext("订阅前的消息1")
        //behaviorSubject.onNext("订阅前的消息2")
        //behaviorSubject.onNext("订阅前的消息3")

        behaviorSubject.subscribe{print($0)}.disposed(by: disposeBag)

        behaviorSubject.onNext("订阅后的消息")
        //behaviorSubject.onError(TestError.errorA)
        behaviorSubject.onNext("再来一条订阅后的")

        behaviorSubject.onCompleted()
    }
    
    // 如果想将新值合并到原值上，可以通过 accept() 方法与 value 属性配合来实现。（这个常用在表格上拉加载功能上，BehaviorRelay 用来保存所有加载到的数据）
    func demo5() {
        //创建一个初始值为包含一个元素的数组的BehaviorRelay
        let subject = BehaviorRelay<[String]>(value: ["1"])
         
        //修改value值
        subject.accept(subject.value + ["2", "3"])
         
        //第1次订阅
        subject.asObservable().subscribe {
            print("第1次订阅：", $0)
        }.disposed(by: disposeBag)
         
        //修改value值
        subject.accept(subject.value + ["4", "5"])
         
        //第2次订阅
        subject.asObservable().subscribe {
            print("第2次订阅：", $0)
        }.disposed(by: disposeBag)
         
        //修改value值
        subject.accept(subject.value + ["6", "7"])
    }
}
