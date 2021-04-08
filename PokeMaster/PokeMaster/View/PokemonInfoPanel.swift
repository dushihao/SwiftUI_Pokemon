//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by YYKJ on 2021/4/8.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonInfoPanel: View {
    let model: PokemonViewModel
    var abilities: [AbilityViewModel] {
        AbilityViewModel.sample(pokemonID: model.id)
    }
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width:40, height: 6)
            .opacity(0.2)
    }
    
    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            topIndicator
            header(model: model)
            pokemonDescription
            Divider()
            AbilityList(model: model, abilityModels: abilities)
        }
        .padding(EdgeInsets(top: 12, leading: 30, bottom: 30, trailing: 30))
        .cornerRadius(20)
        .blurBackground(style: .systemMaterial)
//        .background(Color.white)
        .fixedSize(horizontal: false, vertical: true)
    }
}

extension PokemonInfoPanel {
    struct header: View {
        let model: PokemonViewModel
        
        var pokemonIcon: some View {
            Image("Pokemon-\(model.id)")
                .resizable()
                .frame(width: 68, height: 68)
        }
        
        var nameSpecies: some View {
            VStack(spacing: 10) {
                VStack {
                    Text(model.name)
                        .font(.system(size: 22))
                        .foregroundColor(model.color)
                        .fontWeight(.bold)
                    Text(model.nameEN)
                        .font(.system(size: 13))
                        .foregroundColor(model.color)
                        .fontWeight(.bold)
                }
                Text(model.genus)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
            }
        }
        
        var bodyStatus: some View {
            VStack(alignment:.leading) {
                HStack {
                    Text("身高")
                        .foregroundColor(.gray)
                        .font(.system(size: 11))
                    Text(model.height)
                        .foregroundColor(model.color)
                        .font(.system(size: 11))
                }
                HStack {
                    Text("体重")
                        .foregroundColor(.gray)
                        .font(.system(size: 11))
                    Text(model.weight)
                        .foregroundColor(model.color)
                        .font(.system(size: 11))
                }
            }
        }
        
        var typeInfo: some View {
            HStack {
                Text(model.types[0].name)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 14)
                    .background(
                        RoundedRectangle(cornerRadius: 7)
                            .fill(model.types[0].color)
                    )
                    
                Text(model.types[1].name)
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 14)
                    .background(
                        RoundedRectangle(cornerRadius: 7)
                            .fill(model.types[1].color)
                    )
            }
        }
        
        var body: some View {
            HStack(spacing: 18) {
                pokemonIcon
                nameSpecies
                Divider().frame(width: 1, height: 40)
                VStack(spacing: 12) {
                    bodyStatus
                    typeInfo
                }
            }
        }
    }
}

extension PokemonInfoPanel {
    struct AbilityList: View {
        let model: PokemonViewModel
        let abilityModels: [AbilityViewModel]?

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("技能")
                    .font(.title)
                    .fontWeight(.bold)
                if abilityModels != nil {
                    ForEach(abilityModels!) { ability in
                        Text(ability.name)
                            .font(.subheadline)
                            .foregroundColor(model.color)
                        Text(ability.descriptionText)
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0xAAAAAA))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }.frame(maxWidth:.infinity, alignment: .leading)
        }
        
    }
}

struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: .sample(id: 1))
    }
}
