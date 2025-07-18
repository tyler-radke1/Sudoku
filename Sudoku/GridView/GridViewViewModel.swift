//
//  GridViewViewModel.swift
//  Sudoku
//
//  Created by Tyler on 7/17/25.
//

import Foundation

extension SudokuGridView {
    
    class ViewModel: ObservableObject {
        init(grid: SudokuGrid, selectedCell: SudokuCell? = nil) {
            self.grid = grid
            self.selectedCell = selectedCell
            self.isEditing = false
        }
        
        @Published var grid: SudokuGrid
        @Published var selectedCell: SudokuCell?
        @Published var isEditing: Bool = false
        
        func cellTapped(_ cell: SudokuCell) {
            selectedCell = cell
        }
    }
}
