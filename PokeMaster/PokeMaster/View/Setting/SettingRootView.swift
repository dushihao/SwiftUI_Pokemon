//
//  SettingRootView.swift
//  PokeMaster
//
//  Created by YYKJ on 2021/4/10.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingRootView: View {
    var body: some View {
        NavigationView{
            SettingView().navigationBarTitle("设置")
        }
    }
}

struct SettingRootView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRootView()
    }
}
