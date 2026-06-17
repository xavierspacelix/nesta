import 'package:supabase_flutter/supabase_flutter.dart';

class PushNotificationSender {
  final SupabaseClient _client;

  PushNotificationSender(this._client);

  Future<void> sendToHouse({
    required String houseId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    await _client.functions.invoke('send-notification', body: {
      'topic': 'house_$houseId',
      'title': title,
      'body': body,
      'data': data ?? {},
    });
  }
}
