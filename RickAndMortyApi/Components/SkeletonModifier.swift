//
//  SkeletonModifier.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 04/01/2026.
//

import SwiftUI

enum SkeletonShape {
    case rectangle
    case mask
}

struct SkeletonModifier: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    @State private var isAnimating: Bool = false
    @Binding var isLoading: Bool
    let shape: SkeletonShape
    let color: Color?
    
    private var customColor: Color {
        if let color = color {
            return color
        }
        return scheme == .dark ? .white.opacity(0.1) : .black.opacity(0.1)
    }
    
    func body(content: Content) -> some View {
        content.opacity(isLoading ? 0 : 1)
            .overlay {
                if isLoading {
                    ZStack {
                        customColor
                        shimmer
                    }
                    .mask {
                        maskView(content: content)
                    }
                }
            }
            .onChange(of: isLoading) { newValue in
                if newValue {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                } else {
                    isAnimating = false
                }
            }
            .onAppear {
                if isLoading {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
            }
    }
    
    private var shimmer: some View {
        GeometryReader { geo in
            let size = geo.size
            let shimmerWidth = size.width / 2
            let blurRadius = max(shimmerWidth / 2, 10)
            let minX = -shimmerWidth
            let maxX = size.width + shimmerWidth
            Rectangle()
                .fill(scheme == .dark ? .white : .black.opacity(0.3))
                .frame(width: shimmerWidth, height: size.height * 2)
                .blur(radius: blurRadius)
                .offset(x: isAnimating ? maxX : minX)
        }
        .allowsHitTesting(false)
    }
    
    @ViewBuilder
    private func maskView(content: Content) -> some View {
        switch shape {
        case .rectangle:
            RoundedRectangle(cornerRadius: 10)
        case .mask:
            content
        }
    }
    
}

extension View {
    func skeleton(shape: SkeletonShape = .rectangle, isLoading: Binding<Bool>, color: Color? = nil) -> some View {
        self.modifier(SkeletonModifier(isLoading: isLoading, shape: shape, color: color))
    }
}



