class Section {
  final String name;
  final String teacher;
  Section(this.name, this.teacher);
}

final Map<int, List<Section>> gradeSections = {
  7: [
    Section('A', 'Mr. Cruz'),
    Section('B', 'Ms. Santos'),
    Section('C', 'Mr. Dela Rosa'),
    Section('D', 'Ms. Garcia'),
    Section('E', 'Mr. Ramos'),
    Section('F', 'Ms. Mendoza'),
    Section('G', 'Mr. Reyes'),
    Section('H', 'Ms. Villanueva'),
  ],
  8: [
    Section('A', 'Ms. Santos'),
    Section('B', 'Mr. Cruz'),
    Section('C', 'Ms. Garcia'),
    Section('D', 'Mr. Ramos'),
    Section('E', 'Ms. Mendoza'),
    Section('F', 'Mr. Reyes'),
    Section('G', 'Ms. Villanueva'),
  ],
  9: [
    Section('A', 'Mr. Dela Rosa'),
    Section('B', 'Ms. Garcia'),
    Section('C', 'Mr. Ramos'),
    Section('D', 'Ms. Mendoza'),
    Section('E', 'Mr. Reyes'),
    Section('F', 'Ms. Villanueva'),
  ],
  10: [
    Section('A', 'Ms. Santos'),
    Section('B', 'Mr. Cruz'),
    Section('C', 'Ms. Garcia'),
    Section('D', 'Mr. Ramos'),
    Section('E', 'Ms. Mendoza'),
  ],
}; 