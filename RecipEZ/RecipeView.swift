//
//  RecipeView.swift
//  RecipEZ
//
//  Created by Ethan Yu on 6/14/21.
//  Copyright © 2021 Yutopia Productions. All rights reserved.
//

import Foundation
import SwiftUI

struct RecipeView: View {
    let recipes: Recipes
    let recipe: Recipes.Meals
    
    var body: some View {
        VStack {
            //Title
            Text(recipe.strMeal ?? "")
                .font(.system(size:30, weight: .heavy, design: .default))
            
            //Food Image
            Image(uiImage: Recipes().getImage(meal: recipe)!)
                .resizable()
                .frame(width: 150.0, height: 150.0)
            
            //URL Button
            Button(action: {
                if let url = URL(string: self.recipe.strSource ?? "") {
                   UIApplication.shared.open(url)
               }
            }) {
                Text("Original Link")
            }
                .background(Color.blue)
                .foregroundColor(Color.white)
            Text("")
            
            //Ingredients
            Text("Ingredients:")
                .background(Color.blue)
                .font(.system(size: 20, weight: .heavy, design: .default))
            List(Recipes().getIngredients(meal: recipe) , id: \.self) { item in Text(item)
            }
            
            //Instructions
            Text("Instructions:")
                .background(Color.red)
                .font(.system(size: 20, weight: .heavy, design: .default))
            ScrollView {
                Text((recipe.strInstructions ?? "") + "\n")
            }
            
        }
    }
    
}
