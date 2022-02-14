//
//  WebView.swift
//  locationSwiftUI
//
//  Created by Sam Tsui on 27/1/2022.
//

import SwiftUI
import WebKit
 
struct WebView: UIViewRepresentable {
 
    var urlString: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
 
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        return webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}
