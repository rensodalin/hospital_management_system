import 'dart:convert';
import '../domain/MedicalRecord.dart';
import 'dart:io';

class MedicalRecordRepository {
  final String filePath;

  MedicalRecordRepository({required this.filePath});

  List<MedicalRecord> readMedicalRecord() {
    final file = File(filePath);
    final content = file.readAsStringSync();
    final data = jsonDecode(content);

    var medicalRecordJson = data['medicalRecords'] as List;
    var medicalRecords = medicalRecordJson.map((a) {
      return MedicalRecord(
      id: a['id'],
      date: DateTime.parse(a['date']),
      diagnosis: a['diagnosis'],
      prescriptions: a['prescriptions'],
      notes: a['notes'],
      );
    }).toList();
    return medicalRecords;
  }

  void writeMedicalRecords(List<MedicalRecord> medicalRecords) {
    final file = File(filePath);
    var medicalRecordsJson = medicalRecords
        .map((p) => {
              'id': p.id,
              'date': p.date.toIso8601String(),
              'diagnosis': p.diagnosis,
              'prescriptions': p.prescriptions,
              'notes': p.notes
            })
        .toList();

    var data = {'medicalRecords': medicalRecordsJson};

    const encoder = JsonEncoder.withIndent('  '); //Line 51-52 AI generate
    final jsonString = encoder.convert(data);

    file.writeAsStringSync(jsonString);
  }
}
