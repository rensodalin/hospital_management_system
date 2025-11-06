import './Models/patient.dart';
import './Models/appointment.dart';
import './Models/MedicalRecord.dart';

class Service {
  List<Patient> patients;
  List<Appointment> appointments;
  List<MedicalRecord> medicalRecords;

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
    medicalRecords.add(newMedicalRecord);

    Appointment a = appointments.firstWhere((a) => a.id == appointmentId);
    a.medicalRecordId = newMedicalRecord.id;
    a.status = 'Completed';
  }

  void updateMedicalRecord(String id, String diagnosis, String prescription, String notes) {
    MedicalRecord m = medicalRecords.firstWhere((m) => m.id == id);
    m.diagnosis = diagnosis;
    m.prescriptions = prescription;
    m.notes = notes;
  }

  void removeMedicalRecord(String id){
    MedicalRecord m = medicalRecords.firstWhere((m) => m.id == id);
    appointments.firstWhere((a) => a.medicalRecordId == id).medicalRecordId = '';
    medicalRecords.remove(m);
  }

  MedicalRecord searchMedicalRecord(String id) => medicalRecords.firstWhere((m) => m.id == id);

  List<MedicalRecord> getMedicalRecordsByPatient(String patientId) {
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
    appointments.add(newAppointment);

    patients.firstWhere((p) => p.id == patientId).appointments.add(newAppointment.id);
  }

  void updateAppointmentSchedule(String id, DateTime newDate) {
    appointments.firstWhere((a) => a.id == id).schedule = newDate;
  }

  void removeAppointment(String id){
    Appointment a = appointments.firstWhere((a) => a.id == id);
    MedicalRecord m = medicalRecords.firstWhere((m) => m.id == a.medicalRecordId);
    medicalRecords.remove(m);
    appointments.remove(a);
  }

  List<Appointment> getAppointmentsByPatient(String patientId) {
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

  Appointment searchAppointment(String id) => appointments.firstWhere((a) => a.id == id);



// Patient
  Patient searchPatient(String id) => patients.firstWhere((p) => p.id == id);

  void addPatient(Patient newPatient) {
    patients.add(newPatient);
  }

  void removePatient(String id) {
    Patient p = patients.firstWhere((p) => p.id == id);
    List<String> appointmentsIds = p.appointments;
    for(String id in appointmentsIds){
      removeAppointment(id);
    }

    patients.remove(p);
  }

  void updatePatient(String id, String name, int age, String gender, String phone, String address, String bloodGroup) {
    Patient p = patients.firstWhere((p) => p.id == id);
    p.name = name;
    p.age = age;
    p.gender = gender;
    p.phone = phone;
    p.address = address;
    p.bloodGroup = bloodGroup;
  }
}
