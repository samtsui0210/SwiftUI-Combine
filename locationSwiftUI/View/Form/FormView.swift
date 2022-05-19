//
//  FormView.swift
//  locationSwiftUI
//
//  Created by SamTsui on 6/5/2022.
//

import SwiftUI
import MapKit

struct FormView: View {
    
    @EnvironmentObject var router:MainViewRouter
    @EnvironmentObject var formViewModel:FormViewModel
    
    @State var selection: Int? = nil
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            
            let inputLeftSpacing = geometry.size.width / 414 * 100
            NavigationView{
                ZStack(){
                    Color.white
                        .ignoresSafeArea()
                    ScrollView{
                        VStack(spacing: 20){
                            InputTextField(title: "Type: ",textField: TextField("Type", text: $formViewModel.typeText), leftSpacing: inputLeftSpacing, showError: formViewModel.showTypeError)
                            InputTextField(title: "Name: ",textField: TextField("Name", text: $formViewModel.nameText), leftSpacing: inputLeftSpacing)
                            InputTextEditor(textEditor: TextEditor(text: $formViewModel.descText))
                            InputTextField(title: "Latitude: ",textField: TextField("Latitude", text: $formViewModel.latText), leftSpacing: inputLeftSpacing)
                            InputTextField(title: "Longitude: ",textField: TextField("Longitude", text: $formViewModel.lngText), leftSpacing: inputLeftSpacing)
                            NavigationLink(destination: ViewControllerPreview(), tag: 1, selection:$selection){
                                EmptyView()
                            }
                            
                            Button(action: {
                                    print("login tapped")
                                    self.selection = 1
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("Next").foregroundColor(Color.black).bold()
                                        Spacer()
                                    }
                                }
                            
                            Spacer()
                                    .frame(height: 100)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                }
                .ignoresSafeArea()
            }
            
        })
        
    }
}

struct InputTextField: View {
    
    var title: String
    var textField: TextField<Text>
    var leftSpacing: CGFloat
    var showError: Bool = false
    
    var body: some View {
        HStack{
            VStack(alignment: .center){
                Text(title)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if showError{
                    Text("Error")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.red)
                }
            }
            .frame(width: leftSpacing)
            
            NeumorphicStyleTextField(textField: textField)
        }
        
    }
}

struct InputTextEditor: View{
    
    var textEditor: TextEditor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
                Text("Description:")
                    .lineLimit(1)
            HStack{
                textEditor
                    .foregroundColor(.neumorphictextColor)
                    .background(Color.background)
                    .cornerRadius(6)
                    .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
                    .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
                    .frame(height: 300)
            }
        }
    }
}
        

struct NeumorphicStyleTextField: View {
    var textField: TextField<Text>
    var body: some View {
        textField
            .padding()
            .foregroundColor(.neumorphictextColor)
            .background(Color.background)
            .cornerRadius(6)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
    }
}

extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
}


struct FormView_Previews: PreviewProvider {
    
    static var previews: some View {
        FormView()
    }
}
