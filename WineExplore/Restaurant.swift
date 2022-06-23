//
//  Restraunt.swift
//  WineExplore
//
//  Created by KBSYS on 2022/06/23.
//

import Foundation

struct Restaurant {

  var name: String
  var category: String // Could become an enum
  var city: String
  var price: Int // from 1-3; could also be an enum
  var numRatings: Int // numRatings
  var avgRating: Float

  var dictionary: [String: Any] {
    return [
      "name": name,
      "category": category,
      "city": city,
      "price": price,
      "numRatings": numRatings,
      "avgRating": avgRating,
    ]
  }

}

extension Restaurant: DocumentSerializable {
    
    static let cities = [
        "Albuquerque",
        "Arlington",
        "Atlanta",
        "Austin",
        "Baltimore",
        "Boston",
        "Charlotte",
        "Chicago",
        "Cleveland",
        "Colorado Springs",
        "Columbus",
        "Dallas",
        "Denver",
        "Detroit",
        "El Paso",
        "Fort Worth",
        "Fresno",
        "Houston",
        "Indianapolis",
        "Jacksonville",
        "Kansas City",
        "Las Vegas",
        "Long Beach",
        "Los Angeles",
        "Louisville",
        "Memphis",
        "Mesa",
        "Miami",
        "Milwaukee",
        "Nashville",
        "New York",
        "Oakland",
        "Oklahoma",
        "Omaha",
        "Philadelphia",
        "Phoenix",
        "Portland",
        "Raleigh",
        "Sacramento",
        "San Antonio",
        "San Diego",
        "San Francisco",
        "San Jose",
        "Tucson",
        "Tulsa",
        "Virginia Beach",
        "Washington"
    ]
    
    static let categories = [
        "Brunch", "Burgers", "Coffee", "Deli", "Dim Sum", "Indian", "Italian",
        "Mediterranean", "Mexican", "Pizza", "Ramen", "Sushi"
    ]
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
              let category = dictionary["category"] as? String,
              let city = dictionary["city"] as? String,
              let price = dictionary["price"] as? Int,
              let numRatings = dictionary["numRatings"] as? Int,
              let avgRating = dictionary["avgRating"] as? Float else {
            
            print("Restaurant init fail")
            return nil
            
        }
        
        self.init(name: name,
                  category: category,
                  city: city,
                  price: price,
                  numRatings: numRatings,
                  avgRating: avgRating)
    }
    
}
