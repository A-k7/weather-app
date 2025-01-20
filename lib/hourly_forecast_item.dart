import 'package:flutter/material.dart';

class Hourlyforecastitem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const Hourlyforecastitem({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature
    });

  @override
  Widget build(BuildContext context) {
    return  Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                width: 100,
                child: Column(
                  children: [
                    Text(time,
                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 6,),
                    Icon(icon),
                    const SizedBox(height: 6,),
                    Text(temperature,
                    style: const TextStyle(fontSize: 16),
                  )                          ],
                ),
              ),
    );
  }
}