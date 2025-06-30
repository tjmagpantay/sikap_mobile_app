class UserSession {
  static UserSession? _instance;
  static UserSession get instance {
    _instance ??= UserSession._internal();
    return _instance!;
  }
  
  UserSession._internal();
  
  Map<String, dynamic>? _userData;
  
  // Set user data after successful login
  void setUserData(Map<String, dynamic> userData) {
    _userData = userData;
  }
  
  // Get current user data
  Map<String, dynamic>? get userData => _userData;
  
  // Check if user is logged in
  bool get isLoggedIn => _userData != null;
  
  // Get user ID
  int? get userId => _userData?['user_id'];
  
  // Get user role
  String? get userRole => _userData?['role'];
  
  // Get user name
  String get userName {
    if (_userData?['profile'] != null) {
      final profile = _userData!['profile'];
      final firstName = profile['first_name'] ?? '';
      final lastName = profile['last_name'] ?? '';
      return '$firstName $lastName'.trim();
    }
    return 'User';
  }
  
  // Get jobseeker ID (for jobseekers only)
  int? get jobseekerId {
    if (_userData?['role'] == 'jobseeker' && _userData?['profile'] != null) {
      return _userData!['profile']['jobseeker_id'];
    }
    return null;
  }
  
  // // Get employer ID (for employers only)
  // int? get employerId {
  //   if (_userData?['role'] == 'employer' && _userData?['profile'] != null) {
  //     return _userData!['profile']['employer_id'];
  //   }
  //   return null;
  // }
  
  // Clear user data (logout)
  void clearUserData() {
    _userData = null;
  }
}
