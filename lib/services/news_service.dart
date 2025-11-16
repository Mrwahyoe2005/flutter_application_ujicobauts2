import 'package:dio/dio.dart';

class NewsService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchFinanceNews() async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'q': 'keuangan OR ekonomi OR bisnis', // 🔹 cari berita ekonomi/keuangan
          'language': 'id',
          'sortBy': 'publishedAt',
          'apiKey': '7ca3b44bbd1845628402f4e0e700874d',
        },
      );

      if (response.statusCode == 200) {
        final articles = response.data['articles'] as List;
        if (articles.isEmpty) {
          print('⚠️ Tidak ada berita ditemukan untuk query ini.');
        }
        return articles.map((a) {
          return {
            'title': a['title'] ?? 'Tanpa Judul',
            'description': a['description'] ?? '',
            'url': a['url'] ?? '',
            'urlToImage': a['urlToImage'] ??
                'https://cdn-icons-png.flaticon.com/512/21/21601.png',
            'source': a['source']?['name'] ?? '',
          };
        }).toList();
      } else {
        throw Exception('Gagal mengambil data berita');
      }
    } catch (e) {
      print('⚠️ Error ambil berita: $e');
      return [];
    }
  }
}
