//
//  ContentView.swift
//  RecipEZ
//
//  Created by Ethan Yu on 6/14/21.
//  Copyright © 2021 Yutopia Productions. All rights reserved.
//

import SwiftUI

let recipes: Recipes = Recipes()

//Main View: Contains search bar and a list of search results
struct ContentView: View {
    
    @State var searchText: String = ""
    @State var meals: [Recipes.MealItem] = []
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, view: self)
                List(meals) {
                    meal in ItemCell(item: meal.meal)
                }
            }.navigationBarTitle(Text("RecipEZ"))
        }
    }
    
    func updateMeals() {
        meals = recipes.getMealItem()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Single unit of a search result: Contains image, navigation, and the name of the item
struct ItemCell: View {
    let item: Recipes.Meals
    
    var body: some View {
        return NavigationLink(destination: RecipeView(recipes: recipes, recipe: item)) {
            Image(uiImage: Recipes().getImage(meal: item)!)
                .resizable()
                .frame(width: 20.0, height: 20.0)
            VStack {
                Text(item.strMeal ?? "")
            }
        }
    }
}

//Search Bar
struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var view: ContentView

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        var view: ContentView
        let debouncer = Debouncer(timeInterval: 4)

        init(text: Binding<String>, view: ContentView) {
            _text = text
            self.view = view
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            recipes.fetchRecipe(meal: text)
            
            debouncer.handler = {
                recipes.fetchRecipe(meal: self.text)
                print("CALL")
            }
            debouncer.renew()
            
            view.updateMeals()
        }
        
        @objc func performFetch(text: String) {
            recipes.fetchRecipe(meal: text)
        }
        
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, view: view)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

