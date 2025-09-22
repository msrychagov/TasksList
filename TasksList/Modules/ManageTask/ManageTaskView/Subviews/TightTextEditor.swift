//
//  TightTextEditor.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import UIKit
import SwiftUI

struct TightTextEditor: UIViewRepresentable {
    @Binding var text: String
    var font: UIFont? = .systemFont(ofSize: 16, weight: .regular)
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        /// Remove internal paddings
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        textView.font = font
        textView.tintColor = .SummaryView.createButton
        
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = font
        uiView.textColor = UIColor.label
        uiView.backgroundColor = UIColor.clear
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: TightTextEditor
        init(_ parent: TightTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text ?? ""
        }
    }
}
