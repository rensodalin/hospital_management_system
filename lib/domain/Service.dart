import './Models/patient.dart';
import './Models/appointment.dart';
import './Models/MedicalRecord.dart';

class Service {
  final List<Patient> patients;
  final List<Appointment> appointments;
  final List<MedicalRecord> medicalRecords;

  Service({required this.patients, required this.appointments, required this.medicalRecords});
  bool isAppointmentExists(String id) {
    return appointments.any((a) => a.id == id);
  }

  bool isPatientExists(String id) {
    return patients.any((p) => p.id == id);
  }

  bool isMedicalRecordExists(String id) {
    return medicalRecords.any((m) => m.id == id);
  }

// MedicalRecord
  void createMedicalRecord(String appointmentId, MedicalRecord newMedicalRecord) {
    if(!isAppointmentExists(appointmentId)) throw Exception("Appointment with this id: ${appointmentId} does not exist");
    if(isMedicalRecordExists(newMedicalRecord.id)) throw Exception("MedicalRecord with this id: ${newMedicalRecord.id} already exist");
    medicalRecords.add(newMedicalRecord);

    Appointment a = appointments.firstWhere((a) => a.id == appointmentId);
    a.medicalRecordId = newMedicalRecord.id;
    a.status = 'Completed';
  }

  void updateMedicalRecord(String id, String diagnosis, String prescription, String notes) {
    if(!isMedicalRecordExists(id)) throw Exception("MedicalRecord with this id: ${id} does not exist");
    MedicalRecord m = medicalRecords.firstWhere((m) => m.id == id);
    m.diagnosis = diagnosis;
    m.prescriptions = prescription;
    m.notes = notes;
  }

  void removeMedicalRecord(String id){
    if(!isMedicalRecordExists(id)) throw Exception("MedicalRecord with this id: ${id} does not exist");
    MedicalRecord m = medicalRecords.firstWhere((m) => m.id == id);
    appointments.firstWhere((a) => a.medicalRecordId == id).medicalRecordId = '';
    medicalRecords.remove(m);
  }

  MedicalRecord searchMedicalRecord(String id) {
    if(!isMedicalRecordExists(id)) throw Exception("MedicalRecord with this id: ${id} does not exist");
    return medicalRecords.firstWhere((m) => m.id == id);
  }

  List<MedicalRecord> getMedicalRecordsByPatient(String patientId) {
    if(!isPatientExists(patientId)) throw Exception("Patient with this id: ${patientId} does not exist");
    List<Appointment> as = getAppointmentsByPatient(patientId);
    List<String> mId = [];
    for(Appointment a in as){
      mId.add(a.medicalRecordId);
    }
    List<MedicalRecord> result = [];
    for(String id in mId){
      result.add(searchMedicalRecord(id));
    }
    return result;
  }


// Appointment
  void createAppointment(String patientId, Appointment newAppointment) {
    if(!isPatientExists(patientId)) throw Exception("Patient with this id: ${patientId} does not exist");
    if(isAppointmentExists(newAppointment.id)) throw Exception("Appointment with this id: ${newAppointment.id} already exist");
    appointments.add(newAppointment);
    patients.firstWhere((p) => p.id == patientId).appointments.add(newAppointment.id);
  }

  void updateAppointmentSchedule(String id, DateTime newDate) {
    if(!isAppointmentExists(id)) throw Exception("Appointment with this id: ${id} does not exist");
    appointments.firstWhere((a) => a.id == id).schedule = newDate;
  }

  void removeAppointment(String id){
    if(!isAppointmentExists(id)) throw Exception("Appointment with this id: ${id} does not exist");
    Appointment a = appointments.firstWhere((a) => a.id == id);
    MedicalRecord m = medicalRecords.firstWhere((m) => m.id == a.medicalRecordId);
    medicalRecords.remove(m);
    appointments.remove(a);
  }

  List<Appointment> getAppointmentsByPatient(String patientId) {
    if(!isPatientExists(patientId)) throw Exception("Patient with this id: ${patientId} does not exist");
    List<String> appointmentIds = patients.firstWhere((p) => p.id == patientId).appointments;
    List<Appointment> result = [];
    for(Appointment a in appointments){
      for(String id in appointmentIds){
        if(a.id == id){
          result.add(a);
        }
      }
    }
  return result;
  }

  List<Appointment> getAppointmentByDate(String date) {
    return appointments.where((a) => a.schedule.toIso8601String().contains(date)).toList();
  }

  Appointment searchAppointment(String id) {
    if(!isAppointmentExists(id)) throw Exception("Appointment with this id: ${id} does not exist");
    return appointments.firstWhere((a) => a.id == id);
  }


// Patient
  Patient searchPatient(String id) {
    if(!isPatientExists(id)) throw Exception("Patient with this id: ${id} does not exist");
    return patients.firstWhere((p) => p.id == id);
  }

  void addPatient(Patient newPatient) {
    if(isPatientExists(newPatient.id)) throw Exception("Patient with this id: ${newPatient.id} already exist");
    patients.add(newPatient);
  }

  void removePatient(String id) {
    if(!isPatientExists(id)) throw Exception("Patient with this id: ${id} does not exist");
    Patient p = patients.firstWhere((p) => p.id == id);
    List<String> appointmentsIds = p.appointments;
    for(String id in appointmentsIds){
      removeAppointment(id);
    }

    patients.remove(p);
  }

  void updatePatient(String id, String name, int age, String gender, String phone, String address, String bloodGroup) {
    if(!isPatientExists(id)) throw Exception("Patient with this id: ${id} does not exist");
    Patient p = patients.firstWhere((p) => p.id == id);
    p.name = name;
    p.age = age;
    p.gender = gender;
    p.phone = phone;
    p.address = address;
    p.bloodGroup = bloodGroup;
  }
}
