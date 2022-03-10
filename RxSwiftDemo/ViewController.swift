//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 赵江明 on 2022/1/11.
//

import UIKit
import RxSwift
import RxCocoa

// https://juejin.cn/post/6844903927574429703

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let test = TestSeven()
        test.retry2()
    }
    
}

