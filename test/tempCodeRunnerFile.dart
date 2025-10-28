import 'package:test/test.dart';
import '../lib/data/hospital_repository.dart';
import '../lib/domain/doctor.dart';
import '../lib/domain/patient.dart';
import '../lib/domain/appointment.dart';
import '../lib/domain/enums.dart';

// @dart=2.9
import 'package:test/test.dart';
import '../lib/data/hospital_repository.dart';
import '../lib/domain/doctor.dart';
import '../lib/domain/patient.dart';
import '../lib/domain/appointment.dart';
import '../lib/domain/enums.dart';

void main() {
  group('Hospital Management System Tests', () {
    late HospitalRepository repo;
    late Doctor testDoctor;
    late Patient testPatient;

    setUp(() {
      repo = HospitalRepository();
      testDoctor = Doctor(
        id: 'D001',
        name: 'Dr. Test',
        age: 40,
        gender: 'M',
        phone: '000',
        specialization: DoctorSpecialization.generalMedicine,
        qualifications: ['MD'],
        consultationFee: 100.0,
        availableDays: ['Monday'],
      );
      testPatient = Patient(
        id: 'P001',
        name: 'Patient Test',
        age: 30,
        gender: 'F',
        phone: '111',
        address: 'Phnom Penh',
        bloodGroup: 'O+',
        medicalHistory: [],
      );

      repo.addDoctor(testDoctor);
      repo.addPatient(testPatient);
    });

    test('Basic appointment scheduling works', () {
      final appointment = Appointment(
        id: 'A001',
        patientId: testPatient.id,
        doctorId: testDoctor.id,
        dateTime: DateTime.now(),
        reason: 'Test Appointment',
      );

      repo.addAppointment(appointment);
      expect(repo.getAllAppointments().length, equals(1));
      expect(repo.getAllAppointments().first.status,
          equals(AppointmentStatus.scheduled));
    });

    test('Appointment status can be updated', () {
      final appointment = Appointment(
        id: 'A002',
        patientId: testPatient.id,
        doctorId: testDoctor.id,
        dateTime: DateTime.now(),
        reason: 'Status Test',
      );

      repo.addAppointment(appointment);
      final storedAppointment = repo.getAllAppointments().first;

      storedAppointment.status = AppointmentStatus.inProgress;
      expect(repo.getAllAppointments().first.status,
          equals(AppointmentStatus.inProgress));

      storedAppointment.status = AppointmentStatus.completed;
      expect(repo.getAllAppointments().first.status,
          equals(AppointmentStatus.completed));
    });

    test('Appointment can be updated with diagnosis and prescription', () {
      final appointment = Appointment(
        id: 'A003',
        patientId: testPatient.id,
        doctorId: testDoctor.id,
        dateTime: DateTime.now(),
        reason: 'Update Test',
      );

      repo.addAppointment(appointment);
      final storedAppointment = repo.getAllAppointments().first;

      storedAppointment.diagnosis = 'Common Cold';
      storedAppointment.prescription = 'Rest and fluids';

      expect(repo.getAllAppointments().first.diagnosis, equals('Common Cold'));
      expect(repo.getAllAppointments().first.prescription,
          equals('Rest and fluids'));
    });

    test('Cannot schedule duplicate appointment IDs', () {
      final appointment1 = Appointment(
        id: 'A004',
        patientId: testPatient.id,
        doctorId: testDoctor.id,
        dateTime: DateTime.now(),
        reason: 'First Appointment',
      );

      final appointment2 = Appointment(
        id: 'A004', // Same ID
        patientId: testPatient.id,
        doctorId: testDoctor.id,
        dateTime: DateTime.now(),
        reason: 'Second Appointment',
      );

      repo.addAppointment(appointment1);
      expect(
        () => repo.addAppointment(appointment2),
        throwsException,
      );
    });
  });
}
