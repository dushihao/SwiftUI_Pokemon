//
//  SettingView.swift
//  PokeMaster
//
//  Created by YYKJ on 2021/4/9.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var setting = Settings()
    
    var accountSection: some View {
        Section(header: Text("账户")) {
            Picker(selection: $setting.accountBehavior, label: Text("")) {
                ForEach(Settings.AccountBehavior.allCases, id:\.self) {
                    Text($0.text)
                }
            }.pickerStyle(SegmentedPickerStyle())
            TextField("电子邮箱", text: $setting.email)
            SecureField("密码", text: $setting.password)
            if setting.accountBehavior == .register {
                SecureField("确认密码", text: $setting.verifyPassword)
            }
            Button(setting.accountBehavior.text){
                print("登录/注册")
            }
        }
    }
    
    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: $setting.showEnglishName, label: {
                Text("显示英文名")
            })
            Picker(selection: $setting.sorting, label: Text("排序方式")) {
                ForEach(Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }.pickerStyle(DefaultPickerStyle())
            Toggle(isOn: $setting.showFavoriteOnly, label: {
                Text("只显示收藏")
            })
        }
    }
    
    var actionSection: some View {
        Section {
            Button("清空缓存") {
                 
            }.foregroundColor(.red)
        }
    }
    
    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

class Settings: ObservableObject {
    
    enum AccountBehavior: CaseIterable {
        case register, login
    }
    
    enum Sorting: CaseIterable {
        case id, name, color, favorite
    }
    
    @Published var accountBehavior = AccountBehavior.login
    @Published var email = ""
    @Published var password = ""
    @Published var verifyPassword = ""
    
    @Published var showEnglishName = true
    @Published var sorting = Sorting.id
    @Published var showFavoriteOnly = false
}

extension Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
    
}

extension Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register:
            return "注册"
        case .login:
            return "登录"
        }
    }
    
}

