
//  ProjectCard.swift
//  Conectar
//
//  Created by Event on 8/11/25.
//

import SwiftUI

struct ProjectCard: View {
    var title: String
    var author: String
    var description: String
    var tags: [String]
    var members: Int
    var match: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text(match)
                    .font(.subheadline.bold())
                    .padding(6)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(8)
            }
            
            Text("by \(author)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
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
            
            Text("\(members) members")
                .font(.caption)
                .foregroundColor(.gray)
            
            Button(action: {}) {
                Text("Join Project")
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
