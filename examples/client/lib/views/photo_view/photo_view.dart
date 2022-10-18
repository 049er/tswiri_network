import 'package:flutter/material.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({Key? key}) : super(key: key);

  @override
  State<PhotoView> createState() => PhotoViewState();
}

class PhotoViewState extends State<PhotoView> {
  String? photoLink;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'photo_view',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  // TextEditingController _controller = TextEditingController();

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) {
                  if (value.isEmpty) {
                    photoLink = null;
                  } else {
                    photoLink = 'http://192.168.68.137:8085/photos/$value.jpg';
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          Builder(builder: (context) {
            if (photoLink != null) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    photoLink!,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error),
                      );
                    },
                  ),
                ),
              );
            }
            return const Icon(Icons.warning);
          }),
        ],
      ),
    );
  }
}
