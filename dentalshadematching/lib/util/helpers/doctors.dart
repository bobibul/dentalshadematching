class Doctor {
  String imagePath;
  String name, position;
  double rate;

  Doctor({
    required this.name,
    required this.rate,
    required this.position,
    required this.imagePath,
  });
}

class Patient{
  String shadeguide;
  String name;
  int age;
  String sex;
  String imagepath;

  Patient({
    required this.shadeguide,
    required this.name,
    required this.age,
    required this.sex,
    required this.imagepath
  });
}
