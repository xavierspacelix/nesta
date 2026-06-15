enum NotificationType {
  dutyReminder,
  dueSoon,
  missedDuty,
  swapRequest,
  swapApproved,
  swapRejected,
  paymentReminder,
}

extension NotificationTypeX on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.dutyReminder:
        return 'Pengingat Piket';
      case NotificationType.dueSoon:
        return 'Piket Hampir Berakhir';
      case NotificationType.missedDuty:
        return 'Piket Terlewat';
      case NotificationType.swapRequest:
        return 'Permintaan Tukar Jadwal';
      case NotificationType.swapApproved:
        return 'Tukar Jadwal Disetujui';
      case NotificationType.swapRejected:
        return 'Tukar Jadwal Ditolak';
      case NotificationType.paymentReminder:
        return 'Pengingat Pembayaran';
    }
  }

  String get description {
    switch (this) {
      case NotificationType.dutyReminder:
        return 'Pukul 08:00 — pengingat tugas hari ini';
      case NotificationType.dueSoon:
        return 'Pukul 18:00 — tugas hampir berakhir';
      case NotificationType.missedDuty:
        return 'Pukul 22:00 — tugas terlewat';
      case NotificationType.swapRequest:
        return 'Saat ada permintaan tukar jadwal';
      case NotificationType.swapApproved:
        return 'Saat permintaan tukar disetujui';
      case NotificationType.swapRejected:
        return 'Saat permintaan tukar ditolak';
      case NotificationType.paymentReminder:
        return 'Sewa atau listrik jatuh tempo';
    }
  }
}
