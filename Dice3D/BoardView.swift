//
//  BoardView.swift
//  Dice3D
//
//  Created by Raju on 05/12/25.
// chaitu

import SwiftUI

struct BoardView: View {
    private let columnsCount = 5
    private let rowsCount = 10
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: columnsCount)
    }
    
    @State private var currentPosition: Int = 0      // 0 = off-board
    @State private var diceValue: Int = 1
    @State private var diceRolling: Bool = false
    @State private var isMovingToken: Bool = false
    @State private var showAnimation: Bool = false
    // prevent tapping while moving
    
    /// Numbers laid out like a snakes & ladders board
    private var boardNumbers: [Int] {
        var result: [Int] = []
        for row in (0..<rowsCount).reversed() {          // draw from top row to bottom
            let start = row * columnsCount + 1           // first number in this row
            let rowNumbers = Array(start..<(start + columnsCount))
            if row % 2 == 0 {
                result.append(contentsOf: rowNumbers)        // left → right
            } else {
                result.append(contentsOf: rowNumbers.reversed()) // right → left
            }
        }
        return result
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // Grid
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(boardNumbers, id: \.self) { number in

                    self.cellView(number: number,
                                  isCurrent: number == currentPosition,
                                  isRolling: self.diceRolling)
                }
            }
            // animate highlight change when currentPosition changes
            .animation(.easeInOut(duration: 0.6), value: currentPosition)
            
            Spacer()
            
            Divider().background(.black)
            
            HStack {
                diceView
                Spacer()
                if self.currentPosition == 0 {
                    Image("standing")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46, height: 46)
                }
                Spacer()
                Button("RESET", action: {
                    self.diceValue = 1
                    self.currentPosition = 0
                })
            }
        }
        .padding()
    }
    
    // MARK: - Dice View & Movement
    
    var diceView: some View {
        ZStack {
            Image("dice\(diceValue)")
                .resizable()
                .scaledToFit()
                .frame(width: 58, height: 58)
                .opacity(diceRolling ? 0 : 1.0)
                .onTapGesture {
                    rollDice()
                }
            
            if diceRolling {
                GIFImage(name: "dice3d")
                    .frame(width: 84, height: 84)
            }
        }
        .frame(width: 68, height: 68)
    }
    
    
    func cellView(number: Int, isCurrent: Bool, isRolling: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                )
            
            Text("\(number)")
                .font(.caption)
                .fontWeight(isCurrent ? .bold : .regular)
                .foregroundColor(isCurrent ? .black : .black)
            
            GIFImage(name: "walking")
                .frame(width: 72, height: 72)
                .opacity(isCurrent ? 1.0 : 0)

//            if self.showAnimation {
//                GIFImage(name: "walking")
//                    .frame(width: 72, height: 72)
//                    .opacity(isCurrent ? 1.0 : 0)
//            } else {
//                Image("standing")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 46, height: 46)
//                    .opacity(isCurrent ? 1.0 : 0)
         //   }
        }.frame(height: 86)
    }

    
    private func rollDice() {
        // don’t allow rolling while already rolling or moving
        guard !diceRolling, !isMovingToken else { return }
        
        diceValue = Int.random(in: 1...6)
        diceRolling = true
        self.showAnimation = true
        // play GIF for a bit, then start moving token
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            diceRolling = false
            startMovingToken()
        }
    }
    
    private func startMovingToken() {
        let target = min(50, currentPosition + diceValue)
        let steps = target - currentPosition
        guard steps > 0 else { return }
        
        isMovingToken = true
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showAnimation = false
        }
        moveStep(remainingSteps: steps)
    }
    
    private func moveStep(remainingSteps: Int) {
        guard remainingSteps > 0 else {
            isMovingToken = false
            return
        }
        
        // move one cell forward with animation
        withAnimation(.easeInOut(duration: 0.2)) {
            currentPosition += 1
        }
        
        // schedule next step
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            moveStep(remainingSteps: remainingSteps - 1)
        }
    }
}



#Preview {
    BoardView()
}
