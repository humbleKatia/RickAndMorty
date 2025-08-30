//
//  MockData.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import UIKit


struct MockData {
    
   static let shared = MockData()
    
    let characterDetailView = Character(id: 1, name: "AAA", status: "Alive", species: "Human", gender: "Male", origin: Origin(name: "Earth (C-137)", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg")
    
    func getCharacters()-> [Character] {
        let array = [
            Character(id: 1, name: "AAA", status: "Alive", species: "Human", gender: "Male", origin: Origin(name: "Earth (C-137)", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg"),
            Character(id: 2, name: "BBB", status: "Alive", species: "Alien", gender: "Male", origin: Origin(name: "Earth (C-137)", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg"),
            Character(id: 3, name: "CCC", status: "Alive", species: "Human", gender: "Male", origin: Origin(name: "Earth (C-137)", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg"),
            Character(id: 4, name: "DDD", status: "Alive", species: "Human", gender: "Male", origin: Origin(name: "Earth (C-137)", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg"),
            Character(id: 5, name: "EEE", status: "Alive", species: "Alien", gender: "Male", origin: Origin(name: "Earth (C-137)", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg")
        ]
        return array
    }
    
    
}


