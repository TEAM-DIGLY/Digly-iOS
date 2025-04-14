//
//  TextExtractionView.swift
//  Digly
//
//  Created by 윤동주 on 1/26/25.
//

import SwiftUI
import PhotosUI
import Vision

struct TicketExtractionView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var extractedText: String = "텍스트가 여기에 표시됩니다."
    @State private var isPhotoPickerPresented: Bool = false
    @State private var showPermissionAlert: Bool = false
    @State private var ticketDetails: [String] = []

    var body: some View {
        VStack(spacing: 20) {
            // 사진 선택 버튼
            Button {
                checkPhotoLibraryPermission { isAuthorized in
                    if isAuthorized {
                        isPhotoPickerPresented.toggle()
                    } else {
                        showPermissionAlert = true
                    }
                }
            } label: {
                Label("사진 선택", systemImage: "photo")
                    .font(.title2)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .alert("사진 접근 권한 필요", isPresented: $showPermissionAlert) {
                Button("설정으로 이동") {
                    openSystemSettings()
                }
                Button("취소", role: .cancel) {}
            } message: {
                Text("사진에서 텍스트를 추출하려면 사진 라이브러리 접근 권한이 필요합니다.")
            }
            
            // 선택된 이미지 표시
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(12)
                    .padding()
            }
            
            // 추출된 티켓 정보 표시
            if !ticketDetails.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(ticketDetails, id: \.self) { detail in
                        Text(detail)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            } else {
                Text("티켓 정보를 찾을 수 없습니다.")
                    .font(.headline)
            }
        }
        .sheet(isPresented: $isPhotoPickerPresented) {
            PhotoPicker(selectedImage: $selectedImage, extractedText: $extractedText, ticketDetails: $ticketDetails)
        }
        .padding()
    }
}

// MARK: - 권한 요청 및 상태 확인
extension TicketExtractionView {
    
    /// 갤러리 접근 권한 요청
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    /// 앱 설정 열기
    func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - PhotoPicker: Camera Roll 열기 및 Vision 활용
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var extractedText: String
    @Binding var ticketDetails: [String]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지 선택만 가능
        configuration.selectionLimit = 1 // 한 장만 선택
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        let textExtractor = TextExtractor()
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { image, error in
                if let uiImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.selectedImage = uiImage
                        self.extractText(from: uiImage)
                    }
                }
            }
        }
        
        // Vision 프레임워크를 사용한 텍스트 추출
        func extractText(from image: UIImage) {
            guard let cgImage = image.cgImage else { return }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                let extractedTexts = observations.compactMap { $0.topCandidates(1).first?.string }
                DispatchQueue.main.async {
                    let combinedText = extractedTexts.joined(separator: "\n")
                    self.parent.extractedText = combinedText
                    
                    // TextExtractor로 티켓 정보 추출
                    self.parent.ticketDetails = self.textExtractor.extractTicketTextFromMelon(from: combinedText)
                }
            }
            
            request.recognitionLanguages = ["ko", "en"]
            request.recognitionLevel = .accurate
            
            do {
                try requestHandler.perform([request])
            } catch {
                print("텍스트 추출 중 오류 발생: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    TicketExtractionView()
}
