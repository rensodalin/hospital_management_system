import 'person.dart';
import 'enums.dart';

class Patient extends Person {
  final String address;
  final String bloodGroup;
  final List<String> medicalHistory;
  final PatientStatus status;
  final DateTime registrationDate;

  Patient({
    required String id,
    required String name,
    required int age,
    required String gender,
    required String phone,
    required this.address,
    required this.bloodGroup,
    required this.medicalHistory,
    this.status = PatientStatus.active,
    DateTime? registrationDate,
  })  : registrationDate = registrationDate ?? DateTime.now(),
        super(id: id, name: name, age: age, gender: gender, phone: phone);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'phone': phone,
        'address': address,
        'bloodGroup': bloodGroup,
        'medicalHistory': medicalHistory,
        'status': status.toString(),
        'registrationDate': registrationDate.toIso8601String(),
      };

  factory Patient.fromJson(Map<String, dynamic> json) {
    PatientStatus status;
    final statusString = json['status'] as String?;
    try {
      status = PatientStatus.values.firstWhere((e) =>
          e.toString() == statusString ||
          e.toString().split('.').last == statusString);
    } catch (_) {
      status = PatientStatus.active;
    }

    final medHist = (json['medicalHistory'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final regDate = json['registrationDate'] != null
        ? DateTime.parse(json['registrationDate'] as String)
        : DateTime.now();

    return Patient(
      id: json['id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      bloodGroup: json['bloodGroup'] as String,
      medicalHistory: medHist,
      status: status,
      registrationDate: regDate,
    );
  }

  @override
  String toString() {
    return '''
Patient Details:
${super.toString()}
Address: $address
Blood Group: $bloodGroup
Status: ${status.toString().split('.').last}
Medical History: ${medicalHistory.isEmpty ? 'None' : medicalHistory.join(', ')}
Registration Date: ${registrationDate.toLocal().toString().split(' ')[0]}
''';
  }
}
