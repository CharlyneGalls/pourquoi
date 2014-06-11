//
//  NSDate+NVTimeAgo.m
//  Pourquoi
//
//  Created by Charlyne Rivera on 06/05/2014.
//  Copyright (c) 2014 Charlyne Rivera. All rights reserved.
//

#import "NSDate+NVTimeAgo.h"

@implementation NSDate (NVFacebookTimeAgo)


#define SECOND  1
#define MINUTE  (SECOND * 60)
#define HOUR    (MINUTE * 60)
#define DAY     (HOUR   * 24)
#define WEEK    (DAY    * 7)
#define MONTH   (DAY    * 31)
#define YEAR    (DAY    * 365.24)

+ (NSString *)mysqlDatetimeFormattedAsTimeAgo:(NSString *)mysqlDatetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:mysqlDatetime];
    
    return [date formattedAsTimeAgo];
    
}

- (NSString *)formattedAsTimeAgo
{
    NSDate *now = [NSDate date];
    NSTimeInterval secondsSince = -(int)[self timeIntervalSinceDate:now];

    if(secondsSince < 0)
        return @"Dans le futur";

    if(secondsSince < MINUTE)
        return @"À l'instant";
    
    if(secondsSince < HOUR)
        return [self formatMinutesAgo:secondsSince];
  
    if([self isSameDayAs:now])
        return [self formatAsToday:secondsSince];
 
    if([self isYesterday:now])
        return [self formatAsYesterday];
  
    if([self isLastWeek:secondsSince])
        return [self formatAsLastWeek];

    if([self isLastMonth:secondsSince])
        return [self formatAsLastMonth];
    
    if([self isLastYear:secondsSince])
        return [self formatAsLastYear];

    return [self formatAsOther];
    
}

- (BOOL)isSameDayAs:(NSDate *)comparisonDate
{
    NSDateFormatter *dateComparisonFormatter = [[NSDateFormatter alloc] init];
    [dateComparisonFormatter setDateFormat:@"yyyy-MM-dd"];

    return [[dateComparisonFormatter stringFromDate:self] isEqualToString:[dateComparisonFormatter stringFromDate:comparisonDate]];
}

- (BOOL)isYesterday:(NSDate *)now
{
    return [self isSameDayAs:[now dateBySubtractingDays:1]];
}

- (NSDate *)dateBySubtractingDays: (NSInteger) numDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + DAY * -numDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (BOOL)isLastWeek:(NSTimeInterval)secondsSince
{
    return secondsSince < WEEK;
}

- (BOOL)isLastMonth:(NSTimeInterval)secondsSince
{
    return secondsSince < MONTH;
}

- (BOOL)isLastYear:(NSTimeInterval)secondsSince
{
    return secondsSince < YEAR;
}

- (NSString *)formatMinutesAgo:(NSTimeInterval)secondsSince
{
    int minutesSince = (int)secondsSince / MINUTE;
    
    if(minutesSince == 1)
        return @"1 minute";
    else
        return [NSString stringWithFormat:@"%d minutes", minutesSince];
}

- (NSString *)formatAsToday:(NSTimeInterval)secondsSince
{
    int hoursSince = (int)secondsSince / HOUR;
    
    if(hoursSince == 1)
        return @"1 heure";
    else
        return [NSString stringWithFormat:@"%d heures", hoursSince];
}

- (NSString *)formatAsYesterday
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"h:mm a"];
    return [NSString stringWithFormat:@"Hier - %@", [dateFormatter stringFromDate:self]];
}

- (NSString *)formatAsLastWeek
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];

    [dateFormatter setDateFormat:@"EEEE - h:mm"];
    return [[dateFormatter stringFromDate:self] capitalizedString];
}

- (NSString *)formatAsLastMonth
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    
    [dateFormatter setDateFormat:@"d MMMM - h:mm"];
    return [[dateFormatter stringFromDate:self] capitalizedString];
}

- (NSString *)formatAsLastYear
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    
    [dateFormatter setDateFormat:@"d MMMM"];
    return [[dateFormatter stringFromDate:self] capitalizedString];
}

- (NSString *)formatAsOther
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    
    [dateFormatter setDateFormat:@"d LLLL yyyy"];
    return [[dateFormatter stringFromDate:self] capitalizedString];
}

+ (void)runTests
{
    NSLog(@"1 Second in the future: %@\n", [[NSDate dateWithTimeIntervalSinceNow:1] formattedAsTimeAgo]);
    NSLog(@"Now: %@\n", [[NSDate dateWithTimeIntervalSinceNow:0] formattedAsTimeAgo]);
    NSLog(@"1 Second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-1] formattedAsTimeAgo]);
    NSLog(@"10 Seconds: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-10] formattedAsTimeAgo]);
    NSLog(@"1 Minute: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-60] formattedAsTimeAgo]);
    NSLog(@"2 Minutes: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-120] formattedAsTimeAgo]);
    NSLog(@"1 Hour: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-HOUR] formattedAsTimeAgo]);
    NSLog(@"2 Hours: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-2*HOUR] formattedAsTimeAgo]);
    NSLog(@"1 Day: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-1*DAY] formattedAsTimeAgo]);
    NSLog(@"1 Day + 3 seconds: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-1*DAY-3] formattedAsTimeAgo]);
    NSLog(@"2 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-2*DAY] formattedAsTimeAgo]);
    NSLog(@"3 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-3*DAY] formattedAsTimeAgo]);
    NSLog(@"5 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-5*DAY] formattedAsTimeAgo]);
    NSLog(@"6 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-6*DAY] formattedAsTimeAgo]);
    NSLog(@"7 Days - 1 second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-7*DAY+1] formattedAsTimeAgo]);
    NSLog(@"10 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-10*DAY] formattedAsTimeAgo]);
    NSLog(@"1 Month + 1 second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-MONTH-1] formattedAsTimeAgo]);
    NSLog(@"1 Year - 1 second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-YEAR+1] formattedAsTimeAgo]);
    NSLog(@"1 Year + 1 second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-YEAR+1] formattedAsTimeAgo]);
}

@end
