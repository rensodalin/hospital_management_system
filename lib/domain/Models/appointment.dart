class Appointment {
  final String id;
  String medicalRecordId;
  DateTime schedule;
  String reason;
  String status; 

  Appointment({
    required this.id,
    this.medicalRecordId = "",
    required this.schedule,
    required this.reason,
    this.status = "Scheduled",
  });
}



