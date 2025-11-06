import 'package:hospital_management_system/domain/Models/appointment.dart';
import 'package:hospital_management_system/domain/Models/MedicalRecord.dart';
import 'package:hospital_management_system/domain/Models/patient.dart';
import 'package:test/test.dart';
import 'package:hospital_management_system/domain/Service.dart';

main() {
  late Service service;
  setUp(() {
    List<Patient> patients = [
      Patient(id: 'P001', name: 'John Doe', age: 25, gender: 'male', phone: '1234567890', address: '123 Main St', bloodGroup: 'A+',appointments: ['A001', 'A002'], registrationDate: DateTime(2025, 1, 1)),
      Patient(id: 'P002', name: 'Jane Smith', age: 30, gender: 'female', phone: '0987654321', address: '456 Maple Ave', bloodGroup: 'B+',appointments: ['A003'], registrationDate: DateTime(2025, 2, 15))
    ];
    
    List<Appointment> appointments = [
      Appointment(id: 'A001', schedule: DateTime(2025, 11, 10, 9, 30), reason: 'Routine Checkup', medicalRecordId: "M001"),
      Appointment(id: 'A002', schedule: DateTime(2025, 11, 11, 14, 0), reason: 'Follow-up Visit', medicalRecordId: "M002"),
      Appointment(id: 'A003', schedule: DateTime(2025, 11, 12, 10, 0), reason: 'New Patient', medicalRecordId: "M003")
    ];

    List<MedicalRecord> medicalRecords = [
      MedicalRecord(id: 'M001', date: DateTime(2025, 11, 10), diagnosis: 'Flu', prescriptions: "Paracetamol, Vitamin C", notes: 'Patient should rest and drink plenty of fluids'),
      MedicalRecord(id: 'M002', date: DateTime(2025, 11, 11), diagnosis: 'Sprained Ankle', prescriptions: "Painkiller, Ice Pack", notes: 'Avoid walking long distances for a week'),
      MedicalRecord(id: 'M003', date: DateTime(2025, 11, 12), diagnosis: 'Chest Pain', prescriptions: "Rest and drink fluids", notes: 'Patient should rest and drink plenty of fluids')
    ];

    service = Service(patients: patients, appointments: appointments, medicalRecords: medicalRecords);
  });

  
// Case: 1
  test('Test create patient', () {
    Patient patient = Patient(id: 'P004',name: 'Leng Menghan',age: 20,gender: 'male',phone: '1234567890',address: '123 Main St',bloodGroup: 'A+', registrationDate: DateTime.now(),);
    service.addPatient(patient);
    expect(service.patients.length, equals(3));
  });

// Case: 2
  test('Test remove patient', () {
    service.removePatient("P001");
    expect(service.patients.length, equals(1));
    expect(service.appointments.length, equals(1));
    expect(service.medicalRecords.length, equals(1));
  });

// Case:3
  test("Remove Patient's appointment",(){
    service.removeAppointment("A002");
    expect(service.medicalRecords.length, equals(2));
  });

// Case: 4
  test("Remove Patient's medical record",(){
    service.removeMedicalRecord("M002");
    expect(service.searchAppointment("A002").medicalRecordId, equals(""));
  });

// Case: 5
  test("Search Patient",(){
    expect(service.searchPatient("P002").name, equals("Jane Smith"));
  });

// Case: 6
  test("Get appointment by Patient",(){
    expect(service.getAppointmentsByPatient("P001").length, equals(2));
  });

// Case: 7
  test("Update appointment Schedule",(){
    service.updateAppointmentSchedule("A002", DateTime(1111, 1, 1));
    expect(service.searchAppointment("A002").schedule, equals(DateTime(1111, 1, 1)));
  });

// Case: 8
  test("Get medical record by patient",(){
    expect(service.getMedicalRecordsByPatient("P001")[0].diagnosis, equals("Flu"));
  });
}
