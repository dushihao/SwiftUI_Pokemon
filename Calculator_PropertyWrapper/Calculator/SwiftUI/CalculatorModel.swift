//
//  CalculatorModel.swift
//  Calculator
//
//  Created by YYKJ on 2021/4/7.
//  Copyright © 2021 YYKJ. All rights reserved.
//

import Foundation
import Combine

class CalculatorModel: ObservableObject {
//    let objectWillChange = PassthroughSubject<Void, Never>()
//    var brain: CalculatorBrain = .left("0") {
//        willSet {
//            objectWillChange.send()
//        }
//    }
    
    // 自动生成 objectWillChange 避免多个属性时，重复写 willSet { objectWillChange.send() }
    @Published var brain: CalculatorBrain = .left("0")
    
    @Published var history: [CalculatorButtonItem] = []
    
    var historyDetail: String {
        history.map{ $0.description }.joined()
    }
    
    var temporaryKept: [CalculatorButtonItem]  = []
    var totalCount: Int {
        history.count + temporaryKept.count
    }
    
    var slidingIndex: Float = 0 {
        didSet {
            // 维护 history and temporaryKept
            keepHistory(upTo: Int(slidingIndex))
        }
    }
    
    func apply(_ item: CalculatorButtonItem) {
        brain = brain.apply(item: item)
        history.append(item)
        
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "out of index")
        
        let total = history + temporaryKept
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        
        brain = history.reduce(CalculatorBrain.left("0")){ (result, item) in
            result.apply(item: item)
        }
    }
}
