import SwiftUI

private struct SoftOrb: View {
    let color: Color
    let size: CGFloat
    let offset: CGSize

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .blur(radius: size * 0.22)
            .offset(offset)
    }
}

struct LiquidGlassBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.12, blue: 0.16),
                    Color(red: 0.01, green: 0.06, blue: 0.08),
                    Color(red: 0.00, green: 0.02, blue: 0.03)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            SoftOrb(color: .teal.opacity(0.44), size: 360, offset: .init(width: -240, height: -200))
            SoftOrb(color: .white.opacity(0.30), size: 280, offset: .init(width: 250, height: -210))
            SoftOrb(color: .cyan.opacity(0.30), size: 310, offset: .init(width: 220, height: 220))
            SoftOrb(color: .black.opacity(0.36), size: 420, offset: .init(width: -160, height: 260))
        }
        .ignoresSafeArea()
    }
}

struct GlassPanel<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(24)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.45), Color.teal.opacity(0.20), Color.white.opacity(0.10)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
            )
            .overlay(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.22), Color.clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                    .blendMode(.screen)
                    .allowsHitTesting(false)
            }
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.28), radius: 24, x: 0, y: 20)
            .shadow(color: Color.teal.opacity(0.20), radius: 18, x: 0, y: 8)
    }
}

struct GlassCard<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(.thinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.28), lineWidth: 0.9)
            )
            .overlay(alignment: .top) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.16), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blendMode(.screen)
                    .allowsHitTesting(false)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 8)
    }
}
