//
//  ContentView.swift
//  MyCamera
//
//  Created by 佐藤翔馬 on 2024/04/07.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    //撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    //撮影画面(sheet)の開閉状態を管理
    @State var isShowSheet = false
    //フォトライブラリーで選択した写真を追加
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            //スペース追加
            Spacer()
            //ボタンをタップした時のアクション
            Button{
                //カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    print("カメラは利用できます")
                    //撮影写真を初期化する
                    captureImage = nil
                    //カメラが使えるなら、isShowSheetをtrue
                    //togle()は、Bool型のtrue,falseを切り替えることができる。
                    isShowSheet.toggle()
                }else{
                    print("カメラは利用できません")
                }
            }label: {
                Text("カメラを起動する")
                //横幅いっぱい
                    .frame(maxWidth: .infinity)
                //高さ５０ポイントを指定
                    .frame(height: 50)
                //文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                //背景を青色に指定
                    .background(Color.blue)
                //文字色を白色に指定
                    .foregroundStyle(Color.white)
            }
            //上下左右に余白を追加
            .padding()
            //sheetを表示(撮影画面を表示し、カメラを起動します)
            //isPresentedで指定した状態変数がtrueの時実行
            //$を付与しているので、これはisShoSheetの「参照」を渡すことを意味している。この参照を使って、状態変数isShowSheetの値を共有します。
            //引数isPresentedと状態変数isShoSheetが連携(Bid)することで、isShowSheetの値が「true」の時にsheet(撮影画面)が表示され、「false」になるとsheetが閉じられる。
            .sheet(isPresented: $isShowSheet) {
                if let captureImage {
                    //撮影した写真がある場合、EffectViewを表示する
                    EffectView(isShowSheet: $isShowSheet, captureImage: captureImage)
                }else{
                    //UIImagePickerController(写真撮影)を表示
                    ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
                }
            }
            PhotosPicker(selection: $photoPickerSelectedImage,
                         matching: .images,
                         preferredItemEncoding: .automatic,
                         photoLibrary: .shared()){
                Text("フォトライブラリーから選択する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .padding()
            }
            .onChange(of: photoPickerSelectedImage, initial: true,{oldValue, newValue in
                //選択した写真がある時
                if let newValue{
                    //Data型で写真を取り出す。
                    newValue.loadTransferable(type: Data.self)
                        {result in
                            switch result{
                                case .success(let data):
                                    //写真がある時
                                    if let data{
                                        //写真をcaptureImageに保存
                                        captureImage = UIImage(data: data)
                                    }
                                case .failure:
                                    return
                        }
                    }
                }
            })
            //captureImageをアンラップする。
            if let captureImage{
                //captureImageから共有する画像を生成する。
                let shareImage = Image(uiImage: captureImage)
                //共有シート
                ShareLink(item: shareImage,
                          subject: nil,
                          message: nil,
                          preview: SharePreview("Photo",image: shareImage)){
                    Text("SNSに投稿する")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)//背景を青色
                        .foregroundStyle(Color.white)//文字色を
                        .padding()//上下左右に余白を追加
                }
            }
        }
        .onChange(of: captureImage, initial: true, {oldValue,newValue in
            if let _ = newValue {
                //撮影した写真がある場合、EffectViewを表示する
                isShowSheet.toggle()
            }
        })
    }
}

#Preview {
    ContentView()
}
