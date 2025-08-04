import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FooodAppHomeScreen extends StatefulWidget {
  const FooodAppHomeScreen({super.key});

  @override
  State<FooodAppHomeScreen> createState() => _FooodAppHomeScreenState();
}

class _FooodAppHomeScreenState extends State<FooodAppHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        leading: Container(
          height: 45,
          width: 45,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset('assets/food-delivery/icon/dash.png'),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Iconsax.location, color: Colors.red, size: 18),
            SizedBox(width: 4),
            Text(
              'California, US',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.orange,
              size: 20,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              height: 45,
              width: 45,
              child: Image.asset('assets/food-delivery/profile.png'),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: []),
    );
  }
}
