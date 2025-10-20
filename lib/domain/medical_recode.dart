class MedicalRecord {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime date;
  final String diagnosis;
  final String treatment;
  final List<String> medications;
  final String notes;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.diagnosis,
    required this.treatment,
    required this.medications,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'doctorId': doctorId,
        'date': date.toIso8601String(),
        'diagnosis': diagnosis,
        'treatment': treatment,
        'medications': medications,
        'notes': notes,
      };
}
