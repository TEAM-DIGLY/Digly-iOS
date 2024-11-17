//
//  LiveDigly.swift
//  digly
//
//  Created by Neoself on 11/17/24.
//
import SwiftUI

struct LiveDigly : View {
    var isFocused: Bool = false
    var value: String = ""
    
    @State private var eyeXOffset: CGFloat = 0
    @State private var eyeYOffset: CGFloat = 0
    @State private var eyeSize: CGFloat = 8
    
    var body : some View{
        ZStack {
            Circle()
                .fill(.neutral5)
                .frame(width: 62, height: 62)
            
            HStack(spacing: 6) {
                Circle()
                    .fill(.common100)
                    .frame(width: eyeSize, height: eyeSize)
                
                Circle()
                    .fill(.common100)
                    .frame(width: eyeSize, height: eyeSize)
            }
            .offset(x: eyeXOffset)
            .offset(y: 6 + eyeYOffset)
        }
        .onChange(of: isFocused){
            if !isFocused {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.longEaseInOut){
                        eyeXOffset = 0
                        eyeYOffset = 0
                    } }
            } else {
                withAnimation(.spring(response:0.2,dampingFraction: 0.5)) { eyeSize = 14 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.longEaseInOut){
                        eyeSize = 8
                        eyeYOffset = 8
                    } }
            }
        }
        .onChange(of: value) {
            let progress = CGFloat($1.count) / 15.0
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6)){
                eyeXOffset = min(10,-10 + (progress * 20))
            }
        }
    }
}
