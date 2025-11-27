import 'package:hive/hive.dart';

part 'attendance_record.g.dart';

@HiveType(typeId: 2)
class AttendanceRecord extends HiveObject {
  @HiveField(0)
  String studentId;

  @HiveField(1)
  DateTime timestamp;

  @HiveField(2)
  double latitude;

  @HiveField(3)
  double longitude;

  @HiveField(4)
  bool isVerified;

  @HiveField(5)
  String? subjectName;

  AttendanceRecord({
    required this.studentId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.isVerified,
    this.subjectName,
  });
}
