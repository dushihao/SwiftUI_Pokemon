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

    init(style: UIBlurEffect.Style) {
        print("init")
        self.style = style
    }
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        print("makeUIView")
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

    // 练习 2
    func updateUIView(_ uiView: UIView, context: Context) {
        print("updateUIView")
        for view in uiView.subviews {
            if view is UIVisualEffectView {
                print("got it")
                if let effectView = view as? UIVisualEffectView {
                    let blurEffect = UIBlurEffect(style: style)
                    effectView.effect = blurEffect
                }
            }
        }
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
