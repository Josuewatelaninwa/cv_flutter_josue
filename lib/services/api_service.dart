import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();
  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );
  static const int _maxImageBytes = 2 * 1024 * 1024;
  static const Set<String> _imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  };

  Uri get _baseUri {
    final defaultHost =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';
    final configuredUrl = _configuredBaseUrl.isEmpty
        ? 'http://$defaultHost/api-test/public'
        : _configuredBaseUrl;
    final value = configuredUrl.replaceFirst(RegExp(r'/+$'), '');
    return Uri.parse('$value/');
  }

  Uri _uri(String path) => _baseUri.resolve(path);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = await _postJson('accounts/login', {
      'email': email,
      'password': password,
    });
    return _asMap(data, 'Les informations du compte sont absentes.');
  }

  Future<void> register(String email, String password) async {
    await _postJson('accounts/register', {
      'email': email,
      'password': password,
    });
  }

  Future<List<FamilyMember>> getFamilyMembers() async {
    final data = await _request('GET', 'famille-membres');
    if (data is! List) {
      throw const ApiException('La liste des membres reçue est invalide.');
    }

    return data
        .map((item) => FamilyMember.fromJson(_asMap(item, 'Membre invalide.')))
        .toList();
  }

  Future<void> createFamilyMember(
    Map<String, String> fields, {
    XFile? image,
  }) async {
    if (image == null) {
      await _postJson('famille-membres', fields);
      return;
    }
    await _sendMemberForm('famille-membres', fields, image);
  }

  Future<void> updateFamilyMember(
    int id,
    Map<String, String> fields, {
    XFile? image,
  }) async {
    if (image == null) {
      await _request('PUT', 'famille-membres/$id', body: fields);
      return;
    }
    await _sendMemberForm('famille-membres/$id', fields, image);
  }

  Future<void> deleteFamilyMember(int id) async {
    await _request('DELETE', 'famille-membres/$id');
  }

  Future<dynamic> _postJson(String path, Map<String, String> body) {
    return _request('POST', path, body: body);
  }

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, String>? body,
  }) async {
    try {
      final request = http.Request(method, _uri(path));
      if (body != null) {
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(body);
      }
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 20),
      );
      final response = await http.Response.fromStream(streamedResponse)
          .timeout(const Duration(seconds: 20));
      return _decodeResponse(response);
    } on http.ClientException {
      throw const ApiException(
        'Impossible de joindre l’API. Vérifiez son adresse et son démarrage.',
      );
    } on TimeoutException {
      throw ApiException(
        'Délai dépassé vers $_baseUri. Vérifiez que le serveur API est démarré '
        'et que son adresse est correcte.',
      );
    }
  }

  Future<dynamic> _sendMemberForm(
    String path,
    Map<String, String> fields,
    XFile image,
  ) async {
    _validateImageName(image.name);
    final size = await image.length();
    if (size > _maxImageBytes) {
      throw const ApiException('La photo doit faire 2 Mo maximum.');
    }

    final request = http.MultipartRequest('POST', _uri(path))
      ..fields.addAll(fields)
      ..files.add(
        http.MultipartFile.fromBytes(
          'image',
          await image.readAsBytes(),
          filename: image.name,
        ),
      );

    try {
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse)
          .timeout(const Duration(seconds: 30));
      _decodeResponse(response);
    } on http.ClientException {
      throw const ApiException(
        'Impossible d’envoyer la photo. Vérifiez la connexion à l’API.',
      );
    } on TimeoutException {
      throw const ApiException('L’envoi de la photo a expiré. Réessayez.');
    }
  }

  void _validateImageName(String name) {
    final extension = name.split('.').last.toLowerCase();
    if (!_imageExtensions.contains(extension)) {
      throw const ApiException('Format accepté : JPG, PNG, GIF ou WEBP.');
    }
  }

  dynamic _decodeResponse(http.Response response) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const ApiException('La réponse reçue du serveur est invalide.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('La réponse reçue du serveur est invalide.');
    }
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        decoded['success'] != true) {
      final message = decoded['message'];
      throw ApiException(
        message is String && message.isNotEmpty
            ? message
            : 'Erreur du serveur (${response.statusCode}).',
      );
    }
    return decoded['data'];
  }

  Map<String, dynamic> _asMap(dynamic value, String error) {
    if (value is Map<String, dynamic>) return value;
    throw ApiException(error);
  }

  String? resolveImageUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    final imageUri = Uri.tryParse(value);
    if (imageUri == null || !imageUri.hasAuthority) return value;
    if (imageUri.host != 'localhost' && imageUri.host != '127.0.0.1') {
      return value;
    }
    return imageUri
        .replace(
          scheme: _baseUri.scheme,
          host: _baseUri.host,
          port: _baseUri.hasPort ? _baseUri.port : null,
        )
        .toString();
  }
}

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    required this.imageUrl,
  });

  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  String get fullName => '$prenom $postnom $nom'.trim();

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final parsedId = id is int ? id : int.tryParse(id?.toString() ?? '');
    if (parsedId == null) {
      throw const ApiException('Identifiant de membre invalide.');
    }

    String requiredString(String key) {
      final value = json[key];
      if (value is! String || value.isEmpty) {
        throw ApiException('Champ $key manquant pour un membre.');
      }
      return value;
    }

    return FamilyMember(
      id: parsedId,
      nom: requiredString('nom'),
      postnom: requiredString('postnom'),
      prenom: requiredString('prenom'),
      lieuNaissance: requiredString('lieu_naissance'),
      dateNaissance: requiredString('date_naissance'),
      parente: requiredString('parente'),
      imageUrl: ApiService.instance.resolveImageUrl(
        json['image_url'] is String ? json['image_url'] as String : null,
      ),
    );
  }
}
