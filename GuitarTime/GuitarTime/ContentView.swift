//
//  ContentView.swift
//  GuitarTime
//
//  Created by Caroline Viana on 23/08/23.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 0) {
                Rectangle().fill(Color(red: 247/255,
                                       green: 127/255,
                                       blue: 0/255))
                
                Rectangle().fill(Color(red: 252/255,
                                       green: 191/255,
                                       blue: 73/255))
                
                Rectangle().fill(Color(red: 33/255,
                                       green: 15/255,
                                       blue: 4/255))
                
                Rectangle().fill(Color(red: 162/255,
                                       green: 62/255,
                                       blue: 72/255))
                
                Rectangle().fill(Color(red: 0/255,
                                       green: 70/255,
                                       blue: 67/255))
            }
            
            HStack(spacing: 0) {
                Rectangle().fill(Color(red: 237/255,
                                       green: 145/255,
                                       blue: 46/255))
                
                Rectangle().fill(Color(red: 252/255,
                                       green: 191/255,
                                       blue: 73/255))
                
                Rectangle().fill(Color(red: 246/255,
                                       green: 221/255,
                                       blue: 211/255))
                
//                F6DDD3
                
                HStack(spacing: 0) {
//                    Rectangle().fill(Color(red: 213/255,
//                                           green: 103/255,
//                                           blue: 114/255))
                    
                    Rectangle().fill(Color(red: 185/255,
                                           green: 86/255,
                                           blue: 97/255))
                }
                
                HStack(spacing: 0) {
//                    Rectangle().fill(Color(red: 55/255,
//                                           green: 151/255,
//                                           blue: 146/255))
                    
                    Rectangle().fill(Color(red: 49/255,
                                           green: 136/255,
                                           blue: 131/255))
                }
            }
        }
    }

 
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
