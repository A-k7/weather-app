  import 'package:flutter/material.dart';

class Additionalinfoitem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
 const Additionalinfoitem({
  super.key,
  required this.icon,
  required this.label,
  required this.value
 });

@override
Widget build(BuildContext context) {
  return  Column(
                  children: [
                    Icon(icon,
                    size: 50,),
                    const SizedBox(height: 6,),
                    Text(label,
                    style: const TextStyle(
                    fontSize: 16),),
                    const SizedBox(height: 6,),
                    Text(value,
                    style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold),),
                  ],
                );
  }
}
