//
//  NetworkImage.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 19/12/2025.
//

import SwiftUI

struct NetworkImage: View {
    @State private var image: UIImage?
    @State private var isLoading = true
    let imageUrl: String
    
    var body: some View {
        Group {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                dashedBorder {
                    ProgressView()
                        .frame(width: 80, height: 80)
                }
            } else {
                dashedBorder {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray.opacity(0.4))
                        .frame(width: 60, height: 60)
                }
            }
        }
        .task {
            isLoading = true
//            image = await ImageService.shared.fetch(imageUrl)
            isLoading = false
        }
    }
   
    @ViewBuilder
    func dashedBorder(content: () -> some View) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.secondarySystemBackground))
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 2, lineCap: .butt, dash: [2, 2]))
            content()
        }
    }
}


//#Preview {
//    NetworkImage()
//}
