import 'enums.dart';

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateTime;
  AppointmentStatus status;
  final String reason;
  String? diagnosis;
  String? prescription;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateTime,
    this.status = AppointmentStatus.scheduled,
    required this.reason,
    this.diagnosis,
    this.prescription,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'doctorId': doctorId,
        'dateTime': dateTime.toIso8601String(),
        'status': status.toString(),
        'reason': reason,
        'diagnosis': diagnosis,
        'prescription': prescription,
      };

  factory Appointment.fromJson(Map<String, dynamic> json) {
    AppointmentStatus status;
    final statusString = json['status'] as String?;
    try {
      status = AppointmentStatus.values.firstWhere((e) =>
          e.toString() == statusString ||
          e.toString().split('.').last == statusString);
    } catch (_) {
      status = AppointmentStatus.scheduled;
    }

    final dt = DateTime.parse(json['dateTime'] as String);

    return Appointment(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      dateTime: dt,
      status: status,
      reason: json['reason'] as String,
      diagnosis: json['diagnosis'] as String?,
      prescription: json['prescription'] as String?,
    );
  }

  @override
  String toString() => '''
    Appointment Details:
    ID: $id
    Patient ID: $patientId
    Doctor ID: $doctorId
    Date & Time: ${dateTime.toLocal()}
    Status: ${status.toString().split('.').last}
    Reason: $reason
    ${diagnosis != null ? 'Diagnosis: $diagnosis' : ''}
    ${prescription != null ? 'Prescription: $prescription' : ''}
    ''';
    }
