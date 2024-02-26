//
//  MainTab.swift
//  PokeMaster
//
//  Created by Dush on 2024/1/20.
//  Copyright © 2024 OneV's Den. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    var body: some View {
        TabView {
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("列表")
            }
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    MainTab()
}
