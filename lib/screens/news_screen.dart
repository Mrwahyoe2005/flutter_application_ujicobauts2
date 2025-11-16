import 'package:flutter/material.dart';
import '../services/news_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  bool isLoading = true;
  List<Map<String, dynamic>> articles = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    final data = await _newsService.fetchFinanceNews();
    setState(() {
      articles = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF009688),
        title: const Text(
          'Berita Keuangan Terkini',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : articles.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada berita yang tersedia.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNews,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final news = articles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                        child: InkWell(
                          onTap: () async {
                            final url = Uri.parse(news['url']);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(14)),
                                child: Image.network(
                                  news['urlToImage'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, _, __) =>
                                      const Icon(Icons.broken_image, size: 60),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      news['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      news['description'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Sumber: ${news['source']}',
                                      style: const TextStyle(
                                        color: Colors.teal,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
