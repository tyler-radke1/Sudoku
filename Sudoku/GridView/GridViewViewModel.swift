//
//  GridViewViewModel.swift
//  Sudoku
//
//  Created by Tyler on 7/17/25.
//

import Foundation
import SwiftUI
import UIKit

extension SudokuGridView {
    class ViewModel: ObservableObject {
        @Published var currentPuzzle: SudokuGrid?
        var currentPuzzleSolution: SudokuGrid?
        @Published var selectedCellPosition: Position?
        @Published var isTakingNotes: Bool = false
        @Published var isShowingWinPopup = false
        @Published var elapsedTime: TimeInterval = 0
        @Published var showingNewPuzzleDialogue: Bool = false
        @Published var isShowingSolution = false
        @Published var isShowingRestartGameWarning = false
        private var timer: Timer?
        
        var network = SudokuAPI()
        
        var formattedTime: String {
            let minutes = Int(elapsedTime) / 60
            let seconds = Int(elapsedTime) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
        var colorPalette = ColorPalette.neutralSteel
        
        func difficultySelected(_ difficulty: GridDifficulty) {
            isShowingSolution = false
            
            stopTimer()
            startTimer()
            
            Task {
                do {
                   let (puzzle, response) = try await network.fetchPuzzleAndSolution(of: difficulty)
                    self.currentPuzzle = puzzle
                    self.currentPuzzleSolution = response
                } catch {
                    throw error
                }
                
            }
        }


        func startTimer() {
            timer?.invalidate()
            elapsedTime = 0
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.elapsedTime += 1
            }
        }

        func stopTimer() {
            timer?.invalidate()
            timer = nil
        }

        
        init(grid: SudokuGrid, gridSolution: SudokuGrid) {
            self.currentPuzzle = grid
            self.currentPuzzleSolution = gridSolution
            self.selectedCellPosition = nil
            self.isTakingNotes = false
        }
        
        
        func cellTapped(position: Position) {
            guard let currentPuzzle, currentPuzzle.getCell(at: position).isEditable else { return }
            selectedCellPosition = position == selectedCellPosition ? nil : position
        }
        
        func getCellColor(position: Position) -> Color {
            return selectedCellPosition == position ? colorPalette.selectedCell : .white
        }
        
        func inputTapped(input: Int) {
            guard var currentPuzzle,
                  let selectedCellPosition,
                  currentPuzzle.getCell(at: selectedCellPosition).isEditable else { return }
            
            let userInput = input == 0 ? nil : input

            if isTakingNotes {
                currentPuzzle.receivedPencilMark(userInput, for: selectedCellPosition)
            } else {
                var cell = currentPuzzle.getCell(at: selectedCellPosition)
                cell.value = input == cell.value ? nil : userInput
                cell.pencilMarks = []
                currentPuzzle.updateCell(at: selectedCellPosition, with: cell)
            }

            self.currentPuzzle = currentPuzzle
            checkForWin()
        }
        
       private func checkForWin() {
            isShowingWinPopup = currentPuzzle == currentPuzzleSolution
           
           if isShowingWinPopup {
               stopTimer()
           }
        }
        
        func solveButtonTapped() {
            self.currentPuzzle = currentPuzzleSolution
            isShowingSolution = true
            stopTimer()
        }
    }
}
