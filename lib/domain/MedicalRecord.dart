class MedicalRecord {
  final String id;
  final DateTime date;
  String diagnosis;
  String prescriptions ;
  String notes;

  MedicalRecord({
    required this.id,
    required this.date,
    required this.diagnosis,
    required this.prescriptions,
    required this.notes,
  });
}
