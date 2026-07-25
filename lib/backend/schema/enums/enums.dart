import 'package:collection/collection.dart';

enum HolidayType {
  holiday,
  exam,
  event,
  vacation,
  midsem,
  endsem,
  fest,
  other,
}

enum CourseType {
  IC,
  DC,
  DE,
  OE,
  HM,
  DA,
  LB,
  PC,
}

enum ChallengeCondition {
  attend_x_classes,
  attend_full_day,
  maintain_streak,
  early_checkin,
  burst_attendance,
  attend_percentage,
}

enum UserRole {
  student,
  faculty,
  admin,
}

enum AcheivementCondition {
  first_class,
  total_classes_attended,
  total_full_days,
  streak_reached,
  attendance_percentage_maintained,
}

enum ChallengeType {
  monthly,
  weekly,
}

enum ScheduleViewType {
  today,
  current,
  upcoming,
  calendarDay,
  calendarRange,
}

enum TimeFormat {
  twentyFourHour,
  twelveHour,
}

enum WeekendPolicy {
  includeAll,
  excludeAll,
  excludeSaturdays,
  excludeSundays,
}

enum DateRange {
  sevenDays,
  tenDays,
  thirtyDays,
}

enum ActionTone {
  playful,
  direct,
  motivational,
  roast,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (HolidayType):
      return HolidayType.values.deserialize(value) as T?;
    case (CourseType):
      return CourseType.values.deserialize(value) as T?;
    case (ChallengeCondition):
      return ChallengeCondition.values.deserialize(value) as T?;
    case (UserRole):
      return UserRole.values.deserialize(value) as T?;
    case (AcheivementCondition):
      return AcheivementCondition.values.deserialize(value) as T?;
    case (ChallengeType):
      return ChallengeType.values.deserialize(value) as T?;
    case (ScheduleViewType):
      return ScheduleViewType.values.deserialize(value) as T?;
    case (TimeFormat):
      return TimeFormat.values.deserialize(value) as T?;
    case (WeekendPolicy):
      return WeekendPolicy.values.deserialize(value) as T?;
    case (DateRange):
      return DateRange.values.deserialize(value) as T?;
    case (ActionTone):
      return ActionTone.values.deserialize(value) as T?;
    default:
      return null;
  }
}
