import 'dart:io';
import '../data/hospital_repository.dart';
import '../domain/enums.dart';
import '../domain/doctor.dart';
import '../domain/patient.dart';
import '../domain/appointment.dart';

class HospitalManagementUI {
  final HospitalRepository repository;
  HospitalManagementUI(this.repository);

  void run() {
    _printHeader('Welcome to Hospital Management System');
    bool running = true;

    while (running) {
      _printMenu([
        'Manage Doctors',
        'Manage Patients',
        'Manage Appointments',
        'View Statistics',
        'Exit'
      ]);

      var choice = getUserInput('Enter your choice: ');
      switch (choice) {
        case '1':
          manageDoctors();
          break;
        case '2':
          managePatients();
          break;
        case '3':
          manageAppointments();
          break;
        case '4':
          showStatistics();
          break;
        case '5':
          print('\nExiting...');
          running = false;
          break;
        default:
          print('\nInvalid choice. Please try again.');
      }
    }
  }

  void manageDoctors() {
    while (true) {
      _printHeader('Doctor Management');
      _printMenu([
        'Add Doctor',
        'List All Doctors',
        'Search Doctor',
        'Remove Doctor',
        'Back'
      ]);
      var choice = getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          addDoctor();
          break;
        case '2':
          listDoctors();
          break;
        case '3':
          searchDoctor();
          break;
        case '4':
          removeDoctor();
          break;
        case '5':
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }

  void addDoctor() {
    final id = getUserInput('Enter Doctor ID: ');
    if (repository.getDoctorById(id) != null) {
      print('Error: Doctor ID already exists.');
      return;
    }

    final name = getUserInput('Enter Name: ');
    final age = int.tryParse(getUserInput('Enter Age: ')) ?? 0;
    final gender = getUserInput('Enter Gender (M/F): ');
    final phone = getUserInput('Enter Phone: ');

    print('\nSpecializations:');
    final specs = DoctorSpecialization.values;
    for (var i = 0; i < specs.length; i++) {
      print("${i + 1}. ${specs[i].toString().split('.').last}");
    }
    final specChoice = int.tryParse(
            getUserInput("Choose specialization (1-${specs.length}): ")) ??
        1;
    final specialization = specs[specChoice - 1];

    final qualifications =
        getUserInput('Enter Qualifications (comma separated): ').split(',');
    final fee =
        double.tryParse(getUserInput('Enter Consultation Fee: ')) ?? 0.0;
    final days = getUserInput(
            'Enter Available Days (comma separated, e.g., Monday,Tuesday): ')
        .split(',');

    try {
      repository.addDoctor(Doctor(
        id: id,
        name: name,
        age: age,
        gender: gender,
        phone: phone,
        specialization: specialization,
        qualifications: qualifications,
        consultationFee: fee,
        availableDays: days,
      ));
      print('\nDoctor added successfully!');
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  void listDoctors() {
    final doctors = repository.getAllDoctors();
    if (doctors.isEmpty) {
      print('No doctors found.');
      return;
    }
    // nice table
    print('\nDoctors List:');
    final idW = 6;
    final nameW = 20;
    final specW = 15;
    final daysW = 18;
    final feeW = 10;

    print(_pad('ID', idW) +
        _pad('Name', nameW) +
        _pad('Specialty', specW) +
        _pad('Days', daysW) +
        _pad('Fee', feeW));
    print('-' * (idW + nameW + specW + daysW + feeW));
    for (var doctor in doctors) {
      final spec = doctor.specialization.toString().split('.').last;
      print(_pad(doctor.id, idW) +
          _pad(doctor.name, nameW) +
          _pad(spec, specW) +
          _pad(doctor.availableDays.join(', '), daysW) +
          _pad('\$${doctor.consultationFee.toStringAsFixed(2)}', feeW));
    }
  }

  void searchDoctor() {
    final id = getUserInput('Enter Doctor ID: ');
    final doctor = repository.getDoctorById(id);
    if (doctor == null) {
      print('Doctor not found.');
      return;
    }
    print('\nDoctor Details:');
    _printBlock(() {
      print('ID: ${doctor.id}');
      print('Name: ${doctor.name}');
      print('Age: ${doctor.age}');
      print('Gender: ${doctor.gender}');
      print('Phone: ${doctor.phone}');
      print(
          'Specialization: ${doctor.specialization.toString().split('.').last}');
      print('Qualifications: ${doctor.qualifications.join(', ')}');
      print('Consultation Fee: \$${doctor.consultationFee.toStringAsFixed(2)}');
      print('Available Days: ${doctor.availableDays.join(', ')}');
    });
  }

  void removeDoctor() {
    final id = getUserInput('Enter Doctor ID to remove: ');
    try {
      repository.removeDoctor(id);
      print('Doctor removed successfully!');
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  void managePatients() {
    while (true) {
      _printHeader('Patient Management');
      _printMenu([
        'Add Patient',
        'List All Patients',
        'Search Patient',
        'Remove Patient',
        'Back'
      ]);
      var choice = getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          addPatient();
          break;
        case '2':
          listPatients();
          break;
        case '3':
          searchPatient();
          break;
        case '4':
          removePatient();
          break;
        case '5':
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }

  void addPatient() {
    final id = getUserInput('Enter Patient ID: ');
    if (repository.getPatientById(id) != null) {
      print('Error: Patient ID already exists.');
      return;
    }

    final name = getUserInput('Enter Name: ');
    final age = int.tryParse(getUserInput('Enter Age: ')) ?? 0;
    final gender = getUserInput('Enter Gender (M/F): ');
    final phone = getUserInput('Enter Phone: ');
    final address = getUserInput('Enter Address: ');
    final bloodGroup = getUserInput('Enter Blood Group: ');
    final history =
        getUserInput('Enter Medical History (comma separated): ').split(',');

    try {
      repository.addPatient(Patient(
        id: id,
        name: name,
        age: age,
        gender: gender,
        phone: phone,
        address: address,
        bloodGroup: bloodGroup,
        medicalHistory: history,
      ));
      print('\nPatient added successfully!');
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  void listPatients() {
    final patients = repository.getAllPatients();
    if (patients.isEmpty) {
      print('No patients found.');
      return;
    }
    print('\nPatients List:');
    final idW = 6;
    final nameW = 20;
    final ageW = 6;
    final bgW = 8;
    print(_pad('ID', idW) +
        _pad('Name', nameW) +
        _pad('Age', ageW) +
        _pad('Blood', bgW));
    print('-' * (idW + nameW + ageW + bgW));
    for (var p in patients) {
      print(_pad(p.id, idW) +
          _pad(p.name, nameW) +
          _pad(p.age.toString(), ageW) +
          _pad(p.bloodGroup, bgW));
    }
  }

  void searchPatient() {
    final id = getUserInput('Enter Patient ID: ');
    final patient = repository.getPatientById(id);
    if (patient == null) {
      print('Patient not found.');
      return;
    }
    print('\nPatient Details:');
    _printBlock(() {
      print('ID: ${patient.id}');
      print('Name: ${patient.name}');
      print('Age: ${patient.age}');
      print('Gender: ${patient.gender}');
      print('Phone: ${patient.phone}');
      print('Address: ${patient.address}');
      print('Blood Group: ${patient.bloodGroup}');
      print(
          'Medical History: ${patient.medicalHistory.isEmpty ? 'None' : patient.medicalHistory.join(', ')}');
    });
  }

  void removePatient() {
    final id = getUserInput('Enter Patient ID to remove: ');
    try {
      repository.removePatient(id);
      print('Patient removed successfully!');
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  void manageAppointments() {
    while (true) {
      _printHeader('Appointment Management');
      _printMenu([
        'Schedule Appointment',
        'List All Appointments',
        'Update Appointment Status',
        'Cancel Appointment',
        'Back'
      ]);
      var choice = getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          scheduleAppointment();
          break;
        case '2':
          listAppointments();
          break;
        case '3':
          updateAppointmentStatus();
          break;
        case '4':
          cancelAppointment();
          break;
        case '5':
          return;
        default:
          print('Invalid choice. Please try again.');
      }
    }
  }

  void scheduleAppointment() {
    final id = getUserInput('Enter Appointment ID: ');
    final patientId = getUserInput('Enter Patient ID: ');
    final doctorId = getUserInput('Enter Doctor ID: ');

    final patient = repository.getPatientById(patientId);
    if (patient == null) {
      print('Error: Patient not found.');
      return;
    }

    final doctor = repository.getDoctorById(doctorId);
    if (doctor == null) {
      print('Error: Doctor not found.');
      return;
    }

    print(
        "\nAvailable days for Dr. ${doctor.name}: ${doctor.availableDays.join(', ')}");
    final dateStr = getUserInput('Enter appointment date (YYYY-MM-DD): ');
    final timeStr = getUserInput('Enter appointment time (HH:mm): ');

    try {
      final date = DateTime.parse("${dateStr}T${timeStr}:00");
      final reason = getUserInput('Enter reason for appointment: ');

      repository.addAppointment(Appointment(
        id: id,
        patientId: patientId,
        doctorId: doctorId,
        dateTime: date,
        reason: reason,
      ));
      print('\nAppointment scheduled successfully!');
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  void listAppointments() {
    final appointments = repository.getAllAppointments();
    if (appointments.isEmpty) {
      print('No appointments found.');
      return;
    }
    print('\nAppointments List:');
    final idW = 6;
    final patW = 18;
    final docW = 18;
    final dateW = 20;
    final statusW = 12;

    print(_pad('ID', idW) +
        _pad('Patient', patW) +
        _pad('Doctor', docW) +
        _pad('Date', dateW) +
        _pad('Status', statusW));
    print('-' * (idW + patW + docW + dateW + statusW));
    for (var appointment in appointments) {
      final doctor = repository.getDoctorById(appointment.doctorId);
      final patient = repository.getPatientById(appointment.patientId);
      final dateStr = appointment.dateTime.toString().split('.').first;
      final status = appointment.status.toString().split('.').last;
      print(_pad(appointment.id, idW) +
          _pad(patient?.name ?? 'Unknown', patW) +
          _pad(doctor?.name ?? 'Unknown', docW) +
          _pad(dateStr, dateW) +
          _pad(status, statusW));
    }
  }

  void updateAppointmentStatus() {
    final id = getUserInput('Enter Appointment ID: ');
    final appointment = repository.getAppointmentById(id);
    if (appointment == null) {
      print('Appointment not found.');
      return;
    }

    print("\nCurrent Status: ${appointment.status.toString().split('.').last}");
    print('Available statuses:');
    final statuses = AppointmentStatus.values;
    for (var i = 0; i < statuses.length; i++) {
      print("${i + 1}. ${statuses[i].toString().split('.').last}");
    }

    final statusChoice = int.tryParse(
            getUserInput("Choose new status (1-${statuses.length}): ")) ??
        1;
    final newStatus = statuses[statusChoice - 1];

    try {
      repository.updateAppointmentStatus(id, newStatus);

      if (newStatus == AppointmentStatus.completed) {
        final diagnosis = getUserInput('Enter diagnosis: ');
        final prescription = getUserInput('Enter prescription: ');
        repository.completeAppointment(id, diagnosis, prescription);
      }

      print('Appointment status updated successfully!');
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  void cancelAppointment() {
    final id = getUserInput('Enter Appointment ID to cancel: ');
    try {
      repository.updateAppointmentStatus(id, AppointmentStatus.cancelled);
      print('Appointment cancelled successfully!');
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  void showStatistics() {
    final stats = repository.getStatistics();
    _printHeader('Hospital Statistics');
    print('Total Doctors: ${stats['totalDoctors']}');
    print('Total Patients: ${stats['totalPatients']}');
    print('Total Appointments: ${stats['totalAppointments']}');
    print('Completed Appointments: ${stats['completedAppointments']}');
    print('Cancelled Appointments: ${stats['cancelledAppointments']}');
    print('Upcoming Appointments: ${stats['upcomingAppointments']}');
  }

  String getUserInput(String prompt) {
    stdout.write(prompt);
    return (stdin.readLineSync() ?? '').trim();
  }
}

// --- UI helpers ---
void _printHeader(String title) {
  final width = 72;
  final border = '=' * width;
  print('\n$border');
  final padded = title.padLeft((width + title.length) ~/ 2).padRight(width);
  print(padded);
  print(border);
}

void _printMenu(List<String> options) {
  for (var i = 0; i < options.length; i++) {
    print('${i + 1}. ${options[i]}');
  }
}

String _pad(String s, int width) {
  if (s.length > width - 1) return s.substring(0, width - 1) + ' ';
  return s.padRight(width);
}

void _printBlock(void Function() fn) {
  print('');
  fn();
  print('');
}
