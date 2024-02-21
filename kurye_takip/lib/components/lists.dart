class Lists {
  static List<String> generateCarYearList() {
    int currentYear = DateTime.now().year;
    List<String> carYearList = [];

    for (int i = currentYear; i >= currentYear - 30; i--) {
      carYearList.add(i.toString());
    }

    return carYearList;
  }

  static List<String> carFuelTypeList = ['Benzin', 'Benzin/LPG', 'Dizel', 'Elektrik', 'Hibrit(Elektrik/Benzin)', 'Hidrojen'];
  static List<String> carTransmissionTypeList = ['Otomatik', 'Manuel', 'Yarı Otomatik'];
  static List<String> carTypeList = ['Otomobil', 'Motosiklet', 'Ticari', 'Karavan'];
  static List<String> kmList = ['0 - 29.999', '30.000 - 59.999', '60.000 - 89.999', '90.000 ve üzeri'];

  static List<String> drawerCarFuelTypeList = ['Tümü', 'Benzin', 'Benzin/LPG', 'Dizel', 'Elektrik', 'Hibrit(Elektrik/Benzin)', 'Hidrojen'];
  static List<String> drawerCarTransmissionTypeList = ['Tümü', 'Otomatik', 'Manuel', 'Yarı Otomatik'];

  static List<String> genderList = ["Erkek", "Kadın", "Belirtmek İstemiyorum"];
}
