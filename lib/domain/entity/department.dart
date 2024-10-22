class DepartmentEntity {
  late int id;
  final String name;

  DepartmentEntity({required this.name});
}

enum DepartmentEnum {
  kommunisticheskaya(id: 1, name: "ул.Коммунистическая, 31"),
  sovetskaya(id: 2, name: "ул.Советская, 32"),
  chuykova(id: 3, name: "ул.Чуйкова"),
  nikolaevsk(id: 4, name: "Николаевск"),
  elan(id: 5, name: "Елань"),
  sloboda(id: 6, name: "Слобода"),
  ahtuba(id: 7, name: "Средняя Ахтуба"),
  preobrazhenskaya(id: 8, name: "Преображенская");

  final int id;
  final String name;

  const DepartmentEnum({
    required this.id,
    required this.name,
  });
}
