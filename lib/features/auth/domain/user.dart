enum UserRole { customer, staff }

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.branchId,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? branchId;
}
