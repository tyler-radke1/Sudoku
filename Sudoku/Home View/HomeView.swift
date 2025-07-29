//
//  HomeScreen.swift
//  Sudoku
//
//  Created by Tyler on 7/28/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: ViewModel
    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Sudoku")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                
                Button("New Game") {
                    vm.newGameTapped()
                }
                .font(.title2.weight(.semibold))
                .padding(.vertical, 16)
                .padding(.horizontal, 40)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 4, y: 6)
                )
                .foregroundColor(.blue)
            }
        }
        .confirmationDialog("Select Difficulty", isPresented: $vm.showingNewPuzzleDialogue, titleVisibility: .visible) {
            ForEach(GridDifficulty.allCases, id: \.self) { difficulty in
                Button(difficulty.rawValue.capitalized) {
                    vm.difficultySelected(difficulty)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        
        .fullScreenCover(isPresented: $vm.isShowingGame) {
            SudokuGridView(grid: SudokuGrid.emptyGrid(), difficulty: vm.selectedDifficulty)
        }
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.25, green: 0.40, blue: 0.65),
                Color(red: 0.70, green: 0.80, blue: 0.90)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    HomeView(vm: HomeView.ViewModel())
}
