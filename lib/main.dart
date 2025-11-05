import './ui/Console.dart';
import 'domain/Service.dart';
import './data/PatientRepository.dart';
import './data/AppointmentRepository.dart';
import './data/MedicalRecordRepository.dart';
import './domain/Patient.dart';
import './domain/Appointment.dart';
import './domain/MedicalRecord.dart';
void main() {
  PatientRepository patientrepository = PatientRepository(filePath: '../assets/patient.json');
  AppointmentRepository appointmentrepository = AppointmentRepository(filePath: '../assets/appointment.json');
  MedicalRecordRepository medicalrecordrepository = MedicalRecordRepository(filePath: '../assets/medicalrecord.json');
  List<Patient> patients = patientrepository.readPatient();
  List<Appointment> appointments = appointmentrepository.readAppointment();
  List<MedicalRecord> medicalRecords = medicalrecordrepository.readMedicalRecord();
  Service service = Service(patients: patients, appointments: appointments, medicalRecords: medicalRecords);
  Console console =  Console(service: service);
try {
  console.startSystem();
} finally {
  patientrepository.writePatients(patients);
  appointmentrepository.writeAppointments(appointments);
  medicalrecordrepository.writeMedicalRecords(medicalRecords);
}

}