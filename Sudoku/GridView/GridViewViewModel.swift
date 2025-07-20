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
        
        var colorPalette = ColorPalette.default
        
        init(grid: SudokuGrid) {
            self.currentPuzzle = grid
            self.selectedCellPosition = nil
            self.isTakingNotes = false
        }
        
        func fetchGrid(of difficulty: GridDifficulty) async throws {
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
            guard var currentPuzzle, let selectedCellPosition, currentPuzzle.getCell(at: selectedCellPosition).isEditable else { return }
            
            currentPuzzle.updateValue(at: selectedCellPosition, with: input)
            
            if isTakingNotes {
                currentPuzzle.rows[selectedCellPosition.row].cells[selectedCellPosition.column].value = 0
                
                currentPuzzle.receivedPencilMark(input, for: selectedCellPosition)
            }
            
            self.currentPuzzle = currentPuzzle
        }
        
        func solveButtonTapped() {
            self.currentPuzzle = currentPuzzleSolution
        }
    }
}
