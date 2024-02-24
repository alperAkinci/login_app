import 'dart:io';
import 'package:expatrio_login_app/tax_data/model/tax_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TaxDataNotifier extends ChangeNotifier {
  late TaxData _taxData;

  TaxData get taxData => _taxData;

  final _storage = const FlutterSecureStorage();

  Future<TaxData> getTaxData() async {
    try {
      final token = await _storage.read(key: 'token');
      final userId = int.parse(await _storage.read(key: 'userId') ?? "");
      final url = Uri.parse(
          'https://dev-api.expatrio.com/v3/customers/$userId/tax-data');
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == HttpStatus.ok) {
        final responseData = TaxData.fromJson(response.body);
        _taxData = responseData;
        notifyListeners();
      } else {
        throw Exception('Failed to load tax data!');
      }
    } catch (error) {
      rethrow;
    }

    return _taxData;
  }
}