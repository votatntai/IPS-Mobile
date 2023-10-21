// ignore_for_file: constant_identifier_names

class APIPathConstant {
  APIPathConstant._internalConstructor();

  static final APIPathConstant _instance =
      APIPathConstant._internalConstructor();

  factory APIPathConstant() {
    return _instance;
  }

  static const API_SERVER_PATH = 'https://plantdetectionservice.azurewebsites.net';
  // static const API_SERVER_PATH = '146.190.90.118:5000';
  // static const API_SERVER_PATH = '10.0.2.2:5000';
}
