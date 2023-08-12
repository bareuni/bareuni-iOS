//
//  PostHistroyView.swift
//  Bareuni
//
//  Created by 윤지성 on 2023/08/12.
//

import SwiftUI

struct PostHistroyView: View {
    var body: some View {
        VStack{
            Divider()

        }.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("작성 내역")
                        .font(.custom("Pretendard-Medium", size: 20))
                }
                
            }
    }
}

struct PostHistroyView_Previews: PreviewProvider {
    static var previews: some View {
        PostHistroyView()
    }
}