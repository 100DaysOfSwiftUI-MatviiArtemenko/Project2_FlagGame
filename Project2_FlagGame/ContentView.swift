//
//  ContentView.swift
//  FagGame
//
//  Created by admin on 18.02.2022.
//

import SwiftUI

struct FlagImage: View {
    var image: Image
    
    var body: some View {
        
        image
            .resizable().frame(
                width: 300,
                height: 155)
            .cornerRadius(14)
            .shadow(color:.secondary, radius: 14)
    }
}

struct TitleModifier: ViewModifier {
    var text : String
    
    func body(content: Content) -> some View {
        content
        
        Text(text)
            .frame(minWidth: 150, maxWidth: 300,  maxHeight: 25)
            .padding(.vertical,20)
            .background(.ultraThinMaterial)
            .foregroundStyle(.thinMaterial)
            .font(.largeTitle.bold())
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
extension View {
    
    func titleModified(with text: String) -> some View {
        modifier(TitleModifier(text: text))
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var playerScore = 0
    @State private var isToggled = false
    
    @State private var rotatingAngle = 0.0
    @State private var showAlert = false
    @State private var showAnswers = false
    
    @State var i = 0
    
    @State private var countries = ["Andorra","UAE","Afghanistan","Antigua and Barbuda","Anguilla","Albania","Armenia","Angola","Antarctica","Argentina","American Samoa","Austria"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(stops: [
                .init(color: .blue, location: 0.02),
                .init(color: .teal, location: 0.2),
                .init(color: .gray, location: 0.89),
                .init(color: .black, location: 0.89)
            ], startPoint:.topLeading, endPoint: .bottomTrailing)
            .blur(radius: 45, opaque: true)
                .ignoresSafeArea()
            
            VStack {
                
                VStack(spacing: 20) {
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack {
                        Text("Tap the flag!")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.secondary)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    
                    ForEach(0..<3) { number in
                        
                        Button {
                            withAnimation(.easeInOut(duration: 1.5)){
                                flagTaped(number)
                                showAnswers = true
                                rotatingAngle += 360

                            }
                        } label: {
                            FlagImage(image: Image(countries[number]))
                        }
                        .rotation3DEffect(.degrees(number == correctAnswer ? rotatingAngle : 0.0) , axis: (x: 0, y:1 , z: 0))
                        .background {
                            if showAnswers {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(number == correctAnswer ? .green : .pink)
                                    .blur(radius: 10)
                            }
                        }
                        
                        
                        
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Text("Score: \(playerScore)")
                        .foregroundStyle(.regularMaterial)
                        .font(.largeTitle)
                    
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical,20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .ignoresSafeArea()
            }
            
        }
        
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
            
        } message: {
            Text("Your score is: \(playerScore)")
        }
        
        .alert("WELL DONE!", isPresented: $showAlert){
            Button("start over", action: reset)
            
        } message: {
            Text("Your FINAL score is: \(playerScore)")
        }
        
    }
    
    func flagTaped(_ number: Int) {
        
        if i < 8 {
            i += 1
            
            if  number == correctAnswer {
                playerScore += 1
                scoreTitle = "Correct"
                                
            }else{
                scoreTitle = "Wrong, this is \(countries[number])"
            }
            
            showingScore = true
            
        } else {
            
            if  number == correctAnswer {
                playerScore += 1
                scoreTitle = "Correct"
            } else {
                scoreTitle = "Wrong, this is \(countries[number])"
            }
            showAlert.toggle()
        }
    }
    
    func askQuestion () {
        withAnimation(.easeInOut(duration: 1.5)) {
            showAnswers = false
            countries.shuffle()
        }
            correctAnswer = Int.random(in: 0...2)
        
    }
    
    func reset (){
        askQuestion()
        playerScore = 0
        i = 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
