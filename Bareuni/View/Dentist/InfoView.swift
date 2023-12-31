//
//  InfoView.swift
//  Bareuni
//
//  Created by 황인성 on 2023/07/17.
//

import SwiftUI

struct InfoView: View {
    
    @State var tabIndex = 0
    @StateObject var dentistInfo = DentistViewModel()
    @StateObject var recommendDentistViewModel: RecommendDentistViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        VStack{
            HStack{
                Text("치과 정보")
                    .font(
                        Font.custom("Pretendard", size: 24)
                            .weight(.medium)
                    )
                    .foregroundColor(.black)
                    .padding(.leading, 24)
                
                Spacer()
                
                NavigationLink(destination: SearchView(), label: {
                    Image("Search_light")
                        .frame(width: 32, height: 32)
                })
                
                NavigationLink(destination: EmptyView(), label: {
                    Image("Bell_light")
                        .frame(width: 32, height: 32)
                        .padding(.trailing, 24)
                })
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("지역선택 다시하기")
                    })
                    .padding(.trailing)
                    
                    
                    Button(action: {
                        print(recommendDentistViewModel.selectedCities)
                        print(recommendDentistViewModel.isSuccess)
                    }, label: {
                        Text("보기")
                    })
                    
                    ForEach(recommendDentistViewModel.selectedCities, id: \.self){ city in
                        HStack {
                            Text(city)
                                .font(Font.custom("Pretendard", size: 16))
                                .kerning(0.2)
                                .foregroundColor(.BackgroundBlue)
                            
                            Button(action: {
                                recommendDentistViewModel.selectedCities.removeAll { $0 == city }
                                recommendDentistViewModel.fetchRecommendedDentists()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    print(recommendDentistViewModel.isSuccess)
                                }
                            }, label: {
                                Image("Cancel")
                            })
                        }
                        .padding(.leading, 16)
                        .padding(.vertical, 4)
                        .padding(.trailing, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.BackgroundBlue, lineWidth: 0.5)
                        )
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, -10)
                }
            }
            .frame(height: 30)
            
            CustomTopTabBar(tabIndex: $tabIndex).padding(.bottom, -5)
            
            if tabIndex == 0 {
                Spacer().frame(height: 0)
                
                    ScrollView(showsIndicators: false) {
                        VStack {
                            if recommendDentistViewModel.isSuccess == false {
                                Text("치과 없음")
                            }
                            else{
                                ForEach(recommendDentistViewModel.recommendedDentists){ dentist in
                                    recommendedDentistView(dentist: dentist)
                                    Spacer().frame(height: 23)
                                }
                            }
                        }
                    }
            }
            else if tabIndex == 1 {
                Spacer().frame(height: 0)
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(recommendDentistViewModel.recommendedDentists){ dentist in
                            recommendedDentistView(dentist: dentist)
                            Spacer().frame(height: 23)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CustomTopTabBar: View {
    @Binding var tabIndex: Int
    @Namespace var animation
  //  @ObservedObject var test = NearDentistViewModel()
    
    var body: some View {
        HStack {
            Spacer().frame(width: 32)
            TabBarButton(text: "추천 치과", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            
            Spacer().frame(width: 13)
            
            TabBarButton(text: "내 주변 치과", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1)
                    //print(test.currentAddress)
                }
            
            Spacer()
        }
        .padding(.top, 5)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct CustomTopTabBar2: View {
    @Binding var tabIndex: Int
    @Namespace var animation
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                
                TabBarButton2(text: "치과 소개", isSelected: .constant(tabIndex == 0))
                    .onTapGesture { onButtonTapped(index: 0) }
                
                
                
                TabBarButton2(text: "리뷰", isSelected: .constant(tabIndex == 1))
                    .onTapGesture { onButtonTapped(index: 1) }
                
                
            }
            .padding(.top, 10)
        }
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct CustomTopTabBar3: View {
    @Binding var tabIndex: Int
    @Namespace var animation
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                
                TabBarButton3(text: "치과 리뷰", isSelected: .constant(tabIndex == 0))
                    .onTapGesture { onButtonTapped(index: 0) }
                
                
                
                TabBarButton3(text: "치과명", isSelected: .constant(tabIndex == 1))
                    .onTapGesture { onButtonTapped(index: 1) }
                
                
            }
            .padding(.top, 10)
        }
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        VStack {
            Text(text)
                .font(
                    Font.custom("Pretendard", size: 18)
                        .weight(.semibold)
                )
                .thickUnderline(color: isSelected ? .blue : .white, thickness: 4, radius: 10)
                .baselineOffset(30)
        }
    }
}

struct TabBarButton2: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        VStack {
            Text(text)
                .font(
                    Font.custom("Pretendard", size: 16)
                        .weight(.semibold)
                )
                .foregroundColor(isSelected ? .BackgroundBlue : .black)
            
            if isSelected == true {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: .infinity, height: 2)
                    .background(Color(red: 0, green: 0.58, blue: 1))
            }
            else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: .infinity, height: 0.5)
                    .background(Color(red: 0.82, green: 0.82, blue: 0.82))
            }
            
        }
    }
}

struct TabBarButton3: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        VStack {
            Text(text)
                .font(
                    Font.custom("Pretendard", size: 16)
                        .weight(.semibold)
                )
                .foregroundColor(isSelected ? .BackgroundBlue : .black)
            
            if isSelected == true {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: .infinity, height: 2)
                    .background(Color(red: 0, green: 0.58, blue: 1))
            }
            else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: .infinity, height: 0.5)
                    .background(Color(red: 0.82, green: 0.82, blue: 0.82))
            }
            
        }
    }
}


struct recommendedDentistView:View {
    
    @State var dentist: RecommendDentist
    @StateObject var detailDentist = DetailDentistViewModel()
    @State var selectedHospitalIdx = 0
    
    var body: some View{
        NavigationLink(destination: {
            detailDentistView(dentist: $dentist, detailDentist: detailDentist, selectedHospitalIdx: $selectedHospitalIdx)
        }, label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 339, height: 203)
                    .background(.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 2, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .inset(by: 0.25)
                            .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 0.5)
                    )
                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer().frame(width: 23)
                        Text(dentist.hosName)
                            .font(
                                Font.custom("Pretendard", size: 20)
                                    .weight(.semibold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 10)
                        
                        Spacer().frame(width: 8)
                        
                        Image("star")
                            .padding(.top, 10)
                        
                        Text(String(dentist.score))
                            .font(
                                Font.custom("Pretendard", size: 12)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        Image("Expand_right")
                            .frame(width: 27, height: 27)
                            .padding(.trailing, 12)
                            .padding(.top, 10)
                    }
                    
                    Text(dentist.summary)
                        .font(
                            Font.custom("Pretendard", size: 12)
                                .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                        .padding(.horizontal, 23)
                    
                    HStack {
                        Spacer().frame(width: 23)
                        Image("Pin_alt_light")
                            .frame(width: 19, height: 19)
                        
                        Text(dentist.address)
                            .font(
                                Font.custom("Pretendard", size: 12)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
                    }
                    
                    HStack {
                        Spacer().frame(width: 23)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 108, height: 86)
                            .padding(.trailing, 12)
                            .background(
                                Image("SampleImage" +  String(Int.random(in: 1...6)))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 108, height: 86)
                                    .clipped()
                            )
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 108, height: 86)
                            .background(
                                Image("SampleImage" +  String(Int.random(in: 1...6)))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 108, height: 86)
                                    .clipped()
                            )
                    }
                }
            }
            .frame(width: 339, height: 203)
        })
        .simultaneousGesture(TapGesture().onEnded{
            
//            print(dentist.hospitalIdx)
//            selectedHospitalIdx = Int(dentist.hospitalIdx)
            detailDentist.hospitalIdx = Int(dentist.hospitalIdx)
            print(detailDentist.hospitalIdx)

            detailDentist.fetchDetailDentists()
//            detailDentist.updateHospitalIdx(newHospitalIdx: Int(dentist.hospitalIdx))
//                        print(detailDentist.hospitalIdx)
            
            
            })
    }
}

struct nearDentistView:View {
    var body: some View{
        Text("내 주변 치과 화면")
    }
}

struct detailDentistView:View {
    
    @Binding var dentist: RecommendDentist
    @State var tabIndex = 0
    @State var bookMark = false
    @StateObject var detailDentist: DetailDentistViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedHospitalIdx: Int

    
    var body: some View{
        ScrollView {
            VStack{
//                Button(action: {
//                    print(detailDentist.hospitalIdx)
//                }, label: {
//                    Text("asd")
//                })
//
//                VStack {
//                    Text("Dentist Name: \(detailDentist.detailDentist?.hosName ?? "N/A")")
//                    Text("Address: \(detailDentist.detailDentist?.address ?? "N/A")")
//                    // Add more Text views or UI elements to display other properties
//                }
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 41.6875, height: 17.25)
                    //                        .background(dentist.reservation ? Color(red: 0.2, green: 0.47, blue: 1) : .red)
                        .cornerRadius(8)
                    
                    //                    Text(dentist.reservation ? "예약가능" : "예약불가")
                        .font(
                            Font.custom("Biennale", size: 8)
                                .weight(.semibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 32, height: 12, alignment: .center)
                }
                
                Text(detailDentist.detailDentist?.hosName ?? "N/A")
                    .font(
                        Font.custom("Pretendard", size: 24)
                            .weight(.semibold)
                    )
                    .foregroundColor(.black)
                    .frame(width: 350, height: 29, alignment: .leading)

                Text(detailDentist.detailDentist?.todayClosed ?? true == true ? "오늘 휴무" : "오늘 영업")
                    .font(
                        Font.custom("Pretendard", size: 16)
                            .weight(.medium)
                    )
                    .foregroundColor(.BackgroundBlue)
                    .frame(width: 350, height: 29, alignment: .leading)
                
                Text(detailDentist.detailDentist?.address ?? "N/A")
                    .font(
                        Font.custom("Pretendard", size: 14)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
                    .frame(width: 350, height: 18, alignment: .leading)
                
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 350, height: 190)
                    .background(
                        Image("Sample" + String(Int.random(in: 1...3)))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 190)
                            .clipped()
                            .cornerRadius(20)
                    )
                    .padding(.vertical, 10)
                
                CustomTopTabBar2(tabIndex: $tabIndex)
                
                if tabIndex == 0 {
                    IntroduceView(dentist: $dentist, detailDentist: detailDentist)
                }
                else if tabIndex == 1 {
                    ReviewView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("Expand_left")
            }), trailing: Button(action: {
                bookMark.toggle()
                //                dentist.Favorites.toggle()
            }, label: {
                Image(bookMark ? "Bookmark_duotone" : "Bookmark_light")
            }))
        }
    }
}

extension View {
    func thickUnderline(color: Color, thickness: CGFloat, radius: CGFloat) -> some View {
        self.overlay(
            Rectangle()
                .foregroundColor(color)
                .frame(height: thickness)
                .cornerRadius(radius)
                .padding(.bottom, -thickness)
        )
    }
}

struct IntroduceView: View {
    
    @Binding var dentist: RecommendDentist
    @State var isPresentingModal = false
    @StateObject var detailDentist: DetailDentistViewModel
    
    var body: some View {
        //        ScrollView(showsIndicators: false){
        VStack{
            Text("진료시간")
                .font(
                    Font.custom("Pretendard", size: 20)
                        .weight(.semibold)
                )
                .foregroundColor(.black)
                .padding(.top, 15)
            
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
    //                    Text("매일 09:00 - 20:00")
    //                        .font(
    //                            Font.custom("Pretendard", size: 14)
    //                                .weight(.semibold)
    //                        )
    //                        .multilineTextAlignment(.center)
    //                        .foregroundColor(.black)
    //
    //                    Text("일요일 휴무")
    //                        .font(
    //                            Font.custom("Pretendard", size: 14)
    //                                .weight(.medium)
    //                        )
    //                        .foregroundColor(.BackgroundBlue)
    //
    //                    Text("점심시간 13:00 - 14:00")
    //                        .font(
    //                            Font.custom("Pretendard", size: 14)
    //                                .weight(.medium)
    //                        )
    //                        .foregroundColor(.black)
                        
                        Text(detailDentist.detailDentist?.openTime ?? "N/A")
                        
                        Text("점심시간")
                        
                        Text(detailDentist.detailDentist?.lunchTime ?? "N/A")
                    }
                }
            }
            .frame(width: 338, height: 112)
            .background(Color(red: 0.93, green: 0.97, blue: 1))
            .cornerRadius(10)
            
            Text("치과소개")
                .font(
                    Font.custom("Pretendard", size: 20)
                        .weight(.semibold)
                )
                .foregroundColor(.black)
                .padding(.top, 15)
            
//            ScrollView {
//                VStack(alignment: .leading, spacing: 10) {
//    //                Text("대한민국 1.7% 교정과 전문의")
//    //                    .font(
//    //                        Font.custom("Pretendard", size: 14)
//    //                            .weight(.medium)
//    //                    )
//    //                    .foregroundColor(.black)
//    //
//    //                Text("보건복지부 인증 치과교정과 전문 3인이 모든 진료 과정을 함께합니다.")
//    //                    .font(
//    //                        Font.custom("Pretendard", size: 14)
//    //                            .weight(.medium)
//    //                    )
//    //                    .foregroundColor(.BackgroundBlue)
//    //                    .frame(width: 298, alignment: .topLeading)
//    //
//    //                Text("교정치료에 사용되는 브라켓, 와이어, 튜브, 밴드, 기구 등, 좋은 재료로 교정치료의 완성도를 높이겠습니다.")
//    //                    .font(
//    //                        Font.custom("Pretendard", size: 14)
//    //                            .weight(.medium)
//    //                    )
//    //                    .foregroundColor(.black)
//    //                    .frame(width: 298, alignment: .topLeading)
//                    Text(detailDentist.detailDentist?.content ?? "N/A")
//                }
//                .padding(.leading, 22)
//                .padding(.trailing, 18)
//                .padding(.top, 18)
//                .padding(.bottom, 15)
//                .background(Color(red: 0.93, green: 0.97, blue: 1))
//            .cornerRadius(10)
//            }
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(detailDentist.detailDentist?.content ?? "N/A")
                    }
                }
            }
            .frame(width: 338, height: 112)
            .background(Color(red: 0.93, green: 0.97, blue: 1))
            .cornerRadius(10)
        }
        
        
        Button(action: {
            isPresentingModal.toggle()
        }, label: {
            ZStack {
                Text("상담받기")
                    .font(
                        Font.custom("Pretendard", size: 16)
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
            }
            .frame(width: 348, height: 51, alignment: .center)
            .background(Color(red: 0, green: 0.58, blue: 1))
            .cornerRadius(9)
            .padding(.top, 15)
            .padding(.bottom, 5)
            .fullScreenCover(isPresented: $isPresentingModal) {
                ConsultingView(isPresentingModal: $isPresentingModal)
            }
        })
        //        NavigationLink(destination: {
        //            ReservationView()
        //        }, label: {
        
        //        })
        
        //        }
    }
}

class ModalState: ObservableObject {
    @Published var isPresentingModal = false
}

struct ReviewView: View {
    
    @State private var isPresentingModal = false
    @StateObject var reviewInfo = ReviewViewModel()
    //    @StateObject private var modalState = ModalState()
    @State private var showFullText = false
    
    @State var gender = "성별"
    @State var sort = "평점순"
    
    var body: some View{
        VStack{
            HStack{
                Image("star")
                Image("star")
                Image("star")
                Image("star")
                Image("star")
            }
            .padding(.top, 10)
            
            Text("4.9  |  리뷰 28개")
                .font(
                    Font.custom("Pretendard", size: 16)
                        .weight(.medium)
                )
                .foregroundColor(.black)
            
            HStack{
                Text("진료결과")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.59, green: 0.59, blue: 0.59))
                
                Text("만족해요")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                
                Text("-----------------------")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.light)
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                
                Text("99%")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.medium)
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
            }
            .padding(.top, 5)
            HStack{
                Text("서비스")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.59, green: 0.59, blue: 0.59))
                
                Text("친절해요")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                
                Text("-----------------------")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.light)
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                
                Text("99%")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.medium)
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
            }
            .padding(.top, 5)
            HStack{
                Text("시설 및 장비")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.59, green: 0.59, blue: 0.59))
                
                Text("좋았어요")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                
                Text("-----------------------")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.light)
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                
                Text("98%")
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.medium)
                    )
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
            }
            .padding(.top, 5)
            //            NavigationLink(destination: WriteView(), label: {
            //                ZStack {
            //                    Text("리뷰쓰기")
            //                      .font(
            //                        Font.custom("Pretendard", size: 14)
            //                          .weight(.semibold)
            //                      )
            //                      .multilineTextAlignment(.center)
            //                      .foregroundColor(Color(red: 0, green: 0.58, blue: 1))
            //                }
            //                .padding(.horizontal, 149)
            //                .padding(.vertical, 13)
            //                .background(.white)
            //                .cornerRadius(8)
            //                .overlay(
            //                  RoundedRectangle(cornerRadius: 8)
            //                    .inset(by: 0.25)
            //                    .stroke(Color(red: 0, green: 0.58, blue: 1), lineWidth: 0.5)
            //                )
            //            })
            
            Button(action: {
                //                isPresentingModal = true
                isPresentingModal = true
            }, label: {
                ZStack {
                    Text("리뷰쓰기")
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.semibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.BackgroundBlue)
                }
                .padding(.horizontal, 149)
                .padding(.vertical, 13)
                .background(.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.25)
                        .stroke(Color(red: 0, green: 0.58, blue: 1), lineWidth: 0.5)
                )
            })
            .padding(.vertical, 10)
            .fullScreenCover(isPresented: $isPresentingModal) {
                WriteView(isPresentingModal: $isPresentingModal)
            }
            //            .sheet(isPresented: $isPresentingModal) {
            //                WriteView()
            //            }
            
            
            Image("Bar")
            
            HStack {
                ZStack {
                    Text("영수증 인증")
                        .font(Font.custom("Pretendard", size: 12))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))
                        .frame(width: 61, alignment: .top)
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 0)
                .frame(width: 69, height: 24, alignment: .center)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .inset(by: 0.25)
                        .stroke(Color(red: 0.76, green: 0.76, blue: 0.76), lineWidth: 0.5)
                )
                ZStack {
                    Menu(gender) {
                        Button("전체") {
                            gender = "전체"
                        }
                        Button("남자") {
                            gender = "남자"
                        }
                        Button("여자") {
                            gender = "여자"
                        }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 0)
                .frame(width: 69, alignment: .center)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .inset(by: 0.25)
                        .stroke(Color(red: 0.76, green: 0.76, blue: 0.76), lineWidth: 0.5)
                )
                ZStack {
                    Menu(sort) {
                        Button("최신순") {
                            sort = "최신순"
                        }
                        Button("평점순") {
                            sort = "평점순"
                        }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 0)
                .frame(width: 69, alignment: .center)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .inset(by: 0.25)
                        .stroke(Color(red: 0.76, green: 0.76, blue: 0.76), lineWidth: 0.5)
                )
            }
            .padding(.vertical, 10)
            
            Divider()
                .padding(.bottom, 10)
            
            //            ScrollView{
//            List {
            ForEach(reviewInfo.reviews.sorted(by: { $0.star > $1.star }), id: \.self){ review in
                    VStack{
                        HStack{
                            ZStack{
                                Circle()
                                    .stroke().frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                Image("Tooth")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 26, height: 29)
                                    .clipped()
                            }
                            .padding(.leading, 20)
                            VStack{
                                Text(review.nickName)
                                    .font(Font.custom("Pretendard", size: 14).weight(.semibold))
                                    .padding(.leading, -2)
                                    .padding(.bottom, -3)
                                if review.certification == true {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20).stroke(Color.BackgroundBlue).frame(width: 50, height: 17)
                                        Text("영수증 인증")
                                            .font(Font.custom("Pretendard", size: 8))
                                            .foregroundColor(.BackgroundBlue)
                                    }
                                }
                            }
                            Spacer()
                            Image("YStar")
                            Text(String(review.star))
                                .padding(.trailing, 30)
                        }
                        VStack {
                            ExpandableTextView(review.detail, lineLimit: 3)
                                .padding(.horizontal, 20)
                        }
                        Image("Bar")
                    }
                }
//            } //foreach
            //            }
        }//vstack
    }
}

struct SearchView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let items = [
        "치아교정", "발치", "유지장치", "상담",
        "교정", "이시림", "잇몸", "검진"
    ]
    
    @State private var searchText = ""
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil),
        GridItem(.flexible(), spacing: 0, alignment: nil)
    ]
    
    @State var tabIndex = 0
    
    @StateObject var searchDentistViewModel = SearchDentistViewModel()
    @StateObject var searchReviewViewModel = SearchReviewViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack(spacing: 7) {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("Expand_left")
                                .frame(width: 31, height: 31)
                                .padding(.leading, -15)
                        })
                        
                        EmailSearchBar(text: $searchText)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                    
                    
                    if !searchText.isEmpty {
                        CustomTopTabBar3(tabIndex: $tabIndex)
                        
                        if tabIndex == 0 {

                            List{
                                if searchReviewViewModel.isSuccess == false {
                                    Text("검색결과 없음")
                                }
                                else{
                                    ForEach(searchReviewViewModel.searchReviews, id: \.self){ review in
//                                        VStack{
//                                            Text(dentist.hosName)
//                                            HStack{
//                                                Text(String(dentist.score))
//                                                Text(String(dentist.reviewCnt))
//                                            }
//                                            Text(dentist.address)
//                                        }
                                        Text(review.content)
                                    }
                                }
                            }.listStyle(.plain)
                                .onChange(of: searchText) { newKeyword in
                                    // When keyword changes, fetch the data
                                    searchReviewViewModel.keyword = newKeyword
                                    searchReviewViewModel.fetchSearchReviews()
                                    print(searchText)
                                    print(searchDentistViewModel.keyword)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        print(searchReviewViewModel.isSuccess)
                                        print(searchReviewViewModel.searchReviews.count)
                                    }
                                    
                                }
                            //                            }
                        }
                        else if tabIndex == 1 {
                            
                            //                            if searchDentistViewModel.isSuccess == false {
                            //                                Text("검색결과 없음")
                            //                            }
                            //
                            //                            else{
                            List{
                                if searchDentistViewModel.isSuccess == false {
                                    Text("검색결과 없음")
                                }
                                else{
                                    ForEach(searchDentistViewModel.searchDentists, id: \.self){ dentist in
                                        VStack{
                                            Text(dentist.hosName)
                                            HStack{
                                                Text(String(dentist.score))
                                                Text(String(dentist.reviewCnt))
                                            }
                                            Text(dentist.address)
                                        }
                                    }
                                }
                            }.listStyle(.plain)
                                .onChange(of: searchText) { newKeyword in
                                    // When keyword changes, fetch the data
                                    searchDentistViewModel.keyword = newKeyword
                                    searchDentistViewModel.fetchSearchDentists()
                                    print(searchText)
                                    print(searchDentistViewModel.keyword)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        print(searchDentistViewModel.isSuccess)
                                        print(searchDentistViewModel.searchDentists.count)
                                    }
                                    
                                }
                            //                            }
                        }
                    }
                    else {
                        VStack(alignment: .leading) {
                            Rectangle().frame(height: 0)
                            Text("추천 키워드")
                                .font(
                                    Font.custom("Pretendard", size: 20)
                                        .weight(.medium)
                                )
                                .kerning(0.2)
                                .foregroundColor(.black)
                            
                            LazyVGrid(columns: columns,
                                      alignment: .center,
                                      spacing: 8) {
                                ForEach(items, id: \.self) { item in
                                    Button(action: {
                                        searchText = item
                                    }, label: {
                                        Text(item)
                                            .font(Font.custom("Pretendard", size: 16))
                                            .kerning(0.2)
                                            .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))
                                            .frame(height: 40)
                                            .padding(.horizontal, 16)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 24)
                                                    .stroke(Color(red: 0.62, green: 0.62, blue: 0.62), lineWidth: 0.5)
                                            )
                                    })
                                }
                            }
                                      .padding(.leading, -5)
                            
                        }
                        .padding(.leading, 20)
                    }
                    Spacer()
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct EmailSearchBar: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            VStack{
                HStack {
                    TextField("치과명 또는 키워드를 검색하세요.", text: $text)
                        .frame(width: 276, height: 46)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
                            .frame(width: 306, height: 46))
                }
            }
        }
        .padding(.horizontal)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //        InfoView()
        //        ReviewView()
        //        SearchView()
    }
}
