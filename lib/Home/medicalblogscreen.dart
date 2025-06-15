import 'package:flutter/material.dart';

class MedicalBlogScreen extends StatelessWidget {
  const MedicalBlogScreen({super.key});

  final List<Map<String, String>> blogPosts = const [
    {
      'title': 'How to Perform CPR',
      'subtitle': 'Step-by-step guide for emergency situations.',
      'content': 'Cardiopulmonary Resuscitation (CPR) is an emergency lifesaving procedure performed when the heart stops beating. Immediate CPR can double or even triple a person’s chance of survival after cardiac arrest. It involves chest compressions combined with rescue breaths to manually maintain circulation of oxygenated blood to the brain and other vital organs until professional medical help arrives.',
      'image': 'assets/cpr.jpg'
    },
    {
      'title': 'Heat Stroke Prevention Tips',
      'subtitle': 'Stay safe during summer.',
      'content': 'Heat stroke is a life-threatening condition in which heat overwhelms your body’s ability to manage its temperature. Symptoms include dizziness, fainting, blurred vision, slurred speech and confusion. Heat stroke causes reduced blood flow and damage to vital organs. Seek immediate medical care for anyone with symptoms of heat stroke.',
      'image': 'assets/heatstroke.jpg'
    },
    {
      'title': 'First Aid for Burns',
      'subtitle': 'Immediate actions to take after a burn injury.',
      'content': 'Most burns happen because of something that’s too hot for you to handle. But burns can also happen when something’s too cold, with friction, chemicals and even from the sun. Knowing how to recognize and treat burns is important. And knowing when to get expert medical care for them can be lifesaving.',
      'image': 'assets/burns.jpeg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Blog"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          final blog = blogPosts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetailScreen(
                    title: blog['title']!,
                    content: blog['content']!,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    blog['image']!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withAlpha(102),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blog['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          blog['subtitle']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
    );
  }
}

class BlogDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const BlogDetailScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(content, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}