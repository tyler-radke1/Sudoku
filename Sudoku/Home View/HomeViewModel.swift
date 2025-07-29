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
        @Published var selectedDifficulty: GridDifficulty = .easy
        
        func newGameTapped() {
            showingNewPuzzleDialogue.toggle()
        }
        
        func difficultySelected(_ difficulty: GridDifficulty) {
            selectedDifficulty = difficulty
        }
    }
}
