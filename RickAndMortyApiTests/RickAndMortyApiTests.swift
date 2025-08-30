//
//  RickAndMortyApiTests.swift
//  RickAndMortyApiTests
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import UIKit
import Testing
@testable import RickAndMortyApi


// MARK: - Mock Service
struct MockCharacterService: Service {
    var shouldThrowError = false
    
    func getCharacters() async throws -> [Character] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        
        return [
            Character(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                gender: "Male",
                origin: Origin(name: "Earth", url: ""),
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
            )
        ]
    }
}



struct ViewModelTests {
    
    @Test func testSuccessfulFetch() async throws {
        // Given
        let mockService = MockCharacterService()
        let vm = await ViewModel(service: mockService)
        
        // When
        await vm.getCharacters()
        
        // Then
        await #expect(vm.characters.count == 1)
        await #expect(vm.characters.first?.name == "Rick Sanchez")
    }
    
    @Test func testFailedFetch() async throws {
        // Given
        let mockService = MockCharacterService(shouldThrowError: true)
        let vm = await ViewModel(service: mockService)
        
        // When
        await vm.getCharacters()
        
        // Then
        await #expect(vm.characters.isEmpty)
    }
}


struct DecodingTests {
    @Test func testDecodingCharacter() throws {
        let json = """
        {
            "id": 0,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "gender": "Male",
            "origin": { "name": "Earth", "url": "" },
          "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
        }
        """.data(using: .utf8)!
        
        let character = try JSONDecoder().decode(Character.self, from: json)
        #expect(character.name == "Rick Sanchez")
    }
}




