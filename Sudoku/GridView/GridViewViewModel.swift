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
        @Published var selectedDifficulty: GridDifficulty = .easy
        @Published var isShowingWinPopup = false
        @Published var elapsedTime: TimeInterval = 0
        @Published var showingNewPuzzleDialogue: Bool = false
        private var timer: Timer?
        
        var formattedTime: String {
            let minutes = Int(elapsedTime) / 60
            let seconds = Int(elapsedTime) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
        var colorPalette = ColorPalette.pinkTheme
        

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

        
        init(grid: SudokuGrid) {
            self.currentPuzzle = grid
            self.selectedCellPosition = nil
            self.isTakingNotes = false
        }
        
        func fetchGrid(of difficulty: GridDifficulty ) {
            Task {
                do {
                    try await makeGridAPICall(of: difficulty)
                } catch {
                    print("Failed to fetch new puzzle:", error.localizedDescription)
                }
            }
        }
        
        private func makeGridAPICall(of difficulty: GridDifficulty) async throws {
            let network = SudokuAPI()
            
            do {
                let responseData = try await network.fetchSudokuResponse(of: difficulty)
                
                guard let response = network.decodeSudokuPuzzleResponse(from: responseData),
                      let puzzle = network.decodePuzzle(from: response.puzzle),
                      let solution = network.decodePuzzle(from: response.solution) else {
                    throw SudokuAPI.APIError.errorDecodingPuzzleSolution
                }
                
                await MainActor.run {
                    self.currentPuzzle = puzzle
                    self.currentPuzzleSolution = solution
                    startTimer()
                }
                
            } catch {
                throw SudokuAPI.APIError.errorDecodingPuzzleSolution
            }
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

            var cell = currentPuzzle.getCell(at: selectedCellPosition)

            if isTakingNotes {
                cell.value = 0
                currentPuzzle.receivedPencilMark(input, for: selectedCellPosition)
            } else {
                cell.value = input == cell.value ? nil : input
            }

            
            currentPuzzle.updateCell(at: selectedCellPosition, with: cell)
            
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
            stopTimer()
        }
    }
}
