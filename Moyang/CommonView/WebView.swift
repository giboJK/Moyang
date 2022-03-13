//
//  WebView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/03/13.
//

import UIKit
import SwiftUI
import Combine
import WebKit
 
struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
