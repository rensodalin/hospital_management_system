abstract class Person {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String phone;

  Person({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
  });

  Map<String, dynamic> toJson();

  @override
  String toString() =>
      'ID: $id, Name: $name, Age: $age, Gender: $gender, Phone: $phone';
}
