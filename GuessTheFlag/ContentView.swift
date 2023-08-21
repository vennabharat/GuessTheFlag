//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by bharat venna on 17/08/23.
//

import SwiftUI

// creating Vcustom View modifier
struct flagLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled() // Array of Strings representing countries
    @State private var correctAnswer = Int.random(in: 0...2) // A random integer represents the correct answer
    @State private var showingScore = false // alert toggle
    @State private var scoreTitle = " " // alert title
    @State private var score = 0 // Variable to kepp track of the score
    @State private var textMessage = "" // String for the alert message
    @State private var questions = 8 // Varible for keeping track of the number of questions
    @State private var alertButton = "" // String for alert botton
    
    func flagTapped(_ number: Int){ // asigning scoreTitle when a flag is tapped and toggle alert
        if(correctAnswer == number){
            scoreTitle = "Correct"
            score += 1
        }else{
            scoreTitle = "Wrong"
        }
        
        if(scoreTitle == "Correct"){ // assigning string textMessage a value based on tapped flag
            textMessage = "Your score is \(score)"
        }else{
            textMessage = "Thar's the flag of: \(countries[number])" // showing the tapped falg as message
        }
        /*Condition for limiting the game to 8 questions*/
        if(questions <= 1){
            alertButton = "New Game" // assigning value to alert button
            
            newGame()
            
        } else {
            alertButton = "Next Question"
            questions -= 1
        }
        
        showingScore = true
    }
    
    func newGame(){ // Method for new game
        questions = 8
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func askQuestion(){ // method created for alert action
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400) // background color
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess The Flag") // app title
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the Flag of") // guiding the user
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer]) // question from shuffled countries array
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in // creating 3 buttons with their index,
                        Button{
                            flagTapped(number) // calling flagTapped with index value to compare it to the correctAnswer
                        }label: {
                            Image(countries[number]) // Image as the label for the buttons
//                                .renderingMode(.original)
//                                .clipShape(Capsule())
//                                .shadow(radius: 5)
                                .modifier(flagLabel())// created custom modifier for view
                        }
                        .alert(scoreTitle, isPresented: $showingScore){ // alert focus activates when flag is tapped
                            Button("\(alertButton)", action: askQuestion)
                        }message: {
                            Text(textMessage) // calling value from flagTapped method
                        }
                    }
                }
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Text("Score: \(score)")
                Spacer()
                Spacer()
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
