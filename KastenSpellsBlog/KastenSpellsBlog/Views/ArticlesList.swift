//
//  ArticlesList.swift
//  KastenSpellsBlog
//
//  Created by Nick Kasten on 4/17/23.
//

import SwiftUI

struct ArticlesList: View {
    @EnvironmentObject var auth: KastenSpellsBlogAuth
    @EnvironmentObject var articleService: KastenSpellsBlogArticle
    
    @Binding var requestLogin: Bool
    
    @State var articles: [Article]
    @State var error: Error?
    @State var reFetch: Bool = true
    @State var fetching = false
    @State var writing = false
    @State var loading = false
    @State var searchString = ""
    @State var subArticles:[Article]=[]
    
    var body: some View {
        NavigationView {
            VStack {
                if fetching {
                    ProgressView()
                } else if error != nil {
                    Text("Something went wrong…we wish we can say more 🤷🏽")
                } else if articles.count == 0 {
                    VStack {
                        Spacer()
                        Text("There are no articles.")
                        Spacer()
                    }
                } else {
                    VStack {
                        NavigationStack {
                            List(subArticles) { article in
                                NavigationLink {
                                    ArticleData(article: article, reFetch: $reFetch, articles: $articles)
                                } label: {
                                    ArticleMetadata(article: article)
                                }
                            }
                        }
                        .searchable(text: $searchString)
                        .onChange(of: searchString) { newVal in
                            subArticles = getList(search: newVal, articles: articles)
                        }
                        
                    }
                }
            }
            .navigationTitle("KASTEN SPELLS 🧙‍♂️")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if auth.user != nil {
                        Button("New Article") {
                            writing = true
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if auth.user != nil {
                        Button("Sign Out") {
                            do {
                                try auth.signOut()
                            } catch {
                                // No error handling in the sample, but of course there should be
                                // in a production app.
                            }
                        }
                    } else {
                        Button("Sign In") {
                            requestLogin = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $writing) {
            ArticleEntry(reFetch: $reFetch, articles: $articles, writing: $writing)
        }
        .task(id: reFetch) {
            fetching = true
            do {
                articles = try await articleService.fetchArticles()
                subArticles = articles
                fetching = false
            } catch {
                print(error)
                self.error = error
                fetching = false
            }
        }
    }
}

func getList(search:String, articles:[Article]) -> [Article]{
    if(search=="") {
        return articles
    } else {
        var articleList:[Article] = []
        for article in articles {
            if(article.title.lowercased().contains(search.lowercased())) {
                articleList.append(article)
            }
        }
        return articleList
    }
    
}

struct ArticleList_Previews: PreviewProvider {
    @State static var requestLogin = false
    
    static var previews: some View {
        ArticlesList(requestLogin: $requestLogin, articles: [])
            .environmentObject(KastenSpellsBlogAuth())
        
        ArticlesList(requestLogin: $requestLogin, articles:[])
            .environmentObject(KastenSpellsBlogAuth())
            .environmentObject(KastenSpellsBlogArticle())
    }
}
