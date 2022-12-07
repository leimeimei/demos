//
//  ColumnStepper.swift
//  Picture
//
//  Created by sun on 2022/10/31.
//

import SwiftUI

struct ColumnStepper: View {
    let title: String
    let range: ClosedRange<Int>
    @Binding var columns: [GridItem]
    @State private var numColumns: Int
    
    init(title: String, range: ClosedRange<Int>, columns: Binding<[GridItem]>, numColumns: Int) {
        self.title = title
        self.range = range
        self._columns = columns
        self.numColumns = numColumns
    }
    
    var body: some View {
        Stepper(title, value: $numColumns, in: range, step: 1) { _ in
            withAnimation {
                columns = Array(repeating: GridItem(.flexible()), count: numColumns)
            }
        }
    }
}
