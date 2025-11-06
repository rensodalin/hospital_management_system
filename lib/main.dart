import './ui/Console.dart';
import 'domain/Service.dart';
import 'data/Repositories/PatientRepository.dart';
import 'data/Repositories/AppointmentRepository.dart';
import 'data/Repositories/MedicalRecordRepository.dart';
import './domain/Models/patient.dart';
import './domain/Models/appointment.dart';
import './domain/Models/MedicalRecord.dart';
void main() {
  PatientRepository patientrepository = PatientRepository(filePath: './data/Storage/Patient.json');
  AppointmentRepository appointmentrepository = AppointmentRepository(filePath: './data/Storage/Appointment.json');
  MedicalRecordRepository medicalrecordrepository = MedicalRecordRepository(filePath: './data/Storage/MedicalRecord.json');

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