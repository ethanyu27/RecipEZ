//
//  Recipes.swift
//  RecipEZ
//
//  Created by Ethan Yu on 6/14/21.
//  Copyright © 2021 Yutopia Productions. All rights reserved.
//

import Foundation
import SwiftUI

//Allow for feasible looping through structs
protocol Loopable {
    func allProperties() throws -> [String: String?]
}

extension Loopable {
    func allProperties() throws -> [String: String?] {

        var result: [String: String?] = [:]

        let mirror = Mirror(reflecting: self)

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            if value as? String == nil {
                result[property] = nil
            } else {
                result[property] = value as? String
            }
        }

        return result
    }
}

class Recipes {
    
    //Meal Struct: Contains a single recipe
    struct Meals: Codable, Loopable, Hashable {
        let strMeal: String?
        let strInstructions: String?
        let strMealThumb: String?
        let strYoutube: String?
        let strIngredient1: String?
        let strIngredient2: String?
        let strIngredient3: String?
        let strIngredient4: String?
        let strIngredient5: String?
        let strIngredient6: String?
        let strIngredient7: String?
        let strIngredient8: String?
        let strIngredient9: String?
        let strIngredient10: String?
        let strIngredient11: String?
        let strIngredient12: String?
        let strIngredient13: String?
        let strIngredient14: String?
        let strIngredient15: String?
        let strIngredient16: String?
        let strIngredient17: String?
        let strIngredient18: String?
        let strIngredient19: String?
        let strIngredient20: String?
        let strMeasure1: String?
        let strMeasure2: String?
        let strMeasure3: String?
        let strMeasure4: String?
        let strMeasure5: String?
        let strMeasure6: String?
        let strMeasure7: String?
        let strMeasure8: String?
        let strMeasure9: String?
        let strMeasure10: String?
        let strMeasure11: String?
        let strMeasure12: String?
        let strMeasure13: String?
        let strMeasure14: String?
        let strMeasure15: String?
        let strMeasure16: String?
        let strMeasure17: String?
        let strMeasure18: String?
        let strMeasure19: String?
        let strMeasure20: String?
        let strSource: String?
    }
    
    //Recipe Struct: Contains all Meals
    struct Recipe: Codable, Loopable {
        let meals: [Meals]
    }
    
    //Identifiable Meal Item for Iteration
    struct MealItem: Identifiable {
        let id = UUID()
        let meal: Meals
    }
    
    var searching: Bool = false
    var searchResult: Recipe? = nil
    
    //API Call for the recipe
    func fetchRecipe(meal: String) {
        searching = true
        guard let urlFull = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=" + meal)
            else {
                print("API URL Error")
                searching = false
                return
            }
        URLSession.shared.dataTask(with: urlFull) { (data, response, error) in
            if let error = error {
                print("API Access Error (Location): \(error)\n")
                self.searching = false
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
              print("HTTP Access Error (Location): \(response)")
              self.searching = false
              return
            }
            do {
                let jsonOutput = try JSONDecoder().decode(Recipe.self, from: data!)
                self.setSResult(res: jsonOutput)
                if self.getSResult() != nil {
                    //self.displayResults(res: self.getSResult()!)
                }
                self.searching = false
            }
            catch {
                print("NO OUTPUT")
                self.searching = false
            }
        }.resume()
    }
    
    func getSResult() -> Recipe? {
        return searchResult
    }
    
    func setSResult(res: Recipe) {
        searchResult = res
    }
    
    func isSearching() -> Bool {
        return searching
    }
    
    func emptyRes() -> Bool {
        if searchResult == nil {
            return true
        }
        return false
    }
    
    //Get a MealItem List of all possible recipes
    func getMealItem() -> [MealItem] {
        var count = 0
        while (isSearching()) {}
        if emptyRes() {
            let output: [MealItem] = []
            return output
        }
        var output = [MealItem]()
        for item in searchResult!.meals {
            count += 1
            output.append(MealItem(meal: item))
        }
        if count == 0 {
            let output: [MealItem] = []
            return output
        }
        return output
    }
    
    //Get all ingredients for a given recipe, formatted in <Measure> <Ingredient> form
    func getIngredients(meal: Meals) -> [String] {
        var output: [String] = []
        do {
            let mealProp : [String: String?] = try
                meal.allProperties()
            for i in 1...20 {
                var mes: String = ""
                var ing: String = ""
                if (mealProp["strMeasure" + String(i)] != nil) {
                    mes = mealProp["strMeasure" + String(i)]!!
                    mes = mes.trimmingCharacters(in: .whitespacesAndNewlines) + " "
                }
                if (mealProp["strIngredient" + String(i)] != nil) {
                    ing = mealProp["strIngredient" + String(i)]!!
                }
                if ing != "" {
                    ing = ing.trimmingCharacters(in: .whitespacesAndNewlines)
                    output.append(mes + "" + ing)
                }
            }
        }
        catch {
            print("Error Creating Ingredient List\n")
        }
        return output
    }
    
    //Retrieve an image from a URL
    func getImage(meal: Meals) -> UIImage? {
        
        let url = URL(string: meal.strMealThumb!)!
        if let data = try? Data(contentsOf: url) {
            let uii: UIImage = UIImage(data: data)!
            return uii
            //return Image(uiImage: uii)
        }
        return nil
    }
    
    
    

    //Print Functions for Debugging
    
    
    func displayResults(res: Recipes.Recipe) {
        var count = 0
        for item in res.meals {
            print("\nMeal: " + (item.strMeal ?? "none") + "\n----------\n")
            printRecipe(res: res, n: count)
            count += 1
        }
    }

    func printRecipe(res: Recipes.Recipe, n: Int) {
        do {
            let mealProp : [String: String?] = try
                res.meals[n].allProperties()
            for i in 1...20 {
                var mes: String = ""
                var ing: String = ""
                if (mealProp["strMeasure" + String(i)] != nil) {
                    mes = mealProp["strMeasure" + String(i)]!!
                    mes = mes.trimmingCharacters(in: .whitespacesAndNewlines) + " "
                }
                if (mealProp["strIngredient" + String(i)] != nil) {
                    ing = mealProp["strIngredient" + String(i)]!!
                }
                if ing != "" {
                    ing = ing.trimmingCharacters(in: .whitespacesAndNewlines)
                    print (mes + "" + ing)
                } else {
                    print ("NONE")
                }
            }
        }
        catch {
            print("Error Printing JSON Output\n")
        }
    }
    
    
}
