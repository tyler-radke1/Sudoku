//
//  ContentView.swift
//  Sudoku
//
//  Created by Tyler on 7/16/25.
//

import SwiftUI

// Preview
struct ContentView: View {
    var body: some View {
        SudokuGridView(grid: SudokuGrid.testGrid)
    }
}

#Preview {
    ContentView()
}
import SwiftUI

struct SudokuGridView: View {
    @State var vm: ViewModel
    
    init(grid: SudokuGrid) {
        self.vm = ViewModel(grid: grid)
    }
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<9, id: \.self) { rowIndex in
                HStack(spacing: 2) {
                    ForEach(0..<9, id: \.self) { colIndex in
                        var cell = vm.grid.rows[rowIndex].cells[colIndex]
                        SudokuCellView(cell: cell)
                            .onTapGesture {
                                cell.isSelected.toggle()
                            }
                    }
                }
            }
            
            //Figure out spacing between hstack and hstack
            
            HStack {
                ForEach(1...9, id: \.self) { number in
                    Button(action: {
                       // vm.input(number: number)
                    }) {
                        Text("\(number)")
                            .frame(width: 35, height: 35)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
            }
                
            }
            .padding()
            .background(Color.gray.opacity(0.3))
        }
    
    }
    
    struct SudokuCellView: View {
        @Binding var cell: SudokuCell
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(cellBackgroundColor)
                    .frame(width: 35, height: 35)
                    .border(Color.black, width: 1)
                
                Text("\(cell.value)")
                    .font(.headline)
                    .foregroundColor(cell.cellType == .prefilled ? .black : .blue)
            }
        }
        
        private var cellBackgroundColor: Color {
            if cell.isSelected {
                return .yellow.opacity(0.4)
            }
            return .white
        }
    }
    
    #Preview {
        ContentView()
    }
