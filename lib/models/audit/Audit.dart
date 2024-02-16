class Audit {
  final String id;
  final String email;
  final String role;
  final ActionType action;
  final ComponentType component;
  final dynamic payload;
  final String details;
  final DateTime timestamp;

  Audit({
    required this.id,
    required this.email,
    required this.role,
    required this.action,
    required this.component,
    required this.payload,
    required this.details,
    required this.timestamp,
  });

  factory Audit.fromJson(Map<String, dynamic> json) {
    return Audit(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      action: json['action'],
      component: json['component'],
      payload: json['payload'],
      details: json['details'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.toString().split('.').last,
      'action': action.toString().split('.').last,
      'component': component.toString().split('.').last,
      'payload': payload,
      'details': details,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

enum ComponentType {
  TRANSACTION,
  CONTENT_MANAGEMENT,
  INVENTORY,
}

enum ActionType {
  CREATE,
  DELETE,
  UPDATE,
  MODIFY,
}
