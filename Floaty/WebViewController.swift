//
//  WebViewController.swift
//  Floaty
//
//  Created by James Zaghini on 20/5/18.
//  Copyright © 2018 James Zaghini. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController, ToolbarDelegate, WKNavigationDelegate {

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressIndicator: NSProgressIndicator!

    private var webViewProgressObserver: NSKeyValueObservation?
    private var webViewURLObserver: NSKeyValueObservation?

    private var toolbar: Toolbar? = { NSApplication.shared.windows.first?.toolbar as? Toolbar }()

    private var url: URL? {
        didSet {
            guard let url = url else { return }
            let request = URLRequest(url: url.massagedURL())
            webView.load(request)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let window = NSApplication.shared.windows.first, let toolbar = window.toolbar as? Toolbar else {
            return
        }

        toolbar.toolbarDelegate = self

        webViewProgressObserver = webView.observe(\.estimatedProgress) { [weak self ] (webView, _) in
            self?.progressIndicator.doubleValue = webView.estimatedProgress
            self?.progressIndicator.isHidden = webView.estimatedProgress == 1
        }

        webViewURLObserver = webView.observe(\.URL) { (webView, _) in
            if let urlString = webView.url?.absoluteString, urlString != toolbar.urlTextField.stringValue {
                toolbar.urlTextField.stringValue = urlString
            }
        }

        url = URL(string: "http://en.wikipedia.org/wiki/Special:Random")!
    }

    // MARK: - ToolbarDelegate

    func toolbar(_ toolBar: Toolbar, didChangeText text: String) {
        url = URL(string: text)
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }

}
