//
//  SavedListView.swift
//  Bareuni
//
//  Created by 윤지성 on 2023/08/12.
//

import SwiftUI

struct SavedListView: View {
    @State var dentistList: [DentistData] = []
    var body: some View {
        VStack{
            Divider()
            Spacer()
            
            if(dentistList.isEmpty){
                BlankView(text: "아직 저장된 치과가 없어요.")
            }else{
                
            }
            
            Spacer()
            
            
        }.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("저장 목록")
                        .font(.custom("Pretendard-Medium", size: 20))
                }
                
            }
    }
}

internal struct BlankView: View{
    let text: String
    
    var body: some View {
        Image("Tooth").resizable()
            .aspectRatio(contentMode: .fill).frame(width:80, height: 80)
        Text(text).font(.custom("Pretendard-Medium", size: 16)).padding(.top, 16)
    }
    
    
}

struct SavedListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedListView()
    }
}
