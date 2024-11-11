import 'package:flutter/material.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Color> containers = [];

  void addContainer(Color color) {
    setState(() {
      containers.add(color);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        title: const Text('HomeScreen'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            iconSize: 30,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: containers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(color: containers[index]),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: containers[index],
                  borderRadius: BorderRadius.circular(20),
                ),
                width: double.infinity,
                height: 150,
                child: const Center(
                  child: Text(
                    '영어단어 100개',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => addContainer(Colors.red),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
