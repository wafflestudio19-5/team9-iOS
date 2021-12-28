//
//  SwiftUIRepresentable.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/28.
//

import Foundation
import SwiftUI

struct SwiftUIRepresentable: UIViewRepresentable {
    let view: UIView
    
    func makeUIView(context: Context) -> some UIView {
        return self.view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // do nothing
    }
}
