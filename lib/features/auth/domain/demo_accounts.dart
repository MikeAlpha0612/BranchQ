abstract final class DemoAccounts {
  static const staffEmail = 'staff@branchq.app';
  static const staffPassword = 'branchq-staff';
  static const customerEmail = 'customer@branchq.app';
  static const customerPassword = 'branchq-customer';
  static const staffBranchId = 'central';

  static String branchName(String? branchId) {
    return switch (branchId) {
      'central' => 'Central Branch',
      'north' => 'North Branch',
      'riverside' => 'Riverside Branch',
      _ => 'Branch',
    };
  }
}
