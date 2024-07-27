//
//  SearchBar.swift
//  StockPriceApp
//
//  Created by Keyur Bhalodiya on 2024/07/27.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
  @Binding var text: String
  @Binding var isEditing: Bool
  var searchTapHandler: ((String) -> Void)

  class Coordinator: NSObject, UISearchBarDelegate {
    @Binding var text: String
    @Binding var isEditing: Bool
    var searchTapHandler: ((String) -> Void)

    init(text: Binding<String>, isEditing: Binding<Bool>, searchTapHandler: @escaping (String) -> Void) {
      _text = text
      _isEditing = isEditing
      self.searchTapHandler = searchTapHandler
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      text = searchText
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      isEditing = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      isEditing = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      searchBar.resignFirstResponder()
      isEditing = false
      searchBar.text = ""
      text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      searchBar.resignFirstResponder()
      isEditing = false
      guard let searchText = searchBar.text, !searchText.isEmpty else { return }
      searchTapHandler(searchText)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(text: $text, isEditing: $isEditing, searchTapHandler: searchTapHandler)
  }
  
  func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
    let searchBar = UISearchBar(frame: .zero)
    searchBar.delegate = context.coordinator
    searchBar.showsCancelButton = true
    return searchBar
  }
  
  func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
    uiView.text = text
  }
}
