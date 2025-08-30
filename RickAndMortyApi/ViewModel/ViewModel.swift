//
//  ViewModel.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import UIKit

@MainActor
class ViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
   
    let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func getCharacters() async {
            do {
                let fetchedCharacters = try await service.getCharacters()
                characters = fetchedCharacters
            } catch {
                print("Error: \(error)") //present alert
            }
    }

}
