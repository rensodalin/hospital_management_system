import 'dart:convert';
import '../../domain/Models/patient.dart';
import 'dart:io';

class PatientRepository {
  final String filePath;

  PatientRepository({required this.filePath});

  List<Patient> readPatient() {
    final file = File(filePath);
    final content = file.readAsStringSync();
    final data = jsonDecode(content);

    var patientsJson = data['patients'] as List;
    var patients = patientsJson.map((p) {
      return Patient(
        id: p['id'],
        name: p['name'],
        age: p['age'],
        gender: p['gender'],
        phone: p['phone'],
        address: p['address'],
        bloodGroup: p['bloodGroup'],
        appointments: List<String>.from(p['appointments']),
        registrationDate: DateTime.parse(p['registrationDate']),
      );
    }).toList();
    return patients;
  }

  void writePatients(List<Patient> patients) {
    final file = File(filePath);
    var patientsJson = patients
        .map((p) => {
              'id': p.id,
              'name': p.name,
              'age': p.age,
              'gender': p.gender,
              'phone': p.phone,
              'address': p.address,
              'bloodGroup': p.bloodGroup,
              'appointments': p.appointments,
              'registrationDate': p.registrationDate.toIso8601String(),
            })
        .toList();

    var data = {'patients': patientsJson};

    const encoder = JsonEncoder.withIndent('  '); //Line 51-52 AI generate
    final jsonString = encoder.convert(data);

    file.writeAsStringSync(jsonString);
  }
}
