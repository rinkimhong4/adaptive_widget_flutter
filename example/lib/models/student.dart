// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'dart:convert';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  int? studentid;
  String? studentnamekh;
  String? studentname;
  String? gender;
  int? classid;
  Class? studentClass;
  List<dynamic>? attendances;

  Student({
    this.studentid,
    this.studentnamekh,
    this.studentname,
    this.gender,
    this.classid,
    this.studentClass,
    this.attendances,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    studentid: json["studentid"],
    studentnamekh: json["studentnamekh"],
    studentname: json["studentname"],
    gender: json["gender"],
    classid: json["classid"],
    studentClass: Class.fromJson(json["class"]),
    attendances: List<dynamic>.from(json["attendances"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "studentid": studentid,
    "studentnamekh": studentnamekh,
    "studentname": studentname,
    "gender": gender,
    "classid": classid,
    "class": studentClass?.toJson(),
    "attendances": List<dynamic>.from(attendances!.map((x) => x)),
  };
}

class Class {
  int? classid;
  String? classname;

  Class({this.classid, this.classname});

  factory Class.fromJson(Map<String, dynamic> json) =>
      Class(classid: json["classid"], classname: json["classname"]);

  Map<String, dynamic> toJson() => {"classid": classid, "classname": classname};
}
