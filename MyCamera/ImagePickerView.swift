//
//  ImagePickerView.swift
//  MyCamera
//
//  Created by 佐藤翔馬 on 2024/04/07.
//

//UIKitでswiftUIフレームワークを読み込むとUIKitフレームワークも自動的にimportされる。
import SwiftUI

//UIViewControllerRepresentableプロトコルを使用する。
//UIKitのUI部品(View)は、swiftUIのViewに置き換えが進められている。
//SwiftUIで置き換えがされていないUIKitは、今回のように、UIViewControllerRepresentableプロトコルなどでラップして利用します。
struct ImagePickerView: UIViewControllerRepresentable {
    //UIImagePickerController(写真撮影)が表示されているかを管理
    @Binding var isShowSheet: Bool
    //撮影した写真を格納する変数
    //@Bindingは、「@State(状態変数)を定義したView」と「他のView」との間で双方向にデータ連動ができるようにする構造体です。
    //最初は写真がない状態から開始するので、初期値がnilとなるため、nilを許容する「?」を付与してオプショナル型で宣言をする。
    @Binding var captureImage: UIImage?
    
    class Coordinator: NSObject,
                       UINavigationControllerDelegate,
                       UIImagePickerControllerDelegate{
        //ImagePickerView型の変数を用意
        let parent: ImagePickerView
        
        //イニシャライザ
        init(_ parent: ImagePickerView){
            self.parent = parent
        }
        
        //撮影が終わった時に呼ばれるdelegateメソッド、必ず必要
        //「_(アンダースコア)」はラベル名の略称。imagePickerControllerを表している。
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info:
            [UIImagePickerController.InfoKey : Any]) {
            //UIImagePickerControllerを閉じるとisShowSheetがfalseになる。
                picker.dismiss(animated: true){
                    //撮影した写真をcaptureImageに保存
                    //「as? UIIMage」はAny型をIImage型へ変換する文法になる。
                    //UIImage型へのダウンキャストに失敗すると「as?」にて、nilが返却されるため、if letのブロックは実行されない。
                    if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                        self.parent.captureImage = originalImage
                    }
                }
            //Sheetを閉じる
            parent.isShowSheet.toggle()
        }
        
        //キャンセルボタンが選択された時に呼ばれるdelegateメソッド、必ず必要
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //sheetを閉じる
            parent.isShowSheet.toggle()
        }
    }
    //Coodinatorを生成、swiftUIによって自動的に呼び出し。
    func makeCoordinator() -> Coordinator {
        //Coodinatorクラスのインスタンスを生成
        return Coordinator(self)
    }
    //Viewを生成する時に実行
    func makeUIViewController(context: Context) -> UIImagePickerController {
        //UIImagePickerControllerのインスタンスを生成
        let myImagePickerController = UIImagePickerController()
        //sourceTypeにcameraを設定
        myImagePickerController.sourceType = .camera
        //delegate設定
        myImagePickerController.delegate = context.coordinator
        //UIImagePickerControllerを返す
        return myImagePickerController
    }
    
    //Viewが更新された時に実行
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //処理なし
    }
}


