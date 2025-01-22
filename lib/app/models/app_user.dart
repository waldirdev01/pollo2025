enum UserType {
  newUser,
  coordinator,
  monitor,
  admin,
  schoolMember,
  tcb,
}

extension UserTypeExtension on UserType {
  String get string {
    switch (this) {
      case UserType.newUser:
        return 'newUser';
      case UserType.coordinator:
        return 'coordinator';
      case UserType.monitor:
        return 'monitor';
      case UserType.admin:
        return 'admin';
      case UserType.schoolMember:
        return 'schoolMember';
      case UserType.tcb:
        return 'tcb';
    }
  }

  static UserType fromString(String str) {
    switch (str) {
      case 'newUser':
        return UserType.newUser;
      case 'coordinator':
        return UserType.coordinator;
      case 'monitor':
        return UserType.monitor;
      case 'admin':
        return UserType.admin;
      case 'schoolMember':
        return UserType.schoolMember;
      case 'tcb':
        return UserType.tcb;
      default:
        throw ArgumentError('Invalid user type: $str');
    }
  }
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserType type;
  final String phone;
  final String cpf;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.phone,
    required this.cpf,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        type: UserTypeExtension.fromString(json['type']),
        phone: json['phone'],
        cpf: json['cpf']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'type': type.string,
      'phone': phone,
      'cpf': cpf,
    };
  }
}
