//
//  TestSix.swift
//  RxSwiftDemo
//
//  Created by 赵江明 on 2022/3/10.
//

import Foundation
import RxSwift
import Metal

// 注意：用delay的时候，disposeBag需要是一个属性，不能是一个临时变量，否则将会失效
let disposeBag = DisposeBag()

/*
 
 subscribeOn
 我们用 subscribeOn 来决定数据序列的构建函数在哪个 Scheduler 上运行。
 以上例子中，由于获取 Data 需要花很长的时间，所以用subscribeOn切换到
 后台Scheduler来获取Data。这样可以避免主线程被阻塞。
 
 observeOn
 我们用 observeOn 来决定在哪个 Scheduler 监听这个数据序列。
 以上例子中，通过使用 observeOn 方法切换到主线程来监听并且处理结果。
 
 */
struct TestSix {
   
    enum TestError: Error {
       case errorA
       case errorB
    }

    // 将产生的每一个元素，拖延一段时间后再发出。
    func delay() {
        Observable.just("延迟发送出来的元素")
                   .delay(.seconds(3), scheduler: MainScheduler.instance) //元素延迟3秒才发出
                   .subscribe(onNext: { print($0) })
                   .disposed(by: disposeBag)
    }
    
    /*
     delay是延时发送
     delaySubscription是延时订阅
     */
    func delaySubscribe() {
        Observable.just("这是延时订阅")
            .delaySubscription(.seconds(3), scheduler: MainScheduler.instance) //延迟3秒才开始订阅
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // materialize发出来的是事件，而不是对应的值。
    func materialize() {
        Observable.just("这是materialize 1")
            .materialize()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        /*
        输出结果：
        next(这是materialize)
        completed
        */
        Observable.just("这是materialize 2")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        /*
        输出结果：
        这是materialize
        */
        
        // 如果用了materialize还是要获取值就这样操作
        Observable.just("这是materialize 3")
            .materialize()
            .subscribe(onNext: { (event) in
                switch event {
                case  .error(let err):
                    print(err)
                case .completed:
                    print("completed")
                case let .next(next):
                    print(next)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    func dematerialize() {
        Observable.just("这是materialize")
            .materialize()
            .dematerialize()
            .subscribe(onNext: { string in
                print(string!)
            })
            .disposed(by: disposeBag)
    }
    
    // 如果 Observable 在一段时间内没有产生元素，timeout 操作符将使它发出一个 error 事件。
    func timeout() {
        Observable.just("这是延时订阅")
            .delaySubscription(.seconds(3), scheduler: MainScheduler.instance) //延迟3秒才开始订阅
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // 将一些元素插入到序列的头部
    func startWith() {
        Observable.of("🐶", "🐱", "🐭", "🐹")
            .startWith("1")
            .startWith("2")
            .startWith("3", "🅰️", "🅱️")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // 就是buffer会将我们发出的元素，按照一定的数量，将他们组合成数组，然后再一起发出来。
    func buffer() {
        let subject = PublishSubject<String>()
        subject
            .buffer(timeSpan: .seconds(6), count: 3, scheduler: MainScheduler.instance)
//            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("1")
        subject.onNext("2")
//        subject.onNext("3")
    }
    
    func window() {
        let subject = PublishSubject<String>()
        subject
            .window(timeSpan: .seconds(3), count: 3, scheduler: MainScheduler.instance)
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)

        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
    }
    
    func groupBy() {
        Observable<Int>.of(0, 1, 2, 3, 4, 5,3,2,1)
            .groupBy(keySelector: { (element) -> String in
                return element % 2 == 0 ? "偶数" : "基数"
            })
            .subscribe { (event) in
                print(event)
                switch event {
                case .next(let group):
                    group.asObservable().subscribe({ (event) in
                        print(" key: \(group.key)     \(event)")
                    })
                default:
                    print("")
                }
            }
            .dispose()
    }
    
    // 如果发送的数量大于1或者 什么都没做，就发出一个错误事件
    func single() {
        Observable.of(1,2,3)
        .single()
        .subscribe{
            print($0)
        }.disposed(by: disposeBag)
    }
    
    // 当同时监听多个Observable 时，选择其中一个，即amb(b)，就不监听另外一个。
    func amb() {
        let a = BehaviorSubject(value: "🐱")
        let b = BehaviorSubject(value: "🐶")

        Observable.of(a,b)
        .flatMap{$0}
        .amb(b)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)

        a.onNext("🐦")
        b.onNext("🐔")
        a.onNext("🦆")
    }
    
    // 持续的将 Observable 的每一个元素应用一个函数，然后发出最终结果
    func reduce() {
        Observable.of(1, 2, 3)
            .reduce(2, accumulator: *)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        // 打印结果 = 1 * 2 * 3 * 2 = 12
    }
    
    func rx_do() {
        Observable.of(1, 2, 3)
            .do(onNext: { element in
                print("do next:" ,element)
            }, onError: { error in
                print("do error:", error)
            }, onCompleted: {
                print("do completed")
            }, onSubscribe: {
                print("do subscribe")
            }, onSubscribed: {
                print("do subscribed")
            }, onDispose: {
                print("do dispose")
            })
            .subscribe { event in
                switch event {
                case .next(let element):
                    print("element:", element)
                case .error(let error):
                    print("error:", error)
                case .completed:
                    print("completed")
                }}
            .disposed(by: disposeBag)
    }
    
    func using() {
        //一个无限序列（每隔0.1秒创建一个序列数 ）
        let infiniteInterval = Observable<Int>
            
            .interval(.milliseconds(100), scheduler: MainScheduler.instance)
            .do(
                onNext: { print("infinite: \($0)") },
                onSubscribe: { print("开始订阅 infinite")},
                onDispose: { print("销毁 infinite")}
            )

        //一个有限序列（每隔0.5秒创建一个序列数，共创建三个 ）

        let limited = Observable<Int>
                .interval(.milliseconds(500), scheduler: MainScheduler.instance)
            .take(2)
            .do(
                onNext: { print("limited: \($0)") },
                onSubscribe: { print("开始订阅 limited")},
                onDispose: { print("销毁 limited")}
            )
    }
}
