import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/util/text.dart';

import '../constants.dart';
import 'helpers/doctors.dart';
import 'helpers/text_helper.dart';

class DoctorsCard extends StatelessWidget {
  final Doctor doctor;
  const DoctorsCard({
    super.key,
    required this.doctor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
          color: colors['white-color'],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFe2e1ec).withOpacity(1),
              offset: Offset(3, 4),
              blurRadius: 33,
              spreadRadius: 0,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              minRadius: 10,
              maxRadius: 35,
              backgroundImage: AssetImage(doctor.imagePath),
            ),
            SizedBox(
              height: 10,
            ),
            CText(
              text: doctor.name,
              decorations: TextDecorations(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            CText(
              text: doctor.position,
              decorations: TextDecorations(
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              width: 90,
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
                  Text(doctor.rate.toStringAsFixed(1))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PatientsCard extends StatelessWidget {
  final Patient patient;
  const PatientsCard({super.key, required this.patient});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
          color: colors['white-color'],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFe2e1ec).withOpacity(1),
              offset: Offset(3, 4),
              blurRadius: 33,
              spreadRadius: 0,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              minRadius: 12,
              maxRadius: 55,
              backgroundImage: AssetImage(patient.imagepath),
            ),
            SizedBox(
              height: 10,
            ),
            CText(
              text: patient.name,
              decorations: TextDecorations(
                fontSize: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(patient.age.toString()),
                Text(' , ' ),
                Text(patient.sex)
              ],
            ),
            Container(
              width: 90,
              decoration: BoxDecoration(
                  color: Color(0xfffff8ea),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text(patient.shadeguide)),
              ),
          ],
        ),
      ),
    );
  }
}