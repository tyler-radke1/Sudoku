//
//  SudokuAPI.swift
//  Sudoku
//
//  Created by Tyler on 7/18/25.
//

import Foundation

class SudokuAPI {
    enum APIError: Error {
        case invalidURL
        case errorDecodingPuzzleSolution
    }
    
    func fetchSudokuResponse(of difficulty: GridDifficulty) async throws -> Data {
        guard let url = URL(string: "https://youdosudoku.com/api/") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["difficulty": difficulty.rawValue])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    func decodeSudokuPuzzleResponse(from data: Data) -> SudokuPuzzleResponse? {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(SudokuPuzzleResponse.self, from: data)
            
            return response
            
        } catch {
            print("Error decoding puzzle response: \(error)")
            return nil
        }
    }
    
    func decodePuzzle(from puzzleString: String) -> SudokuGrid? {
        guard puzzleString.count == 81, puzzleString.allSatisfy({$0.isWholeNumber }) else {
            print("invalid puzzle string")
            return nil
        }
        
        var rows: [SudokuRow] = (0..<9).map { _ in SudokuRow(cells: []) }
        
        for (index, value) in puzzleString.enumerated() {
            if let valueInt = Int(String(value)) {
                let cell = SudokuCell(value: valueInt, isEditable: valueInt == 0)
                rows[index / 9].cells.append(cell)
            }
        }
        
        return SudokuGrid(rows: rows)
    }
}
