//
//  WelcomeView.swift
//  Dice3D
//
//  Created by Raju on 11/12/25.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var gameMode: Int = 1   // 1 = Single Player, 2 = Two Players
    @State private var player1Name: String = ""
    @State private var player2Name: String = ""
    
    @State private var startGame: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                Text("🎲 Snakes & Ladders")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)
                
                // Game Mode Picker
                Picker("Mode", selection: $gameMode) {
                    Text("Single Player").tag(1)
                    Text("Two Players").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Player 1 Input
                VStack(alignment: .leading) {
                    Text("Player 1 Name")
                        .font(.headline)
                    TextField("Enter Player 1 name", text: $player1Name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Player 2 Input (only if 2-player mode)
                if gameMode == 2 {
                    VStack(alignment: .leading) {
                        Text("Player 2 Name")
                            .font(.headline)
                        TextField("Enter Player 2 name", text: $player2Name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    .transition(.opacity)
                }
                
                Spacer()
                
                // Start Game Button
                NavigationLink(
                    destination: BoardView(
                        gameMode: gameMode,
                        player1Name: player1Name.isEmpty ? "Player 1" : player1Name,
                        player2Name: player2Name.isEmpty ? "Player 2" : player2Name
                    ),
                    isActive: $startGame
                ) { EmptyView() }
                
                Button(action: {
                    startGame = true
                }) {
                    Text("START GAME")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
