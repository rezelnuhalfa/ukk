import 'package:flutter/material.dart';
import 'models/stan_model.dart';
import 'services/stan_service.dart';

class StanPage extends StatefulWidget {
  const StanPage({super.key});

  @override
  State<StanPage> createState() => _StanPageState();
}

class _StanPageState extends State<StanPage> {
  late Future<List<Stan>> futureStan;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureStan = StanService.getAllStan();
  }

  void searchStan() {
    setState(() {
      futureStan =
          StanService.getAllStan(search: searchController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Stan'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari stan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchStan,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Stan>>(
              future: futureStan,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Stan tidak ditemukan'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final stan = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          child: const Icon(Icons.store,
                              color: Colors.orange),
                        ),
                        title: Text(stan.namaStan),
                        subtitle: Text(
                          'Pemilik: ${stan.namaPemilik}\nTelp: ${stan.telp}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
