//
//  ContentView.swift
//  BenTenWatch Watch App
//
//  Created by Timothy Andrian on 07/07/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var isHidden: Bool = false
    @State var isActive = false
    @State var isCoolDown = false
    
    @State var diamondColor = Color.grayBen
    @State var activeColor = Color.white
    @State var backgroundColor = Color.greenBen
    
    @State var offSetPosition:CGFloat = 110
    let animationDuration = 0.4
    let diamonDiameter:CGFloat = 200
    
    @State private var audioPlayer: AVAudioPlayer?
    
    func playSound(sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    var body: some View {
        ZStack {
            if isHidden {
                Rectangle()
                    .fill(backgroundColor)
                    .ignoresSafeArea()
            } else {
                if isActive {
                    Rectangle()
                        .fill(activeColor)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(Animation.linear(duration: animationDuration).repeatForever()) {
                                activeColor = Color.red
                            }
                            withAnimation(Animation.linear(duration: animationDuration).delay(2.5)) {
                                activeColor = Color.white
                                isActive = false
                                isCoolDown = true
                                backgroundColor = Color.red
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                                isCoolDown = false
                                backgroundColor = Color.greenBen
                                playSound(sound: "CooledBig")
                            }
                            playSound(sound: "CooldownBig")
                        }
                } else {
                    if isCoolDown {
                        Rectangle()
                            .fill(backgroundColor)
                            .ignoresSafeArea()
                    } else {
                        Rectangle()
                            .fill(backgroundColor)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(Animation.linear(duration: 0.4)) {
                                    offSetPosition = 0
                                    isHidden = true
                                    backgroundColor = Color.grayBen
                                    diamondColor = .grayBen
                                }
                            }
                    }
                }
            }
            Diamond()
                .offset(x: -offSetPosition,y: -5)
                .stroke(.black, lineWidth: 20)
                .fill(.greenBen)
                .frame(width: diamonDiameter-50,height: diamonDiameter+200)
            if isHidden {
                HorizontalCarousel(imageNames: ["monsterOne", "monsterTwo"])
                    .offset(y: -20)
                    .onTapGesture {
                        withAnimation(Animation.linear(duration: 0.4)) {
                            offSetPosition = 110
                            isHidden = false
                            isActive = true
                            diamondColor = .grayBen
                        }
                        playSound(sound: "TransformBig")
                    }
                    .onAppear{
                        playSound(sound: "ActiveSound")
                    }
            }
            Diamond()
                .offset(x: -offSetPosition,y: -5)
                .symmetricDifference(Diamond().offset(x: offSetPosition, y: -5))
                .stroke(.black, lineWidth: 20)
                .fill(diamondColor)
                .frame(width: diamonDiameter-50,height: diamonDiameter+200)
        }
    }
}

struct HorizontalCarousel: View {
    var imageNames: [String]
    @State private var selectedImageIndex: Int = 0
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    
                    ZStack(alignment: .topLeading) {
                        Image("\(imageNames[index])")
                            .resizable()
                            .frame(width: 100, height: 150)
                    }
                }
            }
            .frame(height: 300)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onChange(of: selectedImageIndex) { oldValue, newValue in
                playSound(sound: "Picking2")
            }
        }
    }
    func playSound(sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: CGPoint(x: center.x, y: rect.minY))

        path.addLine(to: CGPoint(x: rect.maxX, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: center.y))
        path.closeSubpath()

        return path
    }
}

#Preview {
    ContentView()
}
