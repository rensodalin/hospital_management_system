import 'dart:convert';
import '../../domain/Models/appointment.dart';
import 'dart:io';

class AppointmentRepository {
  final String filePath;

  AppointmentRepository({required this.filePath});

  List<Appointment> readAppointment() {
    final file = File(filePath);
    final content = file.readAsStringSync();
    final data = jsonDecode(content);

    var appointmentJson = data['appointments'] as List;
    var appointments = appointmentJson.map((a) {
      return Appointment(
      id: a['id'],
      medicalRecordId: a['medicalRecordId'],
      schedule: DateTime.parse(a['schedule']),
      reason: a['reason'],
      status: a['status'],
      );
    }).toList();
    return appointments;
  }

  void writeAppointments(List<Appointment> appointments) {
    final file = File(filePath);
    var appointmentsJson = appointments
        .map((p) => {
              'id': p.id,
              'medicalRecordId': p.medicalRecordId,
              'schedule': p.schedule.toIso8601String(),
              'reason': p.reason,
              'status': p.status
            })
        .toList();

    var data = {'appointments': appointmentsJson};

    const encoder = JsonEncoder.withIndent('  '); //Line 51-52 AI generate
    final jsonString = encoder.convert(data);

    file.writeAsStringSync(jsonString);
  }
}
