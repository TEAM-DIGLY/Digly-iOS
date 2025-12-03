import SwiftUI

struct AlarmListView: View {
    @StateObject private var viewModel = AlarmViewModel()
    
    var body: some View {
        DGScreen(horizontalPadding: 0) {
            VStack(spacing: 0) {
                BackNavWithTitle(title:"알림함")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                List {
                    Section {
                        ForEach(Array(zip(viewModel.alarms.indices, viewModel.alarms)), id: \.1.id) { index, alarm in
                            VStack(spacing: 0) {
                                AlarmRow(alarm: alarm)
                                    .padding(.horizontal, 12)
                                    .padding(.bottom, 6)
                                    .onAppear {
                                        if index == viewModel.alarms.count - 5 && viewModel.hasMorePages && !viewModel.isLoadingMore {
                                            viewModel.loadNextPage()
                                        }
                                    }
                                
                                Divider()
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(.common100)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteAlarm(alarm.id)
                                } label: {
                                    Text("삭제")
                                }
                            }
                        }
                        
                        if viewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.refresh()
                }
                .onAppear {
                    if viewModel.alarms.isEmpty {
                        Task { await viewModel.refresh() }
                    }
                }
            }
        }
    }
}

#Preview {
    AlarmListView()
}
