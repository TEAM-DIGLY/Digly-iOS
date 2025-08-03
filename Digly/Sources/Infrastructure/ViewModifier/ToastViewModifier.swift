import SwiftUI

struct ToastViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State private var isAnimating: Bool = false
    
    let toastType: ToastType?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented, let toastType {
                    DGToast(toastType: toastType)
                        .padding(.bottom, 40)
                        .padding(.horizontal, 24)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : -80)
                        .animation(.mediumSpring, value: isAnimating)
                        .onAppear {
                            withAnimation { isAnimating = true }
                            
                            withAnimation(.spring.delay(2)) {
                                isAnimating = false
                                isPresented = false
                            }
                        }
                        .onDisappear {
                            isAnimating = false
                        }
                }
            }
    }
}

extension View {
    func presentToast(
        isPresented: Binding<Bool>,
        data: ToastType?
    ) -> some View {
        modifier(ToastViewModifier(
            isPresented: isPresented,
            toastType: data
        ))
    }
}