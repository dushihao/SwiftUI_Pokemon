//
//  BlurView.swift
//  PokeMaster
//
//  Created by YYKJ on 2021/4/8.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)

        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)]
        )
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

extension View {
    func blurBackground(style: UIBlurEffect.Style) -> some View {
        ZStack {
            BlurView(style: style)
            self
        }
    }
}
