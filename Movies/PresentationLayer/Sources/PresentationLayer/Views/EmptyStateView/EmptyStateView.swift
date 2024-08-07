//
//  File.swift
//  
//
//  Created by Mohamed Fawzy on 06/08/2024.
//

import SwiftUI

struct EmptyStateView: View{
    var tryAgainAction: ()->Void
    
    var body: some View {
        VStack(spacing:25) {
            Image(.noDataIcon)
                .resizable()
                .frame(maxWidth: 130,maxHeight: 130)
            Text("No movies found please check your internet connection and try agian")
                .font(.title3)
                .foregroundStyle(Color(.textPrimary))
            Button(action: {
                    tryAgainAction()
                }) {
                    Text("Try Again")
                        .frame(maxWidth: 180)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                      
                }
                .background(Color(.buttonPrimary))
                .cornerRadius(8)
            
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(.background)
    }
}
