import 'package:flutter/material.dart';
import '../STAN/model/stan_model.dart';
import '../STAN/services/stan_service.dart';

class DashboardStanPage extends StatefulWidget {
  const DashboardStanPage({super.key});

  @override
  State<DashboardStanPage> createState() => _DashboardStanPageState();
}

class _DashboardStanPageState extends State<DashboardStanPage> {

  late Future<List<StanModel>> futureStan;

  @override
  void initState() {
    super.initState();
    futureStan = StanService.getStan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Stan"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<StanModel>>(
        future: futureStan,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text("Data stan kosong"),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {

              final stan = data[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(stan.namaStan),
                  subtitle: Text("Pemilik : ${stan.pemilik}"),
                  leading: const Icon(Icons.store),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
