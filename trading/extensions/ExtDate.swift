import Foundation

extension Date
{    
    func formatToString(format: String = DateManager.FORMAT_FOR_DISPLAY_SHORT_MONTH, timeZone: TimeZone? = nil) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        
        if timeZone == nil {
            dateFormatter.timeZone = .current
        } else {
            dateFormatter.timeZone = timeZone
        }
        
        return dateFormatter.string(from: self)
    }
    
    func formatForServerShort() -> String
    {
        let format = DateManager.FORMAT_SHORT
        return formatToString(format: format)
    }
    
    func getNumberOfMonth(timeZone: TimeZone? = nil) -> Int?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        
        if timeZone == nil {
            dateFormatter.timeZone = .current
        } else {
            dateFormatter.timeZone = timeZone
        }
        
        return Int(dateFormatter.string(from: self))
    }
    
    func addDays(days: Int) -> Date
    {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func addMonth(months: Int) -> Date
    {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    static func get_milliseconds_since1970()->UInt64
    {
        let timestamp = UInt64(floor(Date().timeIntervalSince1970 * 1000))
        return timestamp
    }
    
    func currentTimeMillis() -> Int64
    {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func setHoursMinSec(hours: Int, min: Int, sec: Int) -> Date?
    {
        return Calendar.current.date(bySettingHour: hours, minute: min, second: sec, of: self)
    }
}


extension Date
{
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool
    {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
    
    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }
    
    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }
    
    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}
