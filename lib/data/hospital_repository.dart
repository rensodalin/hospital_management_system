import 'dart:io';
import 'dart:convert';

import '../domain/doctor.dart';
import '../domain/patient.dart';
import '../domain/appointment.dart';
import '../domain/enums.dart';

class HospitalRepository {
  final List<Doctor> _doctors = [];
  final List<Patient> _patients = [];
  final List<Appointment> _appointments = [];

  // data folder and file names
  final Directory _dataDir = Directory('data');
  final String _doctorsFile = 'data/doctors.json';
  final String _patientsFile = 'data/patients.json';
  final String _appointmentsFile = 'data/appointments.json';

  HospitalRepository() {
    // ensure data directory exists and load any saved data
    if (!_dataDir.existsSync()) {
      _dataDir.createSync(recursive: true);
    }
    try {
      loadAll();
    } catch (e) {
      // ignore load errors for demo
    }
  }

  // --- Doctor Operations ---
  void addDoctor(Doctor doctor) {
    if (_doctors.any((d) => d.id == doctor.id)) {
      throw Exception('Doctor with ID ${doctor.id} already exists');
    }
    _doctors.add(doctor);
    saveDoctors();
  }

  void updateDoctor(Doctor doctor) {
    final index = _doctors.indexWhere((d) => d.id == doctor.id);
    if (index == -1) {
      throw Exception('Doctor with ID ${doctor.id} not found');
    }
    _doctors[index] = doctor;
    saveDoctors();
  }

  void removeDoctor(String id) {
    if (_appointments.any(
        (a) => a.doctorId == id && a.status != AppointmentStatus.completed)) {
      throw Exception('Cannot remove doctor with pending appointments');
    }
    final doctorExists = _doctors.any((d) => d.id == id);
    if (!doctorExists) {
      throw Exception('Doctor with ID $id not found');
    }
    _doctors.removeWhere((d) => d.id == id);
    saveDoctors();
  }

  Doctor? getDoctorById(String id) {
    try {
      return _doctors.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Doctor> getAllDoctors() => List.unmodifiable(_doctors);

  List<Doctor> getDoctorsBySpecialization(DoctorSpecialization spec) =>
      List.unmodifiable(
          _doctors.where((d) => d.specialization == spec).toList());

  // --- Patient Operations ---
  void addPatient(Patient patient) {
    if (_patients.any((p) => p.id == patient.id)) {
      throw Exception('Patient with ID ${patient.id} already exists');
    }
    _patients.add(patient);
    savePatients();
  }

  void updatePatient(Patient patient) {
    final index = _patients.indexWhere((p) => p.id == patient.id);
    if (index == -1) {
      throw Exception('Patient with ID ${patient.id} not found');
    }
    _patients[index] = patient;
    savePatients();
  }

  void removePatient(String id) {
    if (_appointments.any(
        (a) => a.patientId == id && a.status != AppointmentStatus.completed)) {
      throw Exception('Cannot remove patient with pending appointments');
    }
    final patientExists = _patients.any((p) => p.id == id);
    if (!patientExists) {
      throw Exception('Patient with ID $id not found');
    }
    _patients.removeWhere((p) => p.id == id);
    savePatients();
  }

  Patient? getPatientById(String id) {
    try {
      return _patients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Patient> getAllPatients() => List.unmodifiable(_patients);

  // --- Appointment Operations ---
  void addAppointment(Appointment appointment) {
    // Validate IDs
    if (_appointments.any((a) => a.id == appointment.id)) {
      throw Exception('Appointment with ID ${appointment.id} already exists');
    }
    final doctor = getDoctorById(appointment.doctorId);
    if (doctor == null) {
      throw Exception('Doctor not found');
    }
    if (getPatientById(appointment.patientId) == null) {
      throw Exception('Patient not found');
    }

    // Validate appointment time
    if (appointment.dateTime.isBefore(DateTime.now())) {
      throw Exception('Cannot schedule appointments in the past');
    }

    // Check doctor availability (normalize to 3-letter lowercase codes)
    final appointmentDay = appointment.dateTime.weekday;
    final req = _weekdayToCode(appointmentDay);
    final normalizedDays = doctor.availableDays
        .map((d) => d.toString().substring(0, 3).toLowerCase())
        .toList();
    if (!normalizedDays.contains(req)) {
      throw Exception(
          'Doctor is not available on ${_weekdayToString(appointmentDay)}');
    }

    // Check for conflicting appointments
    if (_hasConflictingAppointment(appointment)) {
      throw Exception('Doctor has a conflicting appointment at this time');
    }

    _appointments.add(appointment);
    saveAppointments();
  }

  bool _hasConflictingAppointment(Appointment newAppointment) {
    return _appointments.any((existing) {
      if (existing.doctorId != newAppointment.doctorId) return false;
      if (existing.status == AppointmentStatus.cancelled) return false;

      final existingStart = existing.dateTime;
      final existingEnd = existingStart.add(const Duration(minutes: 30));
      final newStart = newAppointment.dateTime;
      final newEnd = newStart.add(const Duration(minutes: 30));

      return (newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart));
    });
  }

  String _weekdayToString(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  String _weekdayToCode(int weekday) {
    // returns 'mon', 'tue', etc.
    const codes = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    return codes[weekday - 1];
  }

  Appointment? getAppointmentById(String id) {
    try {
      return _appointments.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Appointment> getAllAppointments() => List.unmodifiable(_appointments);

  List<Appointment> getAppointmentsByDoctor(String doctorId) =>
      List.unmodifiable(
          _appointments.where((a) => a.doctorId == doctorId).toList());

  List<Appointment> getAppointmentsByPatient(String patientId) =>
      List.unmodifiable(
          _appointments.where((a) => a.patientId == patientId).toList());

  List<Appointment> getAppointmentsByDate(DateTime date) =>
      List.unmodifiable(_appointments
          .where((a) =>
              a.dateTime.year == date.year &&
              a.dateTime.month == date.month &&
              a.dateTime.day == date.day)
          .toList());

  List<Appointment> getAppointmentsByStatus(AppointmentStatus status) =>
      List.unmodifiable(
          _appointments.where((a) => a.status == status).toList());

  void updateAppointmentStatus(String id, AppointmentStatus newStatus) {
    final appointment = getAppointmentById(id);
    if (appointment == null) throw Exception('Appointment not found');

    // Validate status transitions
    switch (appointment.status) {
      case AppointmentStatus.cancelled:
        throw Exception('Cannot update status of cancelled appointment');
      case AppointmentStatus.completed:
        throw Exception('Cannot update status of completed appointment');
      case AppointmentStatus.scheduled:
        if (newStatus == AppointmentStatus.completed) {
          throw Exception('Appointment must be in progress before completing');
        }
        break;
      case AppointmentStatus.inProgress:
        if (newStatus == AppointmentStatus.scheduled) {
          throw Exception('Cannot revert in-progress appointment to scheduled');
        }
        break;
    }

    appointment.status = newStatus;
    saveAppointments();
  }

  void completeAppointment(String id, String diagnosis, String prescription) {
    final appointment = getAppointmentById(id);
    if (appointment == null) throw Exception('Appointment not found');
    if (appointment.status != AppointmentStatus.inProgress) {
      throw Exception('Only in-progress appointments can be completed');
    }

    appointment.status = AppointmentStatus.completed;
    appointment.diagnosis = diagnosis;
    appointment.prescription = prescription;
    saveAppointments();
  }

  // --- Persistence: save/load ---
  void saveDoctors() {
    final list = _doctors.map((d) => d.toJson()).toList();
    File(_doctorsFile).writeAsStringSync(jsonEncode(list));
  }

  void savePatients() {
    final list = _patients.map((p) => p.toJson()).toList();
    File(_patientsFile).writeAsStringSync(jsonEncode(list));
  }

  void saveAppointments() {
    final list = _appointments.map((a) => a.toJson()).toList();
    File(_appointmentsFile).writeAsStringSync(jsonEncode(list));
  }

  void saveAll() {
    saveDoctors();
    savePatients();
    saveAppointments();
  }

  void loadAll() {
    // doctors
    final dfile = File(_doctorsFile);
    if (dfile.existsSync()) {
      final content = dfile.readAsStringSync();
      final list = jsonDecode(content) as List<dynamic>;
      _doctors.clear();
      for (final item in list) {
        _doctors.add(Doctor.fromJson(item as Map<String, dynamic>));
      }
    }

    // patients
    final pfile = File(_patientsFile);
    if (pfile.existsSync()) {
      final content = pfile.readAsStringSync();
      final list = jsonDecode(content) as List<dynamic>;
      _patients.clear();
      for (final item in list) {
        _patients.add(Patient.fromJson(item as Map<String, dynamic>));
      }
    }

    // appointments
    final afile = File(_appointmentsFile);
    if (afile.existsSync()) {
      final content = afile.readAsStringSync();
      final list = jsonDecode(content) as List<dynamic>;
      _appointments.clear();
      for (final item in list) {
        _appointments.add(Appointment.fromJson(item as Map<String, dynamic>));
      }
    }
  }

  // --- Statistics ---
  Map<String, dynamic> getStatistics() => {
        'totalDoctors': _doctors.length,
        'totalPatients': _patients.length,
        'totalAppointments': _appointments.length,
        'completedAppointments': _appointments
            .where((a) => a.status == AppointmentStatus.completed)
            .length,
        'cancelledAppointments': _appointments
            .where((a) => a.status == AppointmentStatus.cancelled)
            .length,
        'upcomingAppointments': _appointments
            .where((a) =>
                a.status == AppointmentStatus.scheduled &&
                a.dateTime.isAfter(DateTime.now()))
            .length,
      };
}
