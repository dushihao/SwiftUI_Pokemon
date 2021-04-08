//
//  PokemonList.swift
//  PokeMaster
//
//  Created by YYKJ on 2021/4/8.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    @State var expandedIndex: Int?
    var body: some View {
        ScrollView {
            ForEach(PokemonViewModel.all) { pokemonViewModel in
                PokemonInfoRow(model: pokemonViewModel, expanded: self.expandedIndex == pokemonViewModel.id)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.55,
                                              dampingFraction: 0.425,
                                              blendDuration: 0))
                        {
                            if self.expandedIndex == pokemonViewModel.id {
                                self.expandedIndex = nil
                            } else {
                                self.expandedIndex = pokemonViewModel.id
                            }
                        }
                    }
            }
        }.overlay(
            VStack {
                Spacer()
                PokemonInfoPanel(model: .sample(id: 1))
            }.edgesIgnoringSafeArea(.bottom)
        )
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}
