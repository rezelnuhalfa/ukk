import 'package:flutter/material.dart';
import '../models/diskon_model.dart';

class BannerDiskon extends StatelessWidget {
  final Diskon diskon;

  const BannerDiskon({super.key, required this.diskon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 280,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 0, 0),
            Color.fromARGB(255, 255, 255, 255),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DISKON SPESIAL",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),

            Text(
              diskon.nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "${diskon.persen}% OFF",
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),

            Text(
              "Berlaku hingga ${diskon.tanggalAkhir}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
