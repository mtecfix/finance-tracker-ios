import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.06, green: 0.42, blue: 0.30),
                         Color(red: 0.04, green: 0.28, blue: 0.20)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 130, height: 130)
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 64, weight: .semibold))
                        .foregroundColor(.white)
                }

                VStack(spacing: 6) {
                    Text("Finance Tracker")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Built for irregular income")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.80))
                }
            }
        }
    }
}
