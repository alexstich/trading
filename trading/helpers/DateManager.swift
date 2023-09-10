import Foundation

class DateManager
{
    static let SERVER_TIMEZONE = TimeZone(identifier: "Europe/Moscow")
    
    static let FORMAT_AS_SERVER = "yyyy-MM-dd HH:mm:ss"
    static let FORMAT_EXIF = "yyyy:MM:dd HH:mm:ss"
    static let FORMAT_SHORT = "yyyy-MM-dd"
    static let FORMAT_SHORT_DOT = "d.MM.yyyy"
    static let FORMAT_SHORT_DOT_ = "dd.MM.yyyy"
    static let FORMAT_FOR_ACCOUNT_LOYALTY_STAT = "d.MM.yyyy - HH:mm"
    static let FORMAT_FOR_DISPLAY = "dd MMMM yyyy"
    static let FORMAT_FOR_DISPLAY_SHORT_MONTH = "dd MMM yyyy"
    static let FORMAT_MONTH_YEAR = "MMMM yyyy"
    static let FORMAT_YEAR = "yyyy"
    static let FORMAT_HOUR = "H:mm"
    static let FORMAT_TIME_HH_MM = "HH:mm"
    static let FORMAT_TIME_HH_MM_SS = "HH:mm:ss"
    static let FORMAT_DAY_MONTH = "dd MMMM"
    static let FORMAT_MESSAGE = "yyyy"
    
    static let ALL_FORMATS =
        [
            FORMAT_AS_SERVER,
            FORMAT_EXIF,
            FORMAT_SHORT,
            FORMAT_SHORT_DOT,
            FORMAT_SHORT_DOT_,
            FORMAT_FOR_ACCOUNT_LOYALTY_STAT,
            FORMAT_FOR_DISPLAY,
            FORMAT_FOR_DISPLAY_SHORT_MONTH
    ]
    
    static func formatSecondsToMinSec(interval: Int) -> String
    {
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "mm:ss"
        
        let formattedString = formatter.string(from: Date(timeIntervalSinceReferenceDate: TimeInterval(interval)))
        return formattedString
    }
    
    static func getDateDiffStrNormal(date_start: Date, date_end: Date, short_variant: Bool = false) -> String?
    {
        if date_start > date_end {
            return nil
        }
        
        let dcf = DateComponentsFormatter()
        dcf.allowedUnits = [.year,.month,.day]
        dcf.unitsStyle = .full
        let age_str = dcf.string(from: date_start, to: date_end)
        return age_str!
    }
    
    static func getDateDiffStrShort(date_start: Date, date_end: Date, short_variant: Bool = false) -> String?
    {
        if date_start > date_end {
            return nil
        }
        
        let dcf = DateComponentsFormatter()
        dcf.allowedUnits = [.year,.month,.day]
        dcf.unitsStyle = .short
        let age_str = dcf.string(from: date_start, to: date_end)!.replacingOccurrences(of: ",", with: "")
        return age_str
    }
    
//    static func getDateDiffStrWeeks(date_start: Date, date_end: Date, short_variant: Bool = false) -> String?
//    {
//        if date_start > date_end {
//            return nil
//        }
//
//        let components = Calendar.current.dateComponents([.day], from: date_start, to: date_end)
//        let weeks = Int(components.day! / 7)
//
//        if LocaleManager.isLocaleRussian()
//        {
//            return "\(weeks) неделя"
//        }
//
//        return "\(weeks) week"
//    }
    
//    static func makeDateShort(date_str: String) -> String
//    {
//        var char_pos = 0
//
//        var final_string:String = ""
//
//        date_str.forEach(
//            { char in
//
//                if char.isDigit() || char.isWhitespace {
//                    char_pos = 0
//                    final_string.append(char)
//                }
//
//                if char.isLetter && char_pos == 0 {
//                    final_string.append(char)
//                    final_string.append(".")
//                    char_pos+=1
//                }
//        })
//
//        if final_string.contains("м.") {
//            final_string = final_string.replacingOccurrences(of: "м.", with: "мес.")
//        }
//
//        return final_string
//    }
    
    static func dateFromString(from string: String, format: String = DateManager.FORMAT_AS_SERVER) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: string) {
            return date
        }
        
        for i in 0..<DateManager.ALL_FORMATS.count {
            let format = DateManager.ALL_FORMATS[i]
            dateFormatter.dateFormat = format
            
            if let date = dateFormatter.date(from: string) {
                return date
            }
        }
        
        return nil
    }
    
    static func toHumanFormat(date: Date) -> String
    {
        // Time format
        if date.formatToString(format: FORMAT_SHORT) == Date().formatToString(format: FORMAT_SHORT) {
            return date.formatToString(format: FORMAT_TIME_HH_MM)
        }
        
        // Name format
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let theCalendar = Calendar.current
        let yesterday = theCalendar.date(byAdding: dayComponent, to: Date())?.formatToString(format: FORMAT_SHORT)
        let dateString = date.formatToString(format: FORMAT_SHORT)
        
        if dateString == yesterday {
            return "вчера"
        }
        
        // Day month
        return date.formatToString(format: FORMAT_DAY_MONTH)
    }
}
