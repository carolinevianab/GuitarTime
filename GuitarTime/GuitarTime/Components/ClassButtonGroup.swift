//
//  classButtonGroup.swift
//  GuitarTime
//
//  Created by Caroline Viana on 24/08/23.
//

import SwiftUI

struct ClassButtonGroup: View {
    
    @Binding var isMovementDisabled: Bool
    
    var handlerBack: () -> Void
    var handlerPlayPause: () -> Void
    var handlerForw: () -> Void
    
    var body: some View {
        HStack {
            CircularButton(symbol: AppStrings.sysimgBack, action: handlerBack, bgColor: AppColors.brandDark)
                .opacity(!isMovementDisabled ? 1 : 0.4)
                .disabled(isMovementDisabled)
                
            
            CircularButton(symbol: isMovementDisabled ? AppStrings.sysimgPause : AppStrings.sysimgPlay, action: handlerPlayPause)
            
            CircularButton(symbol: AppStrings.sysimgForw, action: handlerForw, bgColor: AppColors.brandDark)
                .opacity(!isMovementDisabled ? 1 : 0.4)
                .disabled(isMovementDisabled)
        }
    }
}

struct classButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        ClassButtonGroup(isMovementDisabled: .constant(false), handlerBack: {}, handlerPlayPause: {}, handlerForw: {})
    }
}
