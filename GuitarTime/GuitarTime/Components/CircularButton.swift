//
//  CircularButton.swift
//  GuitarTime
//
//  Created by Caroline Viana on 26/08/23.
//

import SwiftUI

struct CircularButton: View {
    let symbol: String
    let action: () -> Void
    let bgColor: Color
    
    init(symbol: String, action: @escaping () -> Void, bgColor: Color = AppColors.brandPrimary) {
        self.symbol = symbol
        self.action = action
        self.bgColor = bgColor
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(bgColor)
                .frame(width: 70)
                .shadow(color: .gray.opacity(0.7),radius: 2)
            
            Image(systemName: symbol)
                .foregroundColor(Color(uiColor: .systemBackground))
                .font(.system(size: 35))
        }.padding()
        .onTapGesture {
            action()
        }
    }
}

struct CircularButton_Previews: PreviewProvider {
    static var previews: some View {
        CircularButton(symbol: "play", action: {})
    }
}
