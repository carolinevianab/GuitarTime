//
//  VisualTimer.swift
//  GuitarTime
//
//  Created by Caroline Viana on 12/09/23.
//

import SwiftUI
import AVFoundation

struct VisualTimer: View {
    @StateObject var vm: VisualTimerViewModel
    
    // MARK: body
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .trim()
                    .stroke(AppColors.brandDark.opacity(0.2), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: vm.currentFrame)

                Circle()
                    .trim(from: 0, to: vm.currentPercentage)
                    .stroke(AppColors.brandPrimary, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: vm.currentFrame)
            }
            .rotationEffect(.degrees(-90))

            Text("\(Utils.convertSecondsToString(vm.currentTime))")
                .font(.system(size: vm.currentFrame/5, design: .monospaced))
                .foregroundColor(setTimeColor())
                
        }
    }
    
    // MARK: setTimeColor
    func setTimeColor() -> Color {
        vm.isCompleted() ? .green : .primary
    }

    
}

// MARK: - Previews

struct VisualTimer_Previews: PreviewProvider {
    static var previews: some View {
        VisualTimer_PreviewProvider()
    }
}

struct VisualTimer_PreviewProvider: View {
    var body: some View {
        VisualTimer(vm: VisualTimerViewModel())
    }
}


