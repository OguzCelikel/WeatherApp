//
//  HomeScreenViews.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 10.08.2024.
//

import Foundation
import SwiftUI
import Lottie

struct BackgroundView: View {
    var colors: [Color]

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .bottom,
            endPoint: .top
        )
        .ignoresSafeArea()
    }
}

struct CityTextView: View {
    
    var cityName: String
    var body: some View {
        HStack {
            Text(cityName)
                .font(.system(size: 32, weight: .medium, design: .default))
                .foregroundColor(.white)
                .padding()
        }
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 10) {
            LottieView(animationFileName: imageName, loopMode: .loop)
                .frame(width: 180, height: 180)
                .padding(20)
            
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}

struct LottieView: UIViewRepresentable {
    
    var animationFileName: String
    let loopMode: LottieLoopMode
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFill
        return animationView
    }
}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            LottieView(animationFileName: imageName, loopMode: .loop)
                .frame(width: 40, height: 40)
                .padding(6)
            
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}


