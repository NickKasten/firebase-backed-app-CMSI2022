//
//  ArticleEdit.swift
//  KastenSpellsBlog
//
//  Created by Nick Kasten on 4/19/23.
//

import SwiftUI

struct ArticleEdit: View {
    @EnvironmentObject var articleService: KastenSpellsBlogArticle
    
    @Binding var reFetch: Bool
    
    @Binding var articles: [Article]
    @Binding var editing: Bool
    
    @State var article: Article
    
    //    @State var title = article.title
    //    @State var articleBody = article.body
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Title")) {
                    TextField("", text: $article.title)
                }
                
                Section(header: Text("Body")) {
                    TextEditor(text: $article.body)
                        .frame(minHeight: 256, maxHeight: .infinity)
                }
            }
            .navigationTitle(article.title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        editing = false
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Finish Editting") {
                        articleService.editArticle(article: article, newTitle: article.title, newBody: article.body)
                        if reFetch == true {
                            reFetch = false
                        } else {
                            reFetch = true
                        }
                        editing = false
                    }
                    //                    .disabled($article.title.isEmpty || $article.body.isEmpty)
                }
            }
        }
    }
}

struct ArticleEdit_Previews: PreviewProvider {
    @State static var fetching: Bool = true
    @State static var articles: [Article] = []
    @State static var article: Article = Article(
        id: "12345",
        title: "🧙‍♂️",
        date: Date(),
        body: "🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️")
    
    @State static var editing = true
    
    static var previews: some View {
        ArticleEdit(reFetch: $fetching, articles: $articles, editing: $editing, article: article)
            .environmentObject(KastenSpellsBlogArticle())
    }
}
