import 'person.dart';
class Patient extends Person {
  String address;
  String bloodGroup;
  String status;
  List<String> appointments;
  final DateTime registrationDate;

  Patient({
    required String id,
    required String name,
    required int age,
    required String gender,
    required String phone,
    required this.address,
    required this.bloodGroup,
    required this.status,
    this.appointments = const [],
    required this.registrationDate,
  }) : super(id: id, name: name, age: age, gender: gender, phone: phone);  
}
