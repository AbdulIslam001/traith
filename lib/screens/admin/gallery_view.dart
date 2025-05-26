import 'package:flutter/material.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  // Dummy list of 10 event poster URLs
  final List<Map<String, String>> dummyEvents = const [
    {
      'posterUrl': 'https://picsum.photos/id/1011/600/400',
      'eventName': 'Music Fest 2025',
    },
    {
      'posterUrl': 'https://picsum.photos/id/1012/600/400',
      'eventName': 'Art Expo',
    },
    {
      'posterUrl': 'https://picsum.photos/id/1013/600/400',
      'eventName': 'Food Carnival',
    },
    {
      'posterUrl': 'https://picsum.photos/id/1015/600/400',
      'eventName': 'Tech Summit',
    },
    {
      'posterUrl': 'https://picsum.photos/id/1016/600/400',
      'eventName': 'Charity Run',
    },
    {
      'posterUrl': 'https://picsum.photos/id/1018/600/400',
      'eventName': 'Book Fair',
    },
    {
      'posterUrl': 'https://picsum.photos/id/1019/600/400',
      'eventName': 'Film Festival',
    },
    {
      'posterUrl': 'https://picsum.photos/id/1020/600/400',
      'eventName': 'Dance Show',
    },
    {
      'posterUrl': 'https://picsum.photos/id/1021/600/400',
      'eventName': 'Startup Pitch',
    },
    {
      'posterUrl': 'https://picsum.photos/id/1022/600/400',
      'eventName': 'Comedy Night',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Event Posters"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: dummyEvents.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,       // 2 images per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,  // Adjust height for image + text
          ),
          itemBuilder: (context, index) {
            final event = dummyEvents[index];
            final posterUrl = event['posterUrl']!;
            final eventName = event['eventName']!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      posterUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  eventName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
