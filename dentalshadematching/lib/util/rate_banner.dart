import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RateBanner extends StatelessWidget {
  final double rate;
  const RateBanner({
    super.key,
    required this.rate
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
          color: Color(0xfffff8ea),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Color(0xffffad1b),
          ),
          Text(rate.toStringAsFixed(1))
        ],
      ),
    );
  }
}