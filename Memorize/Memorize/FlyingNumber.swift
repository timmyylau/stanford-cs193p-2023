//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Timmy Lau on 2025-02-04.
//

import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    
    
    var body: some View {
        if number != 0 {
            // Text("\(number)")
            Text(number, format: .number)
        }
        
    }
}

#Preview {
    FlyingNumber(number: 5)
}
