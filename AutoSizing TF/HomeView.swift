//
//  HomeView.swift
//  AutoSizing TF
//
//  Created by Michele Manniello on 07/05/21.
//

import SwiftUI

struct HomeView: View {
    @State var text = ""
//    Auto updating Text Height...
    @State var containerHeight: CGFloat = 0
    var body: some View {
        NavigationView{
            VStack{
                AutoSizingTF(hint: "Enter message", text: $text,containerHeight: $containerHeight, onEnd:{
//                    do when keyboard closed...
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                })
                    .padding(.horizontal)
//                    your Max Height Here...
                    .frame(height: containerHeight <= 120 ? containerHeight : 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
            }
            .navigationTitle("Input Accessory View ")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.opacity(0.04).ignoresSafeArea())
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
//Building AutoSizing Text Field...
struct AutoSizingTF: UIViewRepresentable {
    var hint : String
    @Binding var text : String
    @Binding var containerHeight : CGFloat
    var onEnd: () -> ()
    
    func makeCoordinator() -> Coordinator {
        return AutoSizingTF.Coordinator(parent: self)
    }
    func makeUIView(context : Context) -> UITextView {
        let textView = UITextView()
//        Mostro il text in hinit...
        textView.text = hint
        textView.textColor = .gray
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 20)
//        setting delegate...
        textView.delegate = context.coordinator
//        Input accessory View...
//        Your own custom size...
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
//        since we need done at right...
//        so using another item as spacer...
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done  , target: context.coordinator, action: #selector(context.coordinator.closekeyBoard))
        toolBar.items = [spacer,doneButton]
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
        return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
//        Starting text Field Height...
        DispatchQueue.main.async {
            if containerHeight == 0{
                containerHeight = uiView.contentSize.height
            }
        }
        
    }
    class Coordinator: NSObject,UITextViewDelegate {
// to read all parent properties
        var parent : AutoSizingTF
        init(parent : AutoSizingTF) {
            self.parent = parent
        }
//        keyboard close @obj Function...
        @objc func closekeyBoard(){
            parent.onEnd()
        }
        
        
        func textViewDidBeginEditing(_ textView: UITextView) {
//            checking if text box is empty...
//            is so then clearing the hinit...
            if textView.text == parent.hint{
                textView.text = ""
                textView.textColor = UIColor(Color.primary)
                
            }
        }
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.containerHeight = textView.contentSize.height
        }
//        on end checking if texbox is empty
//        if so then put hinit...
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == ""{
                textView.text = parent.hint
                textView.textColor = .gray
            }
        }
    }
}
