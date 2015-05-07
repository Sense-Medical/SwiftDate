//
//  SwiftDates.swift
//  SwiftDates
//
//  Created by Daniele Margutti on 05/05/15.
//  Copyright (c) 2015 breakfastcode. All rights reserved.
//

import UIKit

let D_SECOND = 1
let D_MINUTE = 60
let D_HOUR = 3600
let D_DAY = 86400
let D_WEEK = 604800
let D_YEAR = 31556926

//MARK: STRING EXTENSION SHORTCUTS

public extension String {
	
	/**
	Create a new NSDate object with passed custom format
	
	:param: format format as string
	
	:returns: a new NSDate instance with parsed date, or nil if it's fail
	*/
	func toDate(#format: String!) -> NSDate? {
		return NSDate.date(fromString: self, format: DateFormat.Custom(format))
	}
}

//MARK: ACCESS TO DATE COMPONENTS

public extension NSDate {
	/// Get the year component of the date
	var year : Int			{ return components.year }
	/// Get the month component of the date
	var month : Int			{ return components.month }
	// Get the week of the month component of the date
	var weekOfMonth: Int	{ return components.weekOfMonth }
	// Get the week of the month component of the date
	var weekOfYear: Int		{ return components.weekOfYear }
	/// Get the weekday component of the date
	var weekday: Int		{ return components.weekday }
	/// Get the weekday ordinal component of the date
	var weekdayOrdinal: Int	{ return components.weekdayOrdinal }
	/// Get the day component of the date
	var day: Int			{ return components.day }
	/// Get the hour component of the date
	var hour: Int			{ return components.hour }
	/// Get the minute component of the date
	var minute: Int			{ return components.minute }
	// Get the second component of the date
	var second: Int			{ return components.second }
	// Get the era component of the date
	var era: Int			{ return components.era }

	/// Return the first day of the current date's week
	var firstDayOfWeek : Int {
		let dayInSeconds = NSTimeInterval(D_DAY);
		let distanceToStartOfWeek = dayInSeconds * Double(self.weekday - 1)
		let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
		return NSDate(timeIntervalSinceReferenceDate: interval).day
	}
	
	/// Return the last day of the week
	var lastDayOfWeek : Int {
		let dayInSeconds = NSTimeInterval(D_DAY);
		let distanceToStartOfWeek = dayInSeconds * Double(self.weekday - 1)
		let distanceToEndOfWeek = dayInSeconds * Double(7)
		let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
		return NSDate(timeIntervalSinceReferenceDate: interval).day
	}
	
	/// Return the nearest hour of the date
	var nearestHour:NSInteger{
		var aTimeInterval = NSDate.timeIntervalSinceReferenceDate() + Double(D_MINUTE) * Double(30);
		
		var newDate = NSDate(timeIntervalSinceReferenceDate:aTimeInterval);
		var components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: newDate);
		return components.hour;
	}
}

//MARK: CREATE AND MANIPULATE DATE COMPONENTS

public extension NSDate {
	
	/**
	Create a new NSDate instance from passed string with given format
	
	:param: string date as string
	:param: format parse formate.
	
	:returns: a new instance of the string
	*/
	class func date(fromString string: String, format: DateFormat) -> NSDate? {
		if string.isEmpty {
			return nil
		}
		
		switch format {
		case .ISO8601: // 1972-07-16T08:15:30-05:00
			NSDate.sharedDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
			NSDate.sharedDateFormatter.timeZone = NSTimeZone.localTimeZone()
			NSDate.sharedDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
			return NSDate.sharedDateFormatter.dateFromString(string)
		case .AltRSS: // 09 Sep 2011 15:26:08 +0200
			var formattedString : NSString = string
			if formattedString.hasSuffix("Z") {
				formattedString = formattedString.substringToIndex(formattedString.length-1) + "GMT"
			}
			NSDate.sharedDateFormatter.dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
			return NSDate.sharedDateFormatter.dateFromString(formattedString as String)
		case .RSS: // Fri, 09 Sep 2011 15:26:08 +0200
			var formattedString : NSString = string
			if formattedString.hasSuffix("Z") {
				formattedString = formattedString.substringToIndex(formattedString.length-1) + "GMT"
			}
			NSDate.sharedDateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
			return NSDate.sharedDateFormatter.dateFromString(formattedString as String)
		case .Custom(let dateFormat):
			NSDate.sharedDateFormatter.dateFormat = dateFormat
			return NSDate.sharedDateFormatter.dateFromString(string)
		}
	}

	/**
	Create a new NSDate instance based on refDate (if nil uses current date) and set components
	
	:param: refDate reference date instance (nil to use NSDate())
	:param: year    year component (nil to leave it untouched)
	:param: month   month component (nil to leave it untouched)
	:param: day     day component (nil to leave it untouched)
	:param: tz      time zone component (it's the abbreviation of NSTimeZone, like 'UTC' or 'GMT+2', nil to use current time zone)
	
	:returns: a new NSDate with components changed according to passed params
	*/
	class func date(#refDate: NSDate?, year: Int, month: Int, day: Int, tz: String?) -> NSDate {
		let referenceDate = refDate ?? NSDate()
		return referenceDate.set(year: year, month: month, day: day, hour: 0, minute: 0, second: 0, tz: tz)
	}
	
	/**
	Create a new NSDate instance based on refDate (if nil uses current date) and set components
	
	:param: refDate reference date instance (nil to use NSDate())
	:param: year    year component (nil to leave it untouched)
	:param: month   month component (nil to leave it untouched)
	:param: day     day component (nil to leave it untouched)
	:param: hour    hour component (nil to leave it untouched)
	:param: minute  minute component (nil to leave it untouched)
	:param: second  second component (nil to leave it untouched)
	:param: tz      time zone component (it's the abbreviation of NSTimeZone, like 'UTC' or 'GMT+2', nil to use current time zone)
	
	:returns: a new NSDate with components changed according to passed params
	*/
	class func date(#refDate: NSDate?, year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, tz: String?) -> NSDate {
		let referenceDate = refDate ?? NSDate()
		return referenceDate.set(year: year, month: month, day: day, hour: hour, minute: minute, second: second, tz: tz)
	}
	
	/**
	Return a new NSDate instance with the current date and time set to 00:00:00
	
	:param: tz optional timezone abbreviation
	
	:returns: a new NSDate instance of the today's date
	*/
	class func today(tz: String? = nil) -> NSDate! {
		let nowDate = NSDate()
		return NSDate.date(refDate: nowDate, year: nowDate.year, month: nowDate.month, day: nowDate.day, tz: tz)
	}
	
	/**
	Return a new NSDate istance with the current date minus one day
	
	:param: tz optional timezone abbreviation
	
	:returns: a new NSDate instance which represent yesterday's date
	*/
	class func yesterday(tz: String? = nil) -> NSDate! {
		return today(tz: tz)-1.day
	}
	
	/**
	Return a new NSDate istance with the current date plus one day
	
	:param: tz optional timezone abbreviation
	
	:returns: a new NSDate instance which represent tomorrow's date
	*/
	class func tomorrow(tz: String? = nil) -> NSDate! {
		return today(tz: tz)+1.day
	}
	
	/**
	Individual set single component of the current date instance
	
	:param: year   a non-nil value to change the year component of the instance
	:param: month  a non-nil value to change the month component of the instance
	:param: day    a non-nil value to change the day component of the instance
	:param: hour   a non-nil value to change the hour component of the instance
	:param: minute a non-nil value to change the minute component of the instance
	:param: second a non-nil value to change the second component of the instance
	:param: tz     a non-nil value (timezone abbreviation string as for NSTimeZone) to change the timezone component of the instance
	
	:returns: a new NSDate instance with changed values
	*/
	func set(#year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?, tz: String?) -> NSDate! {
		let components = self.components
		components.year = (year != nil ? year! : self.year)
		components.month = (month != nil ? month! : self.month)
		components.day = (day != nil ? day! : self.day)
		components.hour = (hour != nil ? hour! : self.hour)
		components.minute = (minute != nil ? minute! : self.second)
		components.second = (second != nil ? second! : self.second)
		components.timeZone = (tz != nil ? NSTimeZone(abbreviation: tz!) : NSTimeZone.defaultTimeZone())
		return NSCalendar.currentCalendar().dateFromComponents(components)
	}
	
	/**
	Allows you to set individual date components by passing an array of components name and associated values
	
	:param: componentsDict components dict. Accepted keys are year,month,day,hour,minute,second
	
	:returns: a new date instance with altered components according to passed dictionary
	*/
	func set(#componentsDict: [String:Int]!) -> NSDate? {
		if count(componentsDict) == 0 {
			return self
		}
		let components = self.components
		for (thisComponent,value) in componentsDict {
			let unit : NSCalendarUnit = thisComponent._sdToCalendarUnit()
			components.setValue(value, forComponent: unit);
		}
		return NSCalendar.currentCalendar().dateFromComponents(components)
	}
	
	/**
	Allows you to set a single component by passing it's name (year,month,day,hour,minute,second are accepted).
	Please note: this method return a new immutable NSDate instance (NSDate are immutable, damn!). So while you
	can chain multiple set calls, if you need to alter more than one component see the method above which accept
	different params.
	
	:param: name  the name of the component to alter (year,month,day,hour,minute,second are accepted)
	:param: value the value of the component
	
	:returns: a new date instance
	*/
	func set(name : String!, value : Int!) -> NSDate? {
		let unit : NSCalendarUnit = name._sdToCalendarUnit()
		if unit == nil {
			return nil
		}
		let components = self.components
		components.setValue(value, forComponent: unit);
		return NSCalendar.currentCalendar().dateFromComponents(components)
	}
	
	/**
	Add or subtract (via negative values) components from current date instance
	
	:param: years   nil or +/- years to add or subtract from date
	:param: months  nil or +/- months to add or subtract from date
	:param: weeks   nil or +/- weeks to add or subtract from date
	:param: days    nil or +/- days to add or subtract from date
	:param: hours   nil or +/- hours to add or subtract from date
	:param: minutes nil or +/- minutes to add or subtract from date
	:param: seconds nil or +/- seconds to add or subtract from date
	
	:returns: a new NSDate instance with changed values
	*/
	func add(#years: Int?, months: Int?, weeks: Int?, days: Int?,hours: Int?,minutes: Int?,seconds: Int?) -> NSDate {
		var components = NSDateComponents()
		components.year = years ?? years!
		components.month = months ?? months!
		components.weekOfYear = weeks ?? weeks!
		components.day = days ?? days!
		components.hour = hours ?? hours!
		components.minute = minutes ?? minutes!
		components.second = seconds ?? seconds!
		return self.addComponents(components)
	}
	
	/**
	Add/substract (based on sign) specified component with value
	
	:param: name  component name (year,month,day,hour,minute,second)
	:param: value value of the component
	
	:returns: new date with altered component
	*/
	func add(name : String!, value : Int!) -> NSDate? {
		let unit : NSCalendarUnit = name._sdToCalendarUnit()
		if unit == nil {
			return nil
		}
		let components = self.components
		components.setValue(value, forComponent: unit);
		return self.addComponents(components)
	}
	
	/**
	Add value specified by components in passed dictionary to the current date
	
	:param: componentsDict dictionary of the component to alter with value (year,month,day,hour,minute,second)
	
	:returns: new date with altered components
	*/
	func add(#componentsDict: [String:Int]!) -> NSDate? {
		if count(componentsDict) == 0 {
			return self
		}
		let components = self.components
		for (thisComponent,value) in componentsDict {
			let unit : NSCalendarUnit = thisComponent._sdToCalendarUnit()
			components.setValue(value, forComponent: unit);
		}
		return self.addComponents(components)
	}
}

//MARK: TIMEZONE UTILITIES

public extension NSDate {
	/**
	Return a new NSDate in UTC format from the current system timezone
	
	:returns: a new NSDate instance
	*/
	func toUTC() -> NSDate {
		var tz : NSTimeZone = NSTimeZone.localTimeZone()
		var secs : Int = tz.secondsFromGMTForDate(self)
		return NSDate(timeInterval: NSTimeInterval(secs), sinceDate: self)
	}
	
	/**
	Convert an UTC NSDate instance to a local time NSDate (note: NSDate object does not contains info about the timezone!)
	
	:returns: a new NSDate instance
	*/
	func toLocalTime() -> NSDate {
		var tz : NSTimeZone = NSTimeZone.localTimeZone()
		var secs : Int = -tz.secondsFromGMTForDate(self)
		return NSDate(timeInterval: NSTimeInterval(secs), sinceDate: self)
	}
	
	/**
	Convert an UTC NSDate instance to passed timezone (note: NSDate object does not contains info about the timezone!)
	
	:param: abbreviation abbreviation of the time zone
	
	:returns: a new NSDate instance
	*/
	func toTimezone(abbreviation : String!) -> NSDate? {
		var tz : NSTimeZone? = NSTimeZone(abbreviation: abbreviation)
		if tz == nil {
			return nil
		}
		var secs : Int = tz!.secondsFromGMTForDate(self)
		return NSDate(timeInterval: NSTimeInterval(secs), sinceDate: self)
	}
}

//MARK: COMPARE DATES

public extension NSDate {
	/**
	Return the number of minutes between two dates.
	
	:param: date comparing date
	
	:returns: number of minutes
	*/
	func minutesAfterDate(date: NSDate) -> Int {
		let interval = self.timeIntervalSinceDate(date)
		return Int(interval / NSTimeInterval(D_MINUTE))
	}
	
	func minutesBeforeDate(date: NSDate) -> Int {
		let interval = date.timeIntervalSinceDate(self)
		return Int(interval / NSTimeInterval(D_MINUTE))
	}
	
	func hoursAfterDate(date: NSDate) -> Int {
		let interval = self.timeIntervalSinceDate(date)
		return Int(interval / NSTimeInterval(D_HOUR))
	}
	
	func hoursBeforeDate(date: NSDate) -> Int {
		let interval = date.timeIntervalSinceDate(self)
		return Int(interval / NSTimeInterval(D_HOUR))
	}
	
	func daysAfterDate(date: NSDate) -> Int {
		let interval = self.timeIntervalSinceDate(date)
		return Int(interval / NSTimeInterval(D_DAY))
	}
	
	func daysBeforeDate(date: NSDate) -> Int {
		let interval = date.timeIntervalSinceDate(self)
		return Int(interval / NSTimeInterval(D_DAY))
	}
	
	/**
	Compare two dates and return true if they are equals
	
	:param: date       date to compare with
	:param: ignoreTime true to ignore time of the date
	
	:returns: true if two dates are equals
	*/
	func isEqualToDate(date: NSDate, ignoreTime: Bool) -> Bool {
		if ignoreTime {
			let comp1 = NSDate.components(fromDate: self)
			let comp2 = NSDate.components(fromDate: date)
			return ((comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day == comp2.day))
		} else {
			return self.isEqualToDate(date)
		}
	}
	
	/**
	Return true if given date's time in passed range
	
	:param: minTime min time interval (by default format is "HH:mm", but you can specify your own format in format parameter)
	:param: maxTime max time interval (by default format is "HH:mm", but you can specify your own format in format parameter)
	:param: format  nil or a valid format string used to parse minTime and maxTime from their string representation (when nil HH:mm is used)
	
	:returns: true if date's time component falls into given range
	*/
	func isInTimeRange(minTime: String!, maxTime: String!, format: String?) -> Bool {
		NSDate.sharedDateFormatter.dateFormat = format ?? "HH:mm"
		NSDate.sharedDateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
		let minTimeDate = NSDate.sharedDateFormatter.dateFromString(minTime)
		let maxTimeDate = NSDate.sharedDateFormatter.dateFromString(maxTime)
		if minTimeDate == nil || maxTimeDate == nil {
			return false
		}
		let inBetween = (self.compare(minTimeDate!) == NSComparisonResult.OrderedDescending &&
						 self.compare(maxTimeDate!) == NSComparisonResult.OrderedAscending)
		return inBetween
	}
	
	/**
	Return true if the date's year is a leap year
	
	:returns: true if date's year is a leap year
	*/
	func isLeapYear() -> Bool {
		var year = self.year
		return year % 400 == 0 ? true : ((year % 4 == 0) && (year % 100 != 0))
	}
	
	/**
	Return the number of days in current date's month
	
	:returns: number of days of the month
	*/
	func monthDays () -> Int {
		return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: self).length
	}
	
	/**
	True if the date is the current date
	
	:returns: true if date is today
	*/
	func isToday() -> Bool {
		return self.isEqualToDate(NSDate(), ignoreTime: true)
	}
	
	/**
	True if the date is the current date plus one day (tomorrow)
	
	:returns: true if date is tomorrow
	*/
	func isTomorrow() -> Bool {
		return self.isEqualToDate(NSDate()+1.day, ignoreTime:true)
	}
	
	/**
	True if the date is the current date minus one day (yesterday)
	
	:returns: true if date is yesterday
	*/
	func isYesterday() -> Bool {
		return self.isEqualToDate(NSDate()-1, ignoreTime:true)
	}

	/**
	Return true if the date falls into the current week
	
	:returns: true if date is inside the current week days range
	*/
	func isThisWeek() -> Bool {
		return self.isSameWeekOf(NSDate())
	}
	
	/**
	Return true if the date is in the same week of passed date
	
	:param: date date to compare with
	
	:returns: true if both dates falls in the same week
	*/
	func isSameWeekOf(date: NSDate) -> Bool {
		let comp1 = NSDate.components(fromDate: self)
		let comp2 = NSDate.components(fromDate: date)
		// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
		if comp1.weekOfYear != comp2.weekOfYear {
			return false
		}
		// Must have a time interval under 1 week
		let weekInSeconds = NSTimeInterval(D_WEEK)
		return abs(self.timeIntervalSinceDate(date)) < weekInSeconds
	}
	
	/**
	Return the first day of the passed date's week (Sunday)
	
	:returns: NSDate with the date of the first day of the week
	*/
	func dateAtWeekStart() -> NSDate {
		let flags : NSCalendarUnit = NSCalendarUnit.CalendarUnitYear |
									 NSCalendarUnit.CalendarUnitMonth |
									 NSCalendarUnit.CalendarUnitWeekOfYear |
									 NSCalendarUnit.CalendarUnitWeekday
		var components = NSCalendar.currentCalendar().components(flags, fromDate: self)
		components.weekday = 1 // Sunday
		components.hour = 0
		components.minute = 0
		components.second = 0
		return NSCalendar.currentCalendar().dateFromComponents(components)!
	}

	/// Return a date which represent the beginning of the current day (at 00:00:00)
	var beginningOfDay: NSDate {
		return set(year: nil, month: nil, day: nil, hour: 0, minute: 0, second: 0, tz: nil)
	}

	/// Return a date which represent the end of the current day (at 23:59:59)
	var endOfDay: NSDate {
		return set(year: nil, month: nil, day: nil, hour: 23, minute: 59, second: 59, tz: nil)
	}
	
	/// Return the first day of the month of the current date
	var beginningOfMonth: NSDate {
		return set(year: nil, month: nil, day: 1, hour: 0, minute: 0, second: 0, tz: nil)
	}
	
	/// Return the last day of the month of the current date
	var endOfMonth: NSDate {
		let lastDay = NSCalendar.currentCalendar().rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: self).length
		return set(year: nil, month: nil, day: lastDay, hour: 23, minute: 59, second: 59, tz: nil)
	}
	
	/// Return the first day of the year of the current date
	var beginningOfYear: NSDate {
		return set(year: nil, month: 1, day: 1, hour: 0, minute: 0, second: 0, tz: nil)
	}
	
	/// Return the last day of the year of the current date
	var endOfYear: NSDate {
		return set(year: nil, month: 12, day: 31, hour: 23, minute: 59, second: 59, tz: nil)
	}
	
	/**
	Return true if current date's day is not a weekend day
	
	:returns: true if date's day is a week day, not a weekend day
	*/
	func isWeekday() -> Bool {
		return !self.isWeekend()
	}
	
	/**
	Return true if the date is the weekend
	
	:returns: true or false
	*/
	func isWeekend() -> Bool {
		let range = NSCalendar.currentCalendar().maximumRangeOfUnit(NSCalendarUnit.CalendarUnitWeekday)
		return (self.weekday == range.location || self.weekday == range.length)
	}
	
}

//MARK: CONVERTING DATE TO STRING

public extension NSDate {
	
	/**
	Return a formatted string with passed style for date and time
	
	:param: dateStyle    style of the date component into the output string
	:param: timeStyle    style of the time component into the output string
	:param: relativeDate true to use relative date style
	
	:returns: string representation of the date
	*/
	func toString(#dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle, relativeDate: Bool = false) -> String {
		NSDate.sharedDateFormatter.dateStyle = dateStyle
		NSDate.sharedDateFormatter.timeStyle = timeStyle
		NSDate.sharedDateFormatter.doesRelativeDateFormatting = relativeDate
		return NSDate.sharedDateFormatter.stringFromDate(self)
	}
	
	/**
	Return a new string which represent the NSDate into passed format
	
	:param: format format of the output string. Choose one of the available format or use a custom string
	
	:returns: a string with formatted date
	*/
	func toString(#format: DateFormat) -> String {
		var dateFormat: String
		switch format {
		case .ISO8601:
			dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		case .RSS:
			dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
		case .AltRSS:
			dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
		case .Custom(let string):
			dateFormat = string
		}
		NSDate.sharedDateFormatter.dateFormat = dateFormat
		return NSDate.sharedDateFormatter.stringFromDate(self)
	}
	
	/**
	Return an ISO8601 formatted string from the current date instance
	
	:returns: string with date in ISO8601 format
	*/
	func toISOString() -> String {
		NSDate.sharedDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		NSDate.sharedDateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
		NSDate.sharedDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
		return NSDate.sharedDateFormatter.stringFromDate(self).stringByAppendingString("Z")
	}
	
	/**
	Return a relative string which represent the date instance
	
	:param: fromDate    comparison date (by default is the current NSDate())
	:param: abbreviated true to use abbreviated unit forms (ie. "ys" instead of "years")
	:param: maxUnits    max detail units to print (ie. "1 hour 47 minutes" is maxUnit=2, "1 hour" is maxUnit=1)
	
	:returns: formatted string
	*/
	func toRelativeString(fromDate: NSDate = NSDate(), abbreviated : Bool = false, maxUnits: Int = 1) -> String {
		let seconds = fromDate.timeIntervalSinceDate(self)
		if fabs(seconds) < 1 {
			return "just now"._sdLocalize
		}
		
		let significantFlags : NSCalendarUnit = NSDate.componentFlags()
		let components = NSCalendar.currentCalendar().components(significantFlags, fromDate: fromDate, toDate: self, options: nil)
		
		var string = String()
		var isApproximate:Bool = false
		var numberOfUnits:Int = 0
		let unitList : [String] = ["year", "month", "week", "day", "hour", "minute", "second"]
		for unitName in unitList {
			let unit : NSCalendarUnit = unitName._sdToCalendarUnit()
			if ((significantFlags.rawValue & unit.rawValue) != 0) &&
				(_sdCompareCalendarUnit(NSCalendarUnit.CalendarUnitSecond, other: unit) != .OrderedDescending) {
				let number:NSNumber = NSNumber(float: fabsf(components.valueForKey(unitName)!.floatValue))
				if Bool(number.integerValue) {
					let singular = (number.unsignedIntegerValue == 1)
					let suffix = String(format: "%@ %@", arguments: [number, _sdLocalizeStringForValue(singular, unit: unit, abbreviated: abbreviated)])
					if string.isEmpty {
						string = suffix
					} else if numberOfUnits < maxUnits {
						string += String(format: " %@", arguments: [suffix])
					} else {
						isApproximate = true
					}
					numberOfUnits += 1
				}
			}
		}
		
		if string.isEmpty == false {
			if seconds > 0 {
				string = String(format: "%@ %@", arguments: [string, "ago"._sdLocalize])
			} else {
				string = String(format: "%@ %@", arguments: [string, "from now"._sdLocalize])
			}
			
			if (isApproximate) {
				string = String(format: "about %@", arguments: [string])
			}
		}
		return string
	}
	
	/**
	Return a string representation of the date where both date and time are in short style format
	
	:returns: date's string representation
	*/
	func toShortString() -> String {
		return toString(dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
	}
	
	/**
	Return a string representation of the date where both date and time are in medium style format
	
	:returns: date's string representation
	*/
	func toMediumString() -> String {
		return toString(dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
	}
	
	/**
	Return a string representation of the date where both date and time are in long style format
	
	:returns: date's string representation
	*/
	func toLongString() -> String {
		return toString(dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.LongStyle)
	}
	
	/**
	Return a string representation of the date with only the date in short style format (no time)
	
	:returns: date's string representation
	*/
	func toShortDateString() -> String {
		return toString(dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
	}
	
	/**
	Return a string representation of the date with only the time in short style format (no date)
	
	:returns: date's string representation
	*/
	func toShortTimeString() -> String {
		return toString(dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
	}
	
	/**
	Return a string representation of the date with only the date in medium style format (no date)
	
	:returns: date's string representation
	*/
	func toMediumDateString() -> String {
		return toString(dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)
	}
	
	/**
	Return a string representation of the date with only the time in medium style format (no date)
	
	:returns: date's string representation
	*/
	func toMediumTimeString() -> String {
		return toString(dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
	}

	/**
	Return a string representation of the date with only the date in long style format (no date)
	
	:returns: date's string representation
	*/
	func toLongDateString() -> String {
		return toString(dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
	}
	
	/**
	Return a string representation of the date with only the time in long style format (no date)
	
	:returns: date's string representation
	*/
	func toLongTimeString() -> String {
		return toString(dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.LongStyle)
	}

}

//MARK: PRIVATE ACCESSORY METHODS

private extension NSDate {
	
	private class func components(#fromDate: NSDate) -> NSDateComponents! {
		return NSCalendar.currentCalendar().components(NSDate.componentFlags(), fromDate: fromDate)
	}
	
	private func addComponents(components: NSDateComponents) -> NSDate {
		let cal = NSCalendar.currentCalendar()
		return cal.dateByAddingComponents(components, toDate: self, options: nil)!
	}
	
	private class func componentFlags() -> NSCalendarUnit {
		return NSCalendarUnit.CalendarUnitYear |
			NSCalendarUnit.CalendarUnitMonth |
			NSCalendarUnit.CalendarUnitDay |
			NSCalendarUnit.CalendarUnitWeekOfYear |
			NSCalendarUnit.CalendarUnitHour |
			NSCalendarUnit.CalendarUnitMinute |
			NSCalendarUnit.CalendarUnitSecond  |
			NSCalendarUnit.CalendarUnitWeekday |
			NSCalendarUnit.CalendarUnitWeekdayOrdinal |
			NSCalendarUnit.CalendarUnitWeekOfYear
	}
	
	/// Return the NSDateComponents which represent current date
	private var components: NSDateComponents {
		return  NSCalendar.currentCalendar().components(NSDate.componentFlags(), fromDate: self)
	}
	
	class var sharedDateFormatter : NSDateFormatter {
		struct Static {
			static let instance: NSDateFormatter = {
				let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
				return dateFormatter
				}()
		}
		return Static.instance
	}
}

//MARK: RELATIVE NSDATE CONVERSION PRIVATE METHODS

private extension NSDate {
	func _sdCompareCalendarUnit(unit:NSCalendarUnit, other:NSCalendarUnit) -> NSComparisonResult {
		let nUnit = _sdNormalizedCalendarUnit(unit)
		let nOther = _sdNormalizedCalendarUnit(other)
		
		if (nUnit == NSCalendarUnit.CalendarUnitWeekOfYear) != (nOther == NSCalendarUnit.CalendarUnitWeekOfYear) {
			if nUnit == NSCalendarUnit.CalendarUnitWeekOfYear {
				switch nUnit {
				case NSCalendarUnit.CalendarUnitYear, NSCalendarUnit.CalendarUnitMonth:
					return .OrderedAscending
				default:
					return .OrderedDescending
				}
			} else {
				switch nOther {
				case NSCalendarUnit.CalendarUnitYear, NSCalendarUnit.CalendarUnitMonth:
					return .OrderedDescending
				default:
					return .OrderedAscending
				}
			}
		} else {
			if nUnit.rawValue > nOther.rawValue {
				return .OrderedAscending
			} else if (nUnit.rawValue < nOther.rawValue) {
				return .OrderedDescending
			} else {
				return .OrderedSame
			}
		}
	}
	
	private func _sdNormalizedCalendarUnit(unit:NSCalendarUnit) -> NSCalendarUnit {
		switch unit {
		case NSCalendarUnit.CalendarUnitWeekOfMonth, NSCalendarUnit.CalendarUnitWeekOfYear:
			return NSCalendarUnit.CalendarUnitWeekOfYear
		case NSCalendarUnit.CalendarUnitWeekday, NSCalendarUnit.CalendarUnitWeekdayOrdinal:
			return NSCalendarUnit.CalendarUnitDay
		default:
			return unit;
		}
	}
	
	
	func _sdLocalizeStringForValue(singular : Bool, unit: NSCalendarUnit, abbreviated: Bool = false) -> String {
		var toTranslate : String = ""
		switch unit {
			
		case NSCalendarUnit.CalendarUnitYear where singular:		toTranslate = (abbreviated ? "yr" : "year")
		case NSCalendarUnit.CalendarUnitYear where !singular:		toTranslate = (abbreviated ? "yrs" : "years")
			
		case NSCalendarUnit.CalendarUnitMonth where singular:		toTranslate = (abbreviated ? "mo" : "month")
		case NSCalendarUnit.CalendarUnitMonth where !singular:		toTranslate = (abbreviated ? "mos" : "months")
			
		case NSCalendarUnit.CalendarUnitWeekOfYear where singular:	toTranslate = (abbreviated ? "wk" : "week")
		case NSCalendarUnit.CalendarUnitWeekOfYear where !singular: toTranslate = (abbreviated ? "wks" : "weeks")
			
		case NSCalendarUnit.CalendarUnitDay where singular:			toTranslate = "day"
		case NSCalendarUnit.CalendarUnitDay where !singular:		toTranslate = "days"
			
		case NSCalendarUnit.CalendarUnitHour where singular:		toTranslate = (abbreviated ? "hr" : "hour")
		case NSCalendarUnit.CalendarUnitHour where !singular:		toTranslate = (abbreviated ? "hrs" : "hours")
			
		case NSCalendarUnit.CalendarUnitMinute where singular:		toTranslate = (abbreviated ? "min" : "minute")
		case NSCalendarUnit.CalendarUnitMinute where !singular:		toTranslate = (abbreviated ? "mins" : "minutes")
			
		case NSCalendarUnit.CalendarUnitSecond where singular:		toTranslate = (abbreviated ? "s" : "second")
		case NSCalendarUnit.CalendarUnitSecond where !singular:		toTranslate = (abbreviated ? "s" : "seconds")
			
		default:													toTranslate = ""
		}
		return toTranslate._sdLocalize
	}
	
	func localizedSimpleStringForComponents(components:NSDateComponents) -> String {
		if (components.year == -1) {
			return "last year"._sdLocalize
		} else if (components.month == -1 && components.year == 0) {
			return "last month"._sdLocalize
		} else if (components.weekOfYear == -1 && components.year == 0 && components.month == 0) {
			return "last week"._sdLocalize
		} else if (components.day == -1 && components.year == 0 && components.month == 0 && components.weekOfYear == 0) {
			return "yesterday"._sdLocalize
		} else if (components == 1) {
			return "next year"._sdLocalize
		} else if (components.month == 1 && components.year == 0) {
			return "next month"._sdLocalize
		} else if (components.weekOfYear == 1 && components.year == 0 && components.month == 0) {
			return "next week"._sdLocalize
		} else if (components.day == 1 && components.year == 0 && components.month == 0 && components.weekOfYear == 0) {
			return "tomorrow"._sdLocalize
		}
		return ""
	}
}

//MARK: OPERATIONS WITH DATES (==,!=,<,>,<=,>=)

extension NSDate : Comparable, Equatable {}

public func == (left: NSDate, right: NSDate) -> Bool {
	return (left.compare(right) == NSComparisonResult.OrderedSame)
}

public func != (left: NSDate, right: NSDate) -> Bool {
	return !(left == right)
}

public func < (left: NSDate, right: NSDate) -> Bool {
	return (left.compare(right) == NSComparisonResult.OrderedAscending)
}

public func > (left: NSDate, right: NSDate) -> Bool {
	return (left.compare(right) == NSComparisonResult.OrderedDescending)
}

public func <= (left: NSDate, right: NSDate) -> Bool {
	return !(left > right)
}

public func >= (left: NSDate, right: NSDate) -> Bool {
	return !(left < right)
}

//MARK: ARITHMETIC OPERATIONS WITH DATES (-,-=,+,+=)

func - (left : NSDate, right: NSTimeInterval) -> NSDate {
	return left.dateByAddingTimeInterval(-right)
}

func -= (inout left: NSDate, right: NSTimeInterval) {
	left = left.dateByAddingTimeInterval(-right)
}

func + (left: NSDate, right: NSTimeInterval) -> NSDate {
	return left.dateByAddingTimeInterval(right)
}

func += (inout left: NSDate, right: NSTimeInterval) {
	left = left.dateByAddingTimeInterval(right)
}

func - (left: NSDate, right: CalendarType) -> NSDate {
	let calendarType = right.copy()
	calendarType.amount = -calendarType.amount
	let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
	return calendar.dateByAddingComponents(calendarType.dateComponents(), toDate: left, options: NSCalendarOptions.allZeros)!
}

func -= (inout left: NSDate, right: CalendarType) {
	left = left - right
}

func + (left: NSDate, right: CalendarType) -> NSDate {
	let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
	return calendar.dateByAddingComponents(right.dateComponents(), toDate: left, options: NSCalendarOptions.allZeros)!
}

func += (inout left: NSDate, right: CalendarType) {
	left = left + right
}

//MARK: SUPPORTING STRUCTURES

class CalendarType {
	var calendarUnit : NSCalendarUnit
	var amount : Int
	
	init(amount : Int) {
		self.calendarUnit = NSCalendarUnit.allZeros
		self.amount = amount
	}
	
	init(amount: Int, calendarUnit: NSCalendarUnit) {
		self.calendarUnit = calendarUnit
		self.amount = amount
	}
	
	func dateComponents() -> NSDateComponents {
		return NSDateComponents()
	}
	
	func copy() -> CalendarType {
		return CalendarType(amount: self.amount, calendarUnit: self.calendarUnit)
	}
}

class MonthCalendarType : CalendarType {
	
	override init(amount : Int) {
		super.init(amount: amount)
		self.calendarUnit = NSCalendarUnit.CalendarUnitMonth
	}
	
	override func dateComponents() -> NSDateComponents {
		let components = super.dateComponents()
		components.month = self.amount
		return components
	}
	
}

class YearCalendarType : CalendarType {
	
	override init(amount : Int) {
		super.init(amount: amount, calendarUnit: NSCalendarUnit.CalendarUnitYear)
	}
	
	override func dateComponents() -> NSDateComponents {
		let components = super.dateComponents()
		components.year = self.amount
		return components
	}
	
}

extension Int {
	var seconds : NSTimeInterval {
		return NSTimeInterval(self)
	}
	var second : NSTimeInterval {
		return (self.seconds)
	}
	var minutes : NSTimeInterval {
		return (self.seconds*60)
	}
	var minute : NSTimeInterval {
		return self.minutes
	}
	var hours : NSTimeInterval {
		return (self.minutes*60)
	}
	var hour : NSTimeInterval {
		return self.hours
	}
	var days : NSTimeInterval {
		return (self.hours*24)
	}
	var day : NSTimeInterval {
		return self.days
	}
	var weeks : NSTimeInterval {
		return (self.days*7)
	}
	var week : NSTimeInterval {
		return self.weeks
	}
	var workWeeks : NSTimeInterval {
		return (self.days*5)
	}
	var workWeek : NSTimeInterval {
		return self.workWeeks
	}
	var months : MonthCalendarType {
		return MonthCalendarType(amount: self)
	}
	var month : MonthCalendarType {
		return self.months
	}
	var years : YearCalendarType {
		return YearCalendarType(amount: self)
	}
	var year : YearCalendarType {
		return self.years
	}
}

//MARK: PRIVATE STRING EXTENSION

private extension String {
	
	var _sdLocalize: String {
		return NSBundle.mainBundle().localizedStringForKey(self, value: nil, table: "SwiftDates")
	}
	
	func _sdToCalendarUnit() -> NSCalendarUnit {
		switch self {
		case "year":
			return NSCalendarUnit.CalendarUnitYear
		case "month":
			return NSCalendarUnit.CalendarUnitMonth
		case "week":
			return NSCalendarUnit.CalendarUnitWeekOfYear
		case "day":
			return NSCalendarUnit.CalendarUnitDay
		case "hour":
			return NSCalendarUnit.CalendarUnitHour
		case "minute":
			return NSCalendarUnit.CalendarUnitMinute
		case "second":
			return NSCalendarUnit.CalendarUnitSecond
		default:
			return nil
		}
	}
}

public enum DateFormat {
	case ISO8601, RSS, AltRSS
	case Custom(String)
}