import 'data/hospital_repository.dart';
import 'ui/hospital_management_ui.dart';
import 'domain/doctor.dart';
import 'domain/patient.dart';
import 'domain/appointment.dart';
import 'domain/enums.dart';

void main() {
  final repository = HospitalRepository();

  // Add demo data
  if (repository.getAllDoctors().isEmpty) {
    repository.addDoctor(Doctor(
      id: 'D001',
      name: 'Dr. Sarah Johnson',
      age: 45,
      gender: 'F',
      phone: '012345678',
      specialization: DoctorSpecialization.cardiology,
      qualifications: ['MD', 'PhD'],
      consultationFee: 150.0,
      availableDays: ['Monday', 'Wednesday', 'Friday'],
    ));
  }

  if (repository.getAllPatients().isEmpty) {
    repository.addPatient(Patient(
      id: 'P001',
      name: 'John Doe',
      age: 40,
      gender: 'M',
      phone: '0987654321',
      address: 'Phnom Penh',
      bloodGroup: 'A+',
      medicalHistory: ['Hypertension'],
    ));
  }

  if (repository.getAllAppointments().isEmpty) {
    // create appointment on the next available day for the doctor
    final doc = repository.getDoctorById('D001');
    DateTime apptDate = DateTime.now().add(Duration(days: 1));
    if (doc != null && doc.availableDays.isNotEmpty) {
      // normalize available to 3-letter codes
      final codes = doc.availableDays
          .map((d) => d.toString().substring(0, 3).toLowerCase())
          .toList();
      // find next day within 7 days matching availability
      for (int i = 1; i <= 7; i++) {
        final candidate = DateTime.now().add(Duration(days: i));
        final code = [
          'mon',
          'tue',
          'wed',
          'thu',
          'fri',
          'sat',
          'sun'
        ][candidate.weekday - 1];
        if (codes.contains(code)) {
          apptDate = candidate;
          break;
        }
      }
    }

    repository.addAppointment(Appointment(
      id: 'A001',
      patientId: 'P001',
      doctorId: 'D001',
      dateTime: apptDate,
      reason: 'Routine Checkup',
    ));
  }

  final ui = HospitalManagementUI(repository);
  ui.run();
}
