enum TokenStatus { waiting, called, serving, served, skipped, cancelled }

class Branch {
  const Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.isOpen,
  });

  final String id;
  final String name;
  final String address;
  final bool isOpen;
}

class Service {
  const Service({
    required this.id,
    required this.branchId,
    required this.name,
    required this.averageServiceMinutes,
  });

  final String id;
  final String branchId;
  final String name;
  final int averageServiceMinutes;
}

class Counter {
  const Counter({
    required this.id,
    required this.branchId,
    required this.name,
    required this.activeServiceId,
    required this.isOpen,
  });

  final String id;
  final String branchId;
  final String name;
  final String activeServiceId;
  final bool isOpen;
}

class Token {
  const Token({
    required this.id,
    required this.displayNumber,
    required this.branchId,
    required this.serviceId,
    required this.status,
    required this.createdAt,
    this.counterId,
  });

  final String id;
  final String displayNumber;
  final String branchId;
  final String serviceId;
  final TokenStatus status;
  final DateTime createdAt;
  final String? counterId;

  Token copyWith({TokenStatus? status, String? counterId}) {
    return Token(
      id: id,
      displayNumber: displayNumber,
      branchId: branchId,
      serviceId: serviceId,
      status: status ?? this.status,
      createdAt: createdAt,
      counterId: counterId ?? this.counterId,
    );
  }
}

class StaffSession {
  const StaffSession({
    required this.staffName,
    required this.branchId,
    this.counterId,
  });

  final String staffName;
  final String branchId;
  final String? counterId;
}
