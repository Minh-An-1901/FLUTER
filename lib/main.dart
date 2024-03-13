import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Tin Tức',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ArticleListScreen(),
    );
  }
}

class Article {
  final String title;
  final String content;
  final String imageUrl;

  Article({required this.title, required this.content, required this.imageUrl});

  static Article fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}
class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({Key? key}) : super(key: key);

  Future<List<Article>> fetchArticles() async {
    // Giả sử rằng chúng ta lấy dữ liệu từ một API
    // Đây là dữ liệu giả định
    return <Article>[
      Article(
        title: ' ',
        content: ' ',
        imageUrl: 'assets/images/bao1.png',
      ),
      Article(
        title: ' ',
        content: ' ',
        imageUrl: 'assets/images/bao2.png',
      ),
      // Thêm các bài viết khác tại đây
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài báo'),
      ),
      body: FutureBuilder<List<Article>>(
        future: fetchArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có bài báo nào.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(article.title),
                        subtitle: Text(article.content),
                      ),
                      Image.asset(article.imageUrl), // Hiển thị hình ảnh
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(article.content),
              const SizedBox(height: 10),
              InkWell(
                child: Image.asset(article.imageUrl),
                // Sử dụng Image.asset hoặc Image.network tùy thuộc vào nguồn hình ảnh của bạn
                onTap: () =>
                    _launchURL(
                        'http://vipvip'), // Thay thế 'http://vipvip' bằng URL thực tế mà bạn muốn liên kết đến
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}