//
//  HomeViewModel.swift
//  Sudoku
//
//  Created by Tyler on 7/28/25.
//

import Foundation
import SwiftUI

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var showingNewPuzzleDialogue: Bool = false
        @Published var isShowingGame: Bool = false
        @Published var isLoading = false
        
        @Published var newPuzzle: SudokuGrid?
        @Published var newPuzzleSolution: SudokuGrid?
        
        var network = SudokuAPI()
        
        func newGameTapped() {
            showingNewPuzzleDialogue.toggle()
        }
        
        @MainActor
        func difficultySelected(_ difficulty: GridDifficulty) {
            isLoading = true
            Task {
                do {
                   let (puzzle, response) = try await network.fetchPuzzleAndSolution(of: difficulty)
                    self.newPuzzle = puzzle
                    self.newPuzzleSolution = response
                    isLoading = false
                } catch {
                    throw error
                }
                
            }
        }
    }
}
