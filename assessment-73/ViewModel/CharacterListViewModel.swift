//
//  CharacterListViewModel.swift
//  assessment-73
//
//  Created by Orhan Erbas on 3.04.2021.
//

import Foundation

struct CharacterListViewModel {
    let characterlist : CharacterList
    var resArr = [Character]()
    
    func numberOfRowSelection() -> Int {
        return self.characterlist.results.count
    }
    
    mutating func moviesAtIndex(_ index : Int) -> CharactersViewModel {
        self.resArr.append(contentsOf: self.characterlist.results)
        let characters = resArr[index]
        return CharactersViewModel(result: characters , info: characterlist.info)
    }
}

struct CharactersViewModel {
    let result : Character
    
    let info : Info
    
    var image : URL {
        return result.imagePath()!
    }
    
    var name : String {
        return result.name!
    }
    
    var status : String {
        return result.status!
    }
    
    var species : String {
        return result.species!
    }
    
    var next_page_url : String {
        return info.next!
    }
    
    var prev_page_url : String {
        return info.prev!
    }

}
