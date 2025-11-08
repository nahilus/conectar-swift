//
//  CollaboratorCard.swift
//  Conectar
//
//  Created by Event on 8/11/25.
//

import SwiftUI

struct CollaboratorCard: View {
    var name: String
    var location: String
    var description: String
    var tags: [String]
    var match: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.purple)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                    Text(location)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(match)
                    .font(.subheadline.bold())
                    .padding(6)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(8)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
            }
            
            Button(action: {}) {
                Text("Connect")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}
