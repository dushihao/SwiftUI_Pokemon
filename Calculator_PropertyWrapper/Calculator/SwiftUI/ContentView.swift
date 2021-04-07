//
//  ContentView.swift
//  Calculator
//
//  Created by YYKJ on 2020/7/31.
//  Copyright © 2020 YYKJ. All rights reserved.
//

import SwiftUI
import Combine

let scale: CGFloat = UIScreen.main.bounds.width / 414

struct ContentView: View {
    
//    @State private var brain: CalculatorBrain = .left("0")
//    @ObservedObject var model = CalculatorModel()
    @EnvironmentObject var model: CalculatorModel
    @State private var editingHistory = false
    @State private var showResult = false
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button("操作履历") {
                self.editingHistory = true
                print(self.model.history)
            }.sheet(isPresented: $editingHistory) {
                // 练习2: dismiss modal
                HistoryView(model: model, editingHistory: $editingHistory)
            }
            Text(model.brain.output)
                .font(.system(size:76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                // 联系1: 使用 @State 控制 Alert 弹窗
                .alert(isPresented: $showResult) {
                    Alert(title: Text("hello"), message: Text(model.historyDetail + "\n" + model.brain.output), dismissButton: .default(Text("OK")))
                }.onTapGesture {
                    self.showResult = true
                    print("What the fuck! you touched me!")
                }
            CalculatorButttonPad()
                .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone SE")
    }
}

struct CalculatorButttonPad: View {
//    @Binding var brain: CalculatorBrain
//    var model: CalculatorModel
    
    let pad : [[CalculatorButtonItem]] = [
        [.command(.clear), .command(.flip), .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]
    
    var body: some View {
        VStack(spacing:8) {
            ForEach(pad, id: \.self) { row in
//                CalculatorButtonRow(row: row, model: self.model)
                CalculatorButtonRow(row: row)
            }
        }
    }
}

struct CalculatorButtonRow : View {
    let row: [CalculatorButtonItem]
    
//    @Binding var brain: CalculatorBrain
//    var model: CalculatorModel
    @EnvironmentObject var model: CalculatorModel
    
    var body: some View {
        HStack {
            ForEach (row, id: \.self) { item in
                CalculatorButton(title: item.title, size: item.size, backgroundColorName: item.backgroundColorName) {
                    self.model.apply(item)
                    print("Button:\(item.title)")
                }
            }
        }
    }
}

struct CalculatorButton: View {
//    @Binding var brain: CalculatorBrain
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize * scale))
                .foregroundColor(.white)
                .frame(width: size.width * scale, height: size.height * scale)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width * scale / 2)
        }
    }
}


struct HistoryView: View {
    @ObservedObject var model: CalculatorModel
    @Binding var editingHistory: Bool
    
    var body: some View {
        VStack {
            Button("关闭"){
                self.editingHistory = false
                print("close!")
            }.padding(10)
            
            if model.totalCount == 0 {
                Text("没有履历")
            } else {
                HStack {
                    Text("履历").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                HStack {
                    Text("显示").font(.headline)
                    Text("\(model.brain.output)").lineLimit(nil)
                }
                Slider(
                    value: $model.slidingIndex,
                    in: 0...Float(model.totalCount),
                    step: 1
                )
            }
        }.padding()
    }
}
