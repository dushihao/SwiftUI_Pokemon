# SwiftUI

### 数据状态和绑定练习

1. 使用@State控制Alert弹窗

   同 `editingHistory` 一样，添加额外的属性，控制 Alert 弹窗 , 当用户点击Alert弹窗关闭时，SwiftUI会通过`self.showResult` 这个 `binding` 把值设置为 false。

```
   Text(model.brain.output)
        .font(.system(size:76))
        .minimumScaleFactor(0.5)
        .padding(.trailing, 24)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        .alert(isPresented: $showResult) {
               Alert(title: Text("hello"), message: Text(model.historyDetail + "\n" + model.brain.output), dismissButton: .default(Text("OK")))
                   }.onTapGesture {
                       self.showResult = true
                       print(" you touched me!")
                   }
```

   

2. 关闭回溯界面

   同练习1类似，将`editingHistory` 这个`binding` 赋值给 `HistoryView` ，通过修改属性值，实现dismiss model。

   
3. 修正计算器模型中的 bug

   我在枚举` CalculatorBrain` 多添加了一种状态：结果值状态，也就是用户输入了等号的状态。（:P但是感觉应该有更好的办法啊）

```
   enum CalculatorBrain {
   	case left(String)
   	case leftOp(left: String, op: CalculatorButtonItem.Op)
   	case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String)
   	case equal(String) 
   	case error
   
   // ...
   }
```

   
