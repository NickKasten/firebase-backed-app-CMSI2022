//
//  ArticleData.swift
//  KastenSpellsBlog
//
//  Created by Axel Pestoni on 4/18/23.
//


import SwiftUI

struct ArticleData: View {
    var article: Article
    @Binding var reFetch: Bool
    
    @State var startDeleting = false
    
    @State var startEditing = false
    @State var hovered = false
    
    @EnvironmentObject var articleService: KastenSpellsBlogArticle
    
    @EnvironmentObject var auth: KastenSpellsBlogAuth
    
    @Binding var articles: [Article]
    
    var body: some View {
        VStack {
            ArticleMetadata(article: article)
                .padding()
            
            Text(article.body)
                .scaleEffect(hovered ? 1.4:1)
                .animation(.spring())
                .onHover { hover in
                    hovered = hover
                }
                .padding()
            Spacer()
            HStack {
                if auth.user != nil {
                    Button("Edit Article") {
                        startEditing = true
                    }
                    .padding()
                    Button("Delete Article") {
                        startDeleting = true
                    }
                }
            }
        }
        .sheet(isPresented: $startDeleting) {
            VStack {
                Text("Are you sure you want to delete?")
                HStack {
                    Button("Yes") {
                        articleService.deleteArticle(article: article)
                        articles.remove(at: articles.firstIndex(of: article)!)
                        startDeleting = false
                        if reFetch == true {
                            reFetch = false
                        } else {
                            reFetch = true
                        }
                    }
                    .padding()
                    Button("No") {
                        startDeleting = false
                    }
                }
            }
        }
        .sheet(isPresented: $startEditing) {
            ArticleEdit(reFetch: $reFetch, articles: $articles, editing: $startEditing, article: article)
        }
        .animation(Animation.easeInOut(duration: 0.25))
    }
}

struct ArticleDetail_Previews: PreviewProvider {
    static var previews: some View {
        @State var fetching: Bool = true
        @State var articles: [Article] = []
        
        ArticleData(article: Article(
            id: "12345",
            title: "🧙‍♂️",
            date: Date(),
            body: "🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️🧙‍♂️"
        ), reFetch: $fetching, articles: $articles)
    }
}

