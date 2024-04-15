//
//  EffectView.swift
//  MyCamera
//
//  Created by 佐藤翔馬 on 2024/04/07.
//

import SwiftUI

struct EffectView: View {
    //エフェクト編集画面(sheet)の開閉状態を管理
    @Binding var isShowSheet: Bool
    //撮影した写真。編集するための写真は変わることはないので、letにした。
    let captureImage: UIImage
    //画面に表示するための写真を保存する状態変数です。
    @State var showImage: UIImage?
    //フィルタ名を列挙した配列(Array)
    let filterArray = ["CIPhotoEffectMono",     //0.モノクロ
                       "CIPhotoEffectChrome",   //1.Chrome
                       "CIPhotoEffectFade",     //2.Fade
                       "CIPhotoEffectInstant",
                       "CIPhotoEffectNoir",
                       "CIPhotoEffectProcess",
                       "CIPhotoEffectTonal",
                       "CIPhotoEffectTransfer",
                       "CIPhotoEffectTone",    //8.SepiaTone
    ]
    //選択中のエフェクト(filterArrayの添字)
    @State var filterSelectNumber = 0
    
    var body: some View {
        VStack{
            Spacer()
            if let showImage{
                //表示する写真がある場合は画面に表示
                Image(uiImage: showImage)
                //リサイズする
                    .resizable()
                //アスペクト比を維持して画面内に収まるようにする.
                    .scaledToFill()
            }
            Spacer()
            //エフェクトボタン
            Button{
                //フィルタを設定
                let filterName = filterArray[filterSelectNumber]
                //次回に適用するフィルタを決めておく
                filterSelectNumber += 1
                //最後にフィルタまで適用した場合
                if filterSelectNumber == filterArray.count{
                    //最後の場合は、最初のフィルタに戻す
                    filterSelectNumber = 0
                }
                
                //元々の画像の回転角度を取得
                let rotate = captureImage.imageOrientation
                //UIImage形式の画像をCIIMage形式に変換
                let inputImage = CIImage(image: captureImage)
                //フィルタ名を指定してCIFilterのインスタンスを取得
                guard let effectFilter = CIFilter(name: filterName) else{
                    return
                }
                //フィルタ加工のパラメータを初期化
                effectFilter.setDefaults()
                //インスタンスにフィルタ加工する元画像を設定
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                //フィルタ加工を行う情報を生成
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                //CIContextのインスタンスを取得
                let ciContext = CIContext(options: nil)
                //フィルタ加工後の画像をCIContext上に描画し、
                //結果をcgImageとしてCGImage形式の画像を取得
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                    return
                }
                //フィルタ加工後の画像をCGIMage形式からUIImage形式に変更。その際に回転角度を指定。
                showImage = UIImage(
                    cgImage: cgImage,
                    scale: 1.0,
                    orientation: rotate
                )
                
            }label: {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
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
            //showImageをアンラップする。
            if let showImage = showImage?.resized(){
                //captureImageから共有する画像を生成する
                let shareImage = Image(uiImage: showImage)
                //共有シート
                ShareLink(item: shareImage,
                          subject: nil,
                          message: nil,
                          preview: SharePreview("Photo",image: shareImage)){
                    Text("シェア")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                }
                //上下左右に余白を追加
                .padding()
            }
            
            Button{
                //閉じるボタンをタップした時のアクション
                //エフェクト編集画面を閉じる
                isShowSheet.toggle()
            }label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
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
        }
        //写真が表示される時に実行される。
        .onAppear{
            //撮影した写真を表示する写真に設定
            showImage = captureImage
        }
    }
}

#Preview {
    EffectView(
        //「Binding」は、省略できる。
        isShowSheet: Binding.constant(true),
        captureImage: UIImage(named: "preview_use")!
    )
}
