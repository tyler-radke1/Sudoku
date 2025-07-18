//
//  APIModels.swift
//  Sudoku
//
//  Created by Tyler on 7/18/25.
//

import Foundation

enum GridDifficulty: String, Codable, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
}

 struct SudokuPuzzleResponse: Codable {
    let difficulty: GridDifficulty
    let puzzle: String
    let solution: String
}
