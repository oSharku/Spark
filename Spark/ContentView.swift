import SwiftUI

struct ContentView: View {
    @State private var selectedTab: SparkTab = .home
    @State private var showSideMenu = false
    @State private var showRewardsPage = false
    @State private var showProfilePage = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var appState = AppState.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                SparkBackground()
                
                if showProfilePage {
                    ProfileView(isPresented: $showProfilePage)
                        .transition(.move(edge: .trailing))
                } else if showRewardsPage {
                    RewardsView(isPresented: $showRewardsPage)
                        .transition(.move(edge: .trailing))
                } else {
                    TabView(selection: $selectedTab) {
                        HomeView(showSideMenu: $showSideMenu)
                            .tag(SparkTab.home)
                        UpdatesView(showSideMenu: $showSideMenu, showRewardsPage: $showRewardsPage)
                            .tag(SparkTab.updates)
                        ClassesView()
                            .tag(SparkTab.classes)
                        ChatsView()
                            .tag(SparkTab.chats)
                        FullCalendarView()
                            .tag(SparkTab.calendar)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    VStack {
                        Spacer()
                        SparkTabBar(selectedTab: $selectedTab, unreadCount: appState.unreadAnnouncementCount)
                    }
                    SideMenuView(isPresented: $showSideMenu, isDarkMode: $isDarkMode, showRewardsPage: $showRewardsPage, showProfilePage: $showProfilePage)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showRewardsPage)
            .animation(.easeInOut(duration: 0.3), value: showProfilePage)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .ignoresSafeArea(.keyboard)
            .navigationBarHidden(true)
        }
    }
}

struct SparkBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(colors: [Color(hex: "1C1C1E"),Color(hex: "2C2C2E"),Color(hex: "1C1C1E")],startPoint: .top,endPoint: .bottom)
            } else {
                LinearGradient(colors: [Color(hex: "E8F4FD"),Color(hex: "B8D4E8"),Color(hex: "7EB8DA")],startPoint: .top,endPoint: .bottom)
            }
        }.ignoresSafeArea()
    }
}

enum SparkTab: String, CaseIterable {
    case home = "Home"
    case updates = "Updates"
    case classes = "Classes"
    case chats = "Chats"
    case calendar = "Calendar"
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .updates: return "bell"
        case .classes: return "book.closed"
        case .chats: return "bubble.left.and.bubble.right"
        case .calendar: return "calendar"
        }
    }
    var selectedIcon: String {
        switch self {
        case .home: return "house.fill"
        case .updates: return "bell.badge.fill"
        case .classes: return "book.closed.fill"
        case .chats: return "bubble.left.and.bubble.right.fill"
        case .calendar: return "calendar"
        }
    }
}

struct SparkTabBar: View {
    @Binding var selectedTab: SparkTab
    let unreadCount: Int
    @Namespace private var animation
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(SparkTab.allCases, id: \.self) { tab in
                SparkTabItem(tab: tab,isSelected: selectedTab == tab,namespace: animation,showBadge: tab == .updates && unreadCount > 0,badgeCount: unreadCount)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 28).fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 28)
                    .stroke(LinearGradient(colors: [Color.white.opacity(colorScheme == .dark ? 0.2 : 0.6),Color.white.opacity(colorScheme == .dark ? 0.05 : 0.2)],startPoint: .topLeading,endPoint: .bottomTrailing),lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

struct SparkTabItem: View {
    let tab: SparkTab
    let isSelected: Bool
    var namespace: Namespace.ID
    var showBadge: Bool = false
    var badgeCount: Int = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 44, height: 44)
                        .matchedGeometryEffect(id: "tabBackground", in: namespace)
                }
                ZStack(alignment: .topTrailing) {
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(isSelected ? Color.blue : (colorScheme == .dark ? Color.gray : Color.gray))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                    if showBadge {
                        ZStack {
                            Circle().fill(Color.red).frame(width: 18, height: 18)
                            Text(badgeCount > 99 ? "99+" : "\(badgeCount)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 10, y: -8)
                    }
                }
            }
            .frame(height: 44)
            Text(tab.rawValue)
                .font(.system(size: 9, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(isSelected ? Color.blue : (colorScheme == .dark ? Color.gray : Color.gray))
        }
        .frame(maxWidth: .infinity)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB,red: Double(r) / 255,green: Double(g) / 255,blue: Double(b) / 255,opacity: Double(a) / 255)
    }
}

#Preview {
    ContentView()
}
