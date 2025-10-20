import 'person.dart';
import 'enums.dart';

class Doctor extends Person {
  final DoctorSpecialization specialization;
  final List<String> qualifications;
  final double consultationFee;
  final List<String> availableDays;

  Doctor({
    required String id,
    required String name,
    required int age,
    required String gender,
    required String phone,
    required this.specialization,
    required this.qualifications,
    required this.consultationFee,
    required this.availableDays,
  }) : super(id: id, name: name, age: age, gender: gender, phone: phone);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'phone': phone,
        'specialization': specialization.toString(),
        'qualifications': qualifications,
        'consultationFee': consultationFee,
        'availableDays': availableDays,
      };

  factory Doctor.fromJson(Map<String, dynamic> json) {
    // specialization stored as 'EnumName.value' or just value
    final specString = json['specialization'] as String;
    DoctorSpecialization spec;
    try {
      spec = DoctorSpecialization.values.firstWhere((e) =>
          e.toString() == specString ||
          e.toString().split('.').last == specString);
    } catch (_) {
      spec = DoctorSpecialization.generalMedicine;
    }

    final quals = (json['qualifications'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final days = (json['availableDays'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      phone: json['phone'] as String,
      specialization: spec,
      qualifications: quals,
      consultationFee: (json['consultationFee'] as num).toDouble(),
      availableDays: days,
    );
  }

  @override
  String toString() {
    return '''
Doctor Details:
${super.toString()}
Specialization: ${specialization.toString().split('.').last}
Qualifications: ${qualifications.join(', ')}
Consultation Fee: \$${consultationFee.toStringAsFixed(2)}
Available Days: ${availableDays.join(', ')}
''';
  }
}
