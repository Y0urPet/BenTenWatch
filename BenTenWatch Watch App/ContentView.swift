//
//  ContentView.swift
//  BenTenWatch Watch App
//
//  Created by Timothy Andrian on 07/07/24.
//

import SwiftUI

struct ContentView: View {
    @State var isHidden: Bool = false
    @State var offSetPosition:CGFloat = 110
    @State var diamondColor = Color.grayBen
    let diamonDiameter:CGFloat = 200
    @State var isActive = false
    @State var activeColor = Color.white
    @State var isCoolDown = false
    
    var body: some View {
        ZStack {
            if isHidden {
                Rectangle()
                    .fill(.grayBen)
                    .ignoresSafeArea()
            } else {
                if isActive {
                    Rectangle()
                        .fill(activeColor)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(Animation.linear(duration: 0.4)) {
                                activeColor = Color.red
                            }
                            withAnimation(Animation.linear(duration: 0.4).delay(0.8)) {
                                activeColor = Color.white
                            }
                            withAnimation(Animation.linear(duration: 0.4).delay(1.2)) {
                                activeColor = Color.red
                            }
                            withAnimation(Animation.linear(duration: 0.4).delay(1.6)) {
                                activeColor = Color.white
                            }
                            withAnimation(Animation.linear(duration: 0.4).delay(2)) {
                                activeColor = Color.red
                            }
                            withAnimation(Animation.linear(duration: 0.4).delay(2.4)) {
                                activeColor = Color.white
                            }
                            withAnimation(Animation.linear(duration: 0.4).delay(2.8)) {
                                activeColor = Color.red
                            }
                            withAnimation(Animation.linear(duration: 0.4).delay(3.2)) {
                                activeColor = Color.white
                                isActive = false
                                isCoolDown = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                                isCoolDown = false
                            }
                        }
                } else {
                    if isCoolDown {
                        Rectangle()
                            .fill(.red)
                            .ignoresSafeArea()
                    } else {
                        Rectangle()
                            .fill(.greenBen)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(Animation.linear(duration: 0.4)) {
                                    offSetPosition = 0
                                    isHidden = true
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
