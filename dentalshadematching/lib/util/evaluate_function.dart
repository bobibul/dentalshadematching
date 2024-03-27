import 'dart:math';
import 'dart:typed_data';
import 'package:delta_e/delta_e.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

double radianToDegree(double angle) {
  return angle * (180.0 / pi);
}

double degreeToRadian(double angle) {
  return angle * (pi / 180.0);
}

Future<LabColor> calculateAverageLab(img.Image image) async {

  int height = image.height;
  int width = image.width;

  // Lab 값의 합 초기화
  double sumL = 0; double sumA = 0; double sumB = 0;
  double realL =0; double realA =0; double realB =0;

  // 모든 픽셀에 대해 Lab 값의 합 계산
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      img.Pixel pixel = image.getPixel(x, y);
      sumL += pixel.r;
      sumA += pixel.g;
      sumB += pixel.b;
    }
  }

  // 픽셀 수로 나누어 Lab 값의 평균 계산
  int totalPixels = height * width;
  double averageL = sumL / totalPixels;
  double averageA = sumA / totalPixels;
  double averageB = sumB / totalPixels;

  realL = img.rgbToLab(averageL, averageA, averageB)[0].toDouble();
  realA = img.rgbToLab(averageL, averageA, averageB)[1].toDouble();
  realB = img.rgbToLab(averageL, averageA, averageB)[2].toDouble();

  LabColor labColor = LabColor(realL,realA,realB);

  return labColor;
}
