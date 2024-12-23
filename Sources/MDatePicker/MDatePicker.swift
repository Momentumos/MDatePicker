//
//  MDatePicker
//
//  Created by Mohamad Yeganeh
//
//  Repository: https://github.com/Momentumos/MDatePicker
//

import SwiftUI


public struct MDatePicker: View {
    
    @Binding public var pickedDate: MPickedDate?
    @State private var currentMonth = Date()
    @State private var isRangeMode = false
    @State private var tmpDateSelection: Date?
    @State private var tmpStartTimeSelection: Date = .init()
    @State private var tmpEndTimeSelection: Date = .init()
    @State private var days: [Date] = []
    
    
    static let daysInAWeek = 7
    static let weeksInAMonth = 5
    
    
    public init(pickedDate: Binding<MPickedDate?>) {
        _pickedDate = pickedDate
        updateStates(with: pickedDate.wrappedValue)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
            
            ZStack {
                HStack {
                    Text(getMonthString(of: currentMonth))
                        .font(.system(size: 16).weight(.medium))
                        .foregroundStyle(Colors.content.main)
                    if !Calendar.current.isDate(currentMonth, equalTo: Date(), toGranularity: .month) {
                        Button {
                            currentMonth = Date()
                        } label: {
                            Text("Show Today")
                                .font(.system(size: 12))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .foregroundStyle(Colors.content.alternative)
                                .background{
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.clear)
                                        .stroke(Colors.border.main, lineWidth: 1, antialiased: true)
                                }
                        }
                        .buttonStyle(.plain)
                        .tint(Colors.content.alternative)
                    }
                }
                HStack {
                    Button {
                        if let date = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
                            currentMonth = date
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                               .resizable()
                               .scaledToFit()
                               .padding(4)
                               .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.borderless)
                    .tint(Colors.content.main)
                    Spacer()
                    Button {
                        if let date = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
                            currentMonth = date
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                               .resizable()
                               .scaledToFit()
                               .padding(4)
                               .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.borderless)
                    .tint(Colors.content.main)

                }
            }
            .frame(height: 48)
            
            // MARK: - Date grids
            
            Grid(horizontalSpacing: 0, verticalSpacing: 2) {
                GridRow {
                    ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { weekday in
                        Text(weekday)
                            .font(.system(size: 12, weight: .medium))
                            .frame(width: 48, height: 48)
                    }
                }
                .padding([.bottom], 4)
                if days.count == Self.weeksInAMonth * Self.daysInAWeek {
                    ForEach(0 ..< Self.weeksInAMonth, id: \.self) { w in
                        GridRow {
                            ForEach(0 ..< Self.daysInAWeek, id: \.self) { d in
                                Button {
                                    let currentDate = days[w * Self.daysInAWeek + d]
                                    if isRangeMode {
                                        if let tmpDateSelection {
                                            let newValue: MPickedDate
                                            if tmpDateSelection < currentDate {
                                                newValue = .range(tmpDateSelection, currentDate)
                                            } else {
                                                newValue = .range(currentDate, tmpDateSelection)
                                            }
                                            if pickedDate != newValue {
                                                pickedDate = newValue
                                            } else {
                                                updateStates(with: pickedDate)
                                            }
                                        } else {
                                            tmpDateSelection = currentDate
                                        }
                                    } else {
                                        pickedDate = .single(currentDate)
                                    }
                                } label: {
                                    Text(getDayString(of: days[w * Self.daysInAWeek + d]))
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(getDayColor(of: days[w * Self.daysInAWeek + d]))
                                        .frame(width: 48, height: 48)
                                        .background(getBackground(for: days[w * Self.daysInAWeek + d]))
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
            }

        }
        .padding(32)
        .frame(width: 400, height: 400)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Colors.background.main)
        }
        .onAppear {
            updateStates(with: pickedDate)
            days = Self.getCalendarDays(of: currentMonth)
        }
        .onChange(of: pickedDate) { _, value in
            updateStates(with: value)
        }
        .onChange(of: currentMonth) { _, _ in
            days = Self.getCalendarDays(of: currentMonth)
        }
        .onChange(of: isRangeMode) { _, _ in
            tmpDateSelection = nil
            pickedDate = nil
        }
        .onChange(of: tmpStartTimeSelection) { _, startTime in
            guard let pickedDate else {
                return
            }
            switch pickedDate {
            case let .single(date):
                self.pickedDate = .single(combine(date: date, time: startTime))
            case let .range(start, end):
                self.pickedDate = .range(combine(date: start, time: startTime), end)
            }
        }
        .onChange(of: tmpEndTimeSelection) { _, endTime in
            guard isRangeMode,
                  case let .range(start, end) = pickedDate
            else {
                return
            }
            pickedDate = .range(start, combine(date: end, time: endTime))
        }
    }
    
    private func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = timeComponents.second
        return calendar.date(from: components) ?? date
    }
    
    

    
    private func getMonthString(of month: Date) -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return formatter.string(from: month)
    }
    
    private func getDayString(of date: Date) -> String {
        let dc = Calendar.current.dateComponents([.day, .weekday], from: date)
        if let day = dc.day {
            return "\(day)"
        } else {
            return ""
        }
    }
    @ViewBuilder
    func getBackground(for day: Date) -> some View {
        let calendar = Calendar.current
        
        if calendar.isDate(day, inSameDayAs: Date()) {
            Circle()
                .stroke(Colors.border.main, lineWidth: 1)
        } else {
            switch pickedDate {
            case let .single(date):
                if calendar.isDate(day, inSameDayAs: date) {
                    Circle().fill(Colors.accent.info)
                } else {
                    Rectangle().fill(.clear)
                }
                
            case let .range(start, end):
                if let tmpDateSelection {
                    if calendar.isDate(day, inSameDayAs: tmpDateSelection) {
                        Circle().fill(Colors.accent.info)
                            .stroke(calendar.isDate(day, inSameDayAs: Date()) ? Colors.border.main : .clear, lineWidth: 1)
                    } else {
                        Rectangle().fill(.clear)
                    }
                } else {
                    if calendar.isDate(day, inSameDayAs: start) || calendar.isDate(day, inSameDayAs: end) {
                        Circle().fill(Colors.accent.info)
                    } else if start ... end ~= day {
                        Rectangle().fill(Colors.background.info)
                    } else {
                        Rectangle().fill(.clear)
                    }
                }
                
            case nil:
                if let tmpDateSelection {
                    if calendar.isDate(day, inSameDayAs: tmpDateSelection) {
                        Circle().fill(Colors.accent.info)
                    } else {
                        Rectangle().fill(.clear)
                    }
                } else {
                    Rectangle().fill(.clear)
                }
            }
        }
    }

    private func getDayColor(of date: Date) -> Color {
        let calendar = Calendar.current
        if calendar.isDate(date, inSameDayAs: Date()) {
            return Colors.content.main
        }
        
        switch pickedDate {
        case let .single(selectedDate):
            if calendar.isDate(date, inSameDayAs: selectedDate) {
                return .white
            }
            
        case let .range(start, end):
            if let tmpDateSelection {
                if calendar.isDate(date, inSameDayAs: tmpDateSelection) {
                    return .white
                }
            } else if calendar.isDate(date, inSameDayAs: start) || calendar.isDate(date, inSameDayAs: end) {
                return .white
            }
            
        case nil:
            break
        }
        
        // Default color for all other days, including the current day
        return calendar.isDate(date, equalTo: currentMonth, toGranularity: .month) ? Colors.content.main : Colors.content.inactive
    }



    private func updateStates(with dateValue: MPickedDate?) {
        guard let dateValue else {
            currentMonth = Date()
            return
        }
        switch dateValue {
        case let .single(date):
            if !Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month) {
                currentMonth = date
            }
            if isRangeMode {
                isRangeMode = false
            }
            tmpDateSelection = nil
            tmpStartTimeSelection = date
        case let .range(start, end):
            if !Calendar.current.isDate(end, equalTo: currentMonth, toGranularity: .month) {
                currentMonth = end
            }
            if !isRangeMode {
                isRangeMode = true
            }
            tmpDateSelection = nil
            tmpStartTimeSelection = start
            tmpEndTimeSelection = end
        }
    }
    
    private static func getCalendarDays(of month: Date) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let dateDc = calendar.dateComponents([.month, .year, .day], from: month)
        var firstDateInMonthDc = dateDc
        firstDateInMonthDc.day = 1
        let firstDateInMonth = calendar.date(from: firstDateInMonthDc)
        guard let firstDateInMonth = firstDateInMonth else {
            return []
        }
        firstDateInMonthDc = calendar.dateComponents([.year, .month, .day, .weekday], from: firstDateInMonth)
        guard var weekday = firstDateInMonthDc.weekday else {
            return []
        }
        weekday -= 1
        let count = weeksInAMonth * daysInAWeek
        for i in 0 ..< count {
            if let date = calendar.date(byAdding: .day, value: i - weekday, to: firstDateInMonth) {
                dates.append(date)
            }
        }
        return dates
    }
}


#Preview {
    @Previewable @State var dateValue: MPickedDate? = .single(.now)
//    @Previewable @State var dateValue: MPickedDate? = .range(.now, .now.addingTimeInterval(9000))
    
    MDatePicker(pickedDate: $dateValue)
        .frame(height: 400)
        .padding()
        .background(.gray)
    
}
