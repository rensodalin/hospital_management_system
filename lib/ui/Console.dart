import '../domain/Service.dart';
import 'dart:io';
import '../domain/Patient.dart';
import '../domain/Appointment.dart';
import '../domain/MedicalRecord.dart';
class Console{
  Service service;

  Console({required this.service});
// MEdicalRecord
  void createMedicalRecord(){
    stdout.write("Enter appointment id: ");
    String appointmentId = stdin.readLineSync()!;
    if(!service.isAppointmentExists(appointmentId)) {
      print("Appointment with this id: ${appointmentId} does not exist");
      return;
    };
    stdout.write("Enter medical record id: ");
    String MedicalRecordId = stdin.readLineSync()!;
    if(service.isMedicalRecordExists(MedicalRecordId)) {
      print("MedicalRecord with this id: ${MedicalRecordId} already exist");
      return;
    }

    stdout.write("Enter date: ");
    DateTime date = DateTime.parse(stdin.readLineSync()!);
    stdout.write("Enter diagnosis: ");
    String diagnosis = stdin.readLineSync()!;
    stdout.write("Enter prescription: ");
    String prescription = stdin.readLineSync()!;
    stdout.write("Enter notes: ");
    String notes = stdin.readLineSync()!;
    service.createMedicalRecord(appointmentId, MedicalRecord(id: MedicalRecordId, date: date, diagnosis: diagnosis, prescriptions:prescription, notes:notes));
  }

  void updateMedicalRecord(){
    stdout.write("Enter medical record id: ");
    String id = stdin.readLineSync()!;
    if(!service.isMedicalRecordExists(id)) {
      print("MedicalRecord with this id: ${id} does not exist");
      return;
    }
    stdout.write("Enter diagnosis: ");
    String diagnosis = stdin.readLineSync()!;
    stdout.write("Enter prescription: ");
    String prescription = stdin.readLineSync()!;
    stdout.write("Enter notes: ");
    String notes = stdin.readLineSync()!;
    service.updateMedicalRecord(id, diagnosis, prescription, notes);
  }

  void removeMedicalRecord(){
    stdout.write("Enter medical record id: ");
    String id = stdin.readLineSync()!;
    if(!service.isMedicalRecordExists(id)) {
      print("MedicalRecord with this id: ${id} does not exist");
      return;
    }
    service.removeMedicalRecord(id);
  }

  void searchMedicalRecord(){
    stdout.write("Enter medical record id: ");
    String id = stdin.readLineSync()!;
    if(!service.isMedicalRecordExists(id)) {
      print("MedicalRecord with this id: ${id} does not exist");
      return;
    }
    MedicalRecord m = service.searchMedicalRecord(id);
    print("ID: ${m.id}");
    print("Date : ${m.date}");
    print("Diagnosis : ${m.diagnosis}");
    print("Prescription : ${m.prescriptions}");
    print("Notes : ${m.notes}");

  }

  void getMedicalRecordsByPatient(){
    stdout.write("Enter patient id: ");
    String id = stdin.readLineSync()!;
    if(!service.isPatientExists(id)) {
      print("Patient with this id: ${id} does not exist");
      return;
    }

    List<MedicalRecord> medicalRecords = service.getMedicalRecordsByPatient(id);
    for(MedicalRecord m in medicalRecords){
      print("ID: ${m.id}");
      print("Date : ${m.date}");
      print("Diagnosis : ${m.diagnosis}");
      print("Prescription : ${m.prescriptions}");
      print("Notes : ${m.notes}");
      print("-"* 100);
    }
  }
// Appointment
  void createAppointment(){
    stdout.write('Enter patient id: ');
    String id = stdin.readLineSync()!;
    if(!service.isPatientExists(id)) {
      print("Patient with this id: ${id} does not exist");
      return;
    };

    stdout.write("Enter appointment id: ");
    String appointmentId = stdin.readLineSync()!;
    if(service.isAppointmentExists(appointmentId)) {
      print("Appointment with this id: ${appointmentId} already exist");
      return;
    };
    stdout.write("Enter schedule dateTime: "); 
    DateTime scheduleDate = DateTime.parse(stdin.readLineSync()!);;
    stdout.write("Enter reason: ");
    String reason = stdin.readLineSync()!;

    service.createAppointment(id, Appointment(id: appointmentId, schedule: scheduleDate, reason: reason));
  }

  void updateAppointmentSchedule(){
    stdout.write('Enter appointment id: ');
    String id = stdin.readLineSync()!;
    if(!service.isAppointmentExists(id)){
       print("Appointment with this id: ${id} does not exist");
       return;
    };

    stdout.write("Enter schedule dateTime: "); 
    DateTime newDate = DateTime.parse(stdin.readLineSync()!);
    service.updateAppointmentSchedule(id, newDate);
  }

  void removeAppointment(){
    stdout.write('Enter appointment id: ');
    String id = stdin.readLineSync()!;
    if(!service.isAppointmentExists(id)) {
      print("Appointment with this id: ${id} does not exist");
      return;
    };
    service.removeAppointment(id);
  }

  void getAppointmentsByPatient(){
    stdout.write('Enter patient id: ');
    String id = stdin.readLineSync()!;
    if(!service.isPatientExists(id)) {
      print("Patient with this id: ${id} does not exist");
      return;
    }

    print("Id".padRight(8) + "Schedule".padRight(25) + "Reason".padRight(25) + "Status".padRight(12));
    service.getAppointmentsByPatient(id).forEach((a) => 
      print(
        "${a.id.padRight(8)}"
        "${a.schedule.toString().padRight(25)}"
        "${a.reason.padRight(25)}"
        "${a.status.toString().padRight(12)}"
      ));
    }

  void getAppointmentByDate(){
    stdout.write('Enter date (yyyy-MM-dd): ');
    String date = stdin.readLineSync()!;

    print("Id".padRight(8) + "Schedule".padRight(25) + "Reason".padRight(25) + "Status".padRight(12));
    service.getAppointmentByDate(date).forEach((a) => 
      print(
        "${a.id.padRight(8)}"
        "${a.schedule.toString().padRight(25)}"
        "${a.reason.padRight(25)}"
        "${a.status.toString().padRight(12)}"
      ));
  }

  void searchAppointment(){
    stdout.write('Enter appointment id: ');
    String id = stdin.readLineSync()!;
    if(!service.isAppointmentExists(id)) {
      print("Appointment with this id: ${id} does not exist");
      return;
    }
    Appointment a = service.searchAppointment(id);
    print("Id".padRight(8) + "Schedule".padRight(25) + "Reason".padRight(25) + "Status".padRight(12));
    print(
        "${a.id.padRight(8)}"
        "${a.schedule.toString().padRight(25)}"
        "${a.reason.padRight(25)}"
        "${a.status.toString().padRight(12)}"
  );
  }
// Patient
  void printPatientInfo(Patient patient) {
    print(
        "${patient.id.padRight(8)}"
        "${patient.name.padRight(18)}"
        "${patient.age.toString().padRight(6)}"
        "${patient.gender.padRight(10)}"
        "${patient.phone.padRight(15)}"
        "${patient.address.padRight(20)}"
        "${patient.bloodGroup.padRight(14)}"
        "${patient.status.toString().padRight(12)}"
        "${patient.registrationDate.toString().padRight(25)}"
    );
  } //Ai generate

  void viewAllPatient() {
    print(
        "ID".padRight(8) +
        "Name".padRight(18) +
        "Age".padRight(6) +
        "Gender".padRight(10) +
        "Phone".padRight(15) +
        "Address".padRight(20) +
        "Blood Group".padRight(14) +
        "Status".padRight(12) +
        "Registration Date".padRight(25)
    );
    print("-" * 128);
    service.patients.forEach((patient) => printPatientInfo(patient));
  }// AI generate


  void searchPatient(){
    stdout.write('Enter patient id: ');
    String id = stdin.readLineSync()!;
    if(!service.isPatientExists(id)) {
      print("Patient with this id: ${id} does not exist");
      return;
    }
    print(
      "ID".padRight(8) +
      "Name".padRight(18) +
      "Age".padRight(6) +
      "Gender".padRight(10) +
      "Phone".padRight(15) +
      "Address".padRight(20) +
      "Blood Group".padRight(14) +
      "Status".padRight(12) +
      "Registration Date".padRight(25)
    );
    print("-" * 128);
    printPatientInfo(service.searchPatient(id));

  }

  void addPatients(){
    stdout.write('Enter patient ID: ');
    String id = stdin.readLineSync()!;
    if(service.isPatientExists(id)) {
      print("Patient with this id: ${id} already exists");
      return;
    }
    stdout.write('Enter patient name: ');
    String name = stdin.readLineSync()!;
    stdout.write('Enter patient age: ');
    int age = int.parse(stdin.readLineSync()!);
    stdout.write('Enter patient gender: ');
    String gender = stdin.readLineSync()!;
    stdout.write('Enter patient phone: ');
    String phone = stdin.readLineSync()!;
    stdout.write('Enter patient address: ');
    String address = stdin.readLineSync()!;
    stdout.write('Enter patient blood group: ');
    String bloodGroup = stdin.readLineSync()!;
    stdout.write('Enter patient status: ');
    String status = stdin.readLineSync()!;
    Patient patient = Patient(id: id, name: name, age: age, gender: gender, phone: phone, address: address, bloodGroup: bloodGroup, status: status, registrationDate: DateTime.now());
    service.addPatient(patient);
    }

  void removePatient(){
    stdout.write('Enter patient ID: ');
    String id = stdin.readLineSync()!;
    if(!service.isPatientExists(id)) {
      print("Patient with this id: ${id} does not exist");
      return;
    }
    service.removePatient(id);
  }

  void updatePatient(){
    stdout.write('Enter patient ID: ');
    String id = stdin.readLineSync()!;
    if(!service.isPatientExists(id)) {
      print("Patient with this id: ${id} does not exist");
      return;
    }
    stdout.write('Enter patient name: ');
    String name = stdin.readLineSync()!;
    stdout.write('Enter patient age: ');
    int age = int.parse(stdin.readLineSync()!);
    stdout.write('Enter patient gender: ');
    String gender = stdin.readLineSync()!;
    stdout.write('Enter patient phone: ');
    String phone = stdin.readLineSync()!;
    stdout.write('Enter patient address: ');
    String address = stdin.readLineSync()!;
    stdout.write('Enter patient blood group: ');
    String bloodGroup = stdin.readLineSync()!;
    stdout.write('Enter patient status: ');
    String status = stdin.readLineSync()!;
    service.updatePatient(id, name, age, gender, phone, address, bloodGroup, status);
  }

  void startSystem(){
    while(true){
      print("1. Manage Patient");
      print("2. Manage Appointment");
      print("3. Manage Medical Record");
      print("4. Exit");
      stdout.write('Enter your choice: ');
      int choice = int.parse(stdin.readLineSync()!);
      switch(choice){
        case 1: 
          while(true){
            print("1. View all Patients");
            print("2. Add Patient");
            print("3. Remove Patient");
            print("4. Update Patient");
            print("5. Search Patient");
            print("6. Back");
            stdout.write('Enter your choice: ');
            int choice = int.parse(stdin.readLineSync()!);
            switch(choice){
              case 1: viewAllPatient(); break;
              case 2: addPatients(); break;
              case 3: removePatient(); break;
              case 4: updatePatient(); break;
              case 5: searchPatient(); break;
              case 6: break;
            }
            if(choice == 6) break;
          }
        break;

        case 2:
          while(true){
            print("1. Create Appointment");
            print("2. Remove Appointment");
            print("3. Update Appointment schedule");
            print("4. Get appointment by Patient Id");
            print("5. Get appointment by Date");
            print("6. Search Appointment");
            print("7. Back");
            stdout.write('Enter your choice: ');
            int choice = int.parse(stdin.readLineSync()!);
            switch(choice){
              case 1: createAppointment(); break;
              case 2: removeAppointment(); break;
              case 3: updateAppointmentSchedule(); break;
              case 4: getAppointmentsByPatient(); break;
              case 5: getAppointmentByDate(); break;
              case 6: searchAppointment(); break;
              case 7: break;
            }
            if(choice == 7) break;
          }
        break;

        case 3: 
          while(true){
            print("1. Create Medical Record");
            print("2. Update Medical Record");
            print("3. Remove Medical Record");
            print("4. Search Medical Record");
            print("5. Get medical record by patient");
            print("6. Back");
            stdout.write('Enter your choice: ');
            int choice = int.parse(stdin.readLineSync()!);
            switch(choice){
              case 1: createMedicalRecord(); break;
              case 2: updateMedicalRecord(); break;
              case 3: removeMedicalRecord(); break;
              case 4: searchMedicalRecord(); break;
              case 5: getMedicalRecordsByPatient(); break;
              case 6: break;
            }
            if(choice == 6) break;
          }
        break;

        case 4: break;
      }
      if(choice == 4) break;
    }
  }
}