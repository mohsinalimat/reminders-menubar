import SwiftUI
import EventKit

struct ContentView: View {
    @State private var remindersStore = RemindersService.instance.getReminders()
    @State private var isFilterEnabled = true
    
    var body: some View {
        VStack(spacing: 0) {
            FormNewReminderView(reload: { self.reload() })
            List {
                ForEach(remindersStore) { reminderList in
                    VStack(alignment: .leading) {
                        Text(reminderList.title)
                            .font(.headline)
                            .foregroundColor(Color(reminderList.color))
                            .padding(.top, 5)
                        ForEach(self.filteredReminders(reminderList.reminders), id: \.calendarItemIdentifier) { reminder in
                            ReminderItemView(reminder: reminder, reload: { self.reload() })
                        }
                    }
                }
            }
            .onAppear {
                self.reload()
            }
            HStack {
                Button(action: {
                    self.isFilterEnabled.toggle()
                }) {
                    Image(self.isFilterEnabled ? "circle" : "circle.filled")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(5)
            .padding(.bottom, 5)
            .background(Color.darkTheme)
        }
    }
    
    private func reload() {
        self.remindersStore = RemindersService.instance.getReminders()
    }
    
    private func filteredReminders(_ reminders: [EKReminder]) -> [EKReminder] {
        if isFilterEnabled {
            return reminders
                .filter{ !$0.isCompleted }
                .sorted(by: { $0.creationDate!.compare($1.creationDate!) == .orderedDescending })
        } else {
            return
                reminders
                    .filter{ !$0.isCompleted }
                    .sorted(by: { $0.creationDate!.compare($1.creationDate!) == .orderedDescending })
                    +
                    reminders
                        .filter{ $0.isCompleted }
                        .sorted(by: { $0.completionDate!.compare($1.completionDate!) == .orderedDescending })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}