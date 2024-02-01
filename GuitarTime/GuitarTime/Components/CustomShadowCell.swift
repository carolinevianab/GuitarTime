//
//  CustomShadowCell.swift
//  GuitarTime
//
//  Created by Caroline Viana on 10/09/23.
//

import SwiftUI

struct CustomShadowCell<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background()
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.6),radius: 2)
    }
}

struct CustomShadowCell_Previews: PreviewProvider {
    static var previews: some View {
        CustomShadowCell() {
            Text("Hello World :D")
        }
        .padding()
    }
}

struct ShadowCard<Content: View>: View {
    let content: Content
    let w: CGFloat
    let h: CGFloat
    
    init(width: CGFloat, height: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        w = width
        h = height
    }
    
    var body: some View {
        VStack(alignment: .center) {
            content
        }
        .frame(width: w, height: h)
        .padding()
        .background()
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.6),radius: 2)
    }
}
