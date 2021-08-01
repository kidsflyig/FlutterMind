import 'package:FlutterMind/third_party/smartselection/smart_select.dart' show S2Choice;

List<S2Choice<double>> font_sizes = [
  S2Choice<double>(value: 12, title: '12'),
  S2Choice<double>(value: 13, title: '13'),
  S2Choice<double>(value: 14, title: '14'),
  S2Choice<double>(value: 15, title: '15'),
  S2Choice<double>(value: 16, title: '16'),
  S2Choice<double>(value: 17, title: '17'),
  S2Choice<double>(value: 18, title: '18'),
];

List<S2Choice<bool>> is_font_bold = [
  S2Choice<bool>(value: false, title: 'normal'),
  S2Choice<bool>(value: true, title: 'bold')
];

List<S2Choice<String>> font_families = [
  S2Choice<String>(value: 'Arial', title: 'Arial'),
  S2Choice<String>(value: 'Candara', title: 'Candara'),
  S2Choice<String>(value: 'BERNHC', title: 'BERNHC'),
  S2Choice<String>(value: 'Arizonia', title: 'Arizonia'),
  S2Choice<String>(value: 'ChunkFive', title: 'ChunkFive'),
  S2Choice<String>(value: 'GrandHotel', title: 'GrandHotel'),
  S2Choice<String>(value: 'GreatVibes', title: 'GreatVibes'),
  S2Choice<String>(value: 'Lobster', title: 'Lobster'),
  S2Choice<String>(value: 'OpenSans', title: 'OpenSans'),
  S2Choice<String>(value: 'OstrichSans', title: 'OstrichSans'),
  S2Choice<String>(value: 'Oswald', title: 'Oswald'),
  S2Choice<String>(value: 'Pacifico', title: 'Pacifico'),
  S2Choice<String>(value: 'Quicksand', title: 'Quicksand'),
  S2Choice<String>(value: 'Roboto', title: 'Roboto'),
  S2Choice<String>(value: 'SEASRN', title: 'SEASRN'),
  S2Choice<String>(value: 'Windsong', title: 'Windsong'),
];

List<S2Choice<String>> months = [
  S2Choice<String>(value: 'jan', title: 'January'),
  S2Choice<String>(value: 'feb', title: 'February'),
  S2Choice<String>(value: 'mar', title: 'March'),
  S2Choice<String>(value: 'apr', title: 'April'),
  S2Choice<String>(value: 'may', title: 'May'),
  S2Choice<String>(value: 'jun', title: 'June'),
  S2Choice<String>(value: 'jul', title: 'July'),
  S2Choice<String>(value: 'aug', title: 'August'),
  S2Choice<String>(value: 'sep', title: 'September'),
  S2Choice<String>(value: 'oct', title: 'October'),
  S2Choice<String>(value: 'nov', title: 'November'),
  S2Choice<String>(value: 'dec', title: 'December'),
];

List<S2Choice<String>> sorts = [
  S2Choice<String>(value: 'popular', title: 'Popular'),
  S2Choice<String>(value: 'review', title: 'Most Reviews'),
  S2Choice<String>(value: 'latest', title: 'Newest'),
  S2Choice<String>(value: 'cheaper', title: 'Low Price'),
  S2Choice<String>(value: 'pricey', title: 'High Price'),
];

List<Map<String, dynamic>> cars = [
  {'value': 'bmw-x1', 'title': 'BMW X1', 'brand': 'BMW', 'body': 'SUV'},
  {'value': 'bmw-x7', 'title': 'BMW X7', 'brand': 'BMW', 'body': 'SUV'},
  {'value': 'bmw-x2', 'title': 'BMW X2', 'brand': 'BMW', 'body': 'SUV'},
  {'value': 'bmw-x4', 'title': 'BMW X4', 'brand': 'BMW', 'body': 'SUV'},
  {
    'value': 'honda-crv',
    'title': 'Honda C-RV',
    'brand': 'Honda',
    'body': 'SUV'
  },
  {
    'value': 'honda-hrv',
    'title': 'Honda H-RV',
    'brand': 'Honda',
    'body': 'SUV'
  },
  {
    'value': 'mercedes-gcl',
    'title': 'Mercedes-Benz G-class',
    'brand': 'Mercedes',
    'body': 'SUV'
  },
  {
    'value': 'mercedes-gle',
    'title': 'Mercedes-Benz GLE',
    'brand': 'Mercedes',
    'body': 'SUV'
  },
  {
    'value': 'mercedes-ecq',
    'title': 'Mercedes-Benz ECQ',
    'brand': 'Mercedes',
    'body': 'SUV'
  },
  {
    'value': 'mercedes-glcc',
    'title': 'Mercedes-Benz GLC Coupe',
    'brand': 'Mercedes',
    'body': 'SUV'
  },
  {
    'value': 'lr-ds',
    'title': 'Land Rover Discovery Sport',
    'brand': 'Land Rover',
    'body': 'SUV'
  },
  {
    'value': 'lr-rre',
    'title': 'Land Rover Range Rover Evoque',
    'brand': 'Land Rover',
    'body': 'SUV'
  },
  {
    'value': 'honda-jazz',
    'title': 'Honda Jazz',
    'brand': 'Honda',
    'body': 'Hatchback'
  },
  {
    'value': 'honda-civic',
    'title': 'Honda Civic',
    'brand': 'Honda',
    'body': 'Hatchback'
  },
  {
    'value': 'mercedes-ac',
    'title': 'Mercedes-Benz A-class',
    'brand': 'Mercedes',
    'body': 'Hatchback'
  },
  {
    'value': 'hyundai-i30f',
    'title': 'Hyundai i30 Fastback',
    'brand': 'Hyundai',
    'body': 'Hatchback'
  },
  {
    'value': 'hyundai-kona',
    'title': 'Hyundai Kona Electric',
    'brand': 'Hyundai',
    'body': 'Hatchback'
  },
  {
    'value': 'hyundai-i10',
    'title': 'Hyundai i10',
    'brand': 'Hyundai',
    'body': 'Hatchback'
  },
  {'value': 'bmw-i3', 'title': 'BMW i3', 'brand': 'BMW', 'body': 'Hatchback'},
  {
    'value': 'bmw-sgc',
    'title': 'BMW 4-serie Gran Coupe',
    'brand': 'BMW',
    'body': 'Hatchback'
  },
  {
    'value': 'bmw-sgt',
    'title': 'BMW 6-serie GT',
    'brand': 'BMW',
    'body': 'Hatchback'
  },
  {
    'value': 'audi-a5s',
    'title': 'Audi A5 Sportback',
    'brand': 'Audi',
    'body': 'Hatchback'
  },
  {
    'value': 'audi-rs3s',
    'title': 'Audi RS3 Sportback',
    'brand': 'Audi',
    'body': 'Hatchback'
  },
  {
    'value': 'audi-ttc',
    'title': 'Audi TT Coupe',
    'brand': 'Audi',
    'body': 'Coupe'
  },
  {
    'value': 'audi-r8c',
    'title': 'Audi R8 Coupe',
    'brand': 'Audi',
    'body': 'Coupe'
  },
  {
    'value': 'mclaren-570gt',
    'title': 'Mclaren 570GT',
    'brand': 'Mclaren',
    'body': 'Coupe'
  },
  {
    'value': 'mclaren-570s',
    'title': 'Mclaren 570S Spider',
    'brand': 'Mclaren',
    'body': 'Coupe'
  },
  {
    'value': 'mclaren-720s',
    'title': 'Mclaren 720S',
    'brand': 'Mclaren',
    'body': 'Coupe'
  },
];

List<Map<String, dynamic>> smartphones = [
  {
    'id': 'sk3',
    'name': 'Samsung Keystone 3',
    'brand': 'Samsung',
    'category': 'Budget Phone'
  },
  {
    'id': 'n106',
    'name': 'Nokia 106',
    'brand': 'Nokia',
    'category': 'Budget Phone'
  },
  {
    'id': 'n150',
    'name': 'Nokia 150',
    'brand': 'Nokia',
    'category': 'Budget Phone'
  },
  {
    'id': 'r7a',
    'name': 'Redmi 7A',
    'brand': 'Xiaomi',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ga10s',
    'name': 'Galaxy A10s',
    'brand': 'Samsung',
    'category': 'Mid End Phone'
  },
  {
    'id': 'rn7',
    'name': 'Redmi Note 7',
    'brand': 'Xiaomi',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ga20s',
    'name': 'Galaxy A20s',
    'brand': 'Samsung',
    'category': 'Mid End Phone'
  },
  {
    'id': 'mc9',
    'name': 'Meizu C9',
    'brand': 'Meizu',
    'category': 'Mid End Phone'
  },
  {
    'id': 'm6',
    'name': 'Meizu M6',
    'brand': 'Meizu',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ga2c',
    'name': 'Galaxy A2 Core',
    'brand': 'Samsung',
    'category': 'Mid End Phone'
  },
  {
    'id': 'r6a',
    'name': 'Redmi 6A',
    'brand': 'Xiaomi',
    'category': 'Mid End Phone'
  },
  {
    'id': 'r5p',
    'name': 'Redmi 5 Plus',
    'brand': 'Xiaomi',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ga70',
    'name': 'Galaxy A70',
    'brand': 'Samsung',
    'category': 'Mid End Phone'
  },
  {
    'id': 'ai11',
    'name': 'iPhone 11 Pro',
    'brand': 'Apple',
    'category': 'Flagship Phone'
  },
  {
    'id': 'aixr',
    'name': 'iPhone XR',
    'brand': 'Apple',
    'category': 'Flagship Phone'
  },
  {
    'id': 'aixs',
    'name': 'iPhone XS',
    'brand': 'Apple',
    'category': 'Flagship Phone'
  },
  {
    'id': 'aixsm',
    'name': 'iPhone XS Max',
    'brand': 'Apple',
    'category': 'Flagship Phone'
  },
  {
    'id': 'hp30',
    'name': 'Huawei P30 Pro',
    'brand': 'Huawei',
    'category': 'Flagship Phone'
  },
  {
    'id': 'ofx',
    'name': 'Oppo Find X',
    'brand': 'Oppo',
    'category': 'Flagship Phone'
  },
  {
    'id': 'gs10',
    'name': 'Galaxy S10+',
    'brand': 'Samsung',
    'category': 'Flagship Phone'
  },
];

List<Map<String, dynamic>> transports = [
  {
    'title': 'Plane',
    'image': 'https://source.unsplash.com/Eu1xLlWuTWY/100x100',
  },
  {
    'title': 'Train',
    'image': 'https://source.unsplash.com/Njq3Nz6-5rQ/100x100',
  },
  {
    'title': 'Bus',
    'image': 'https://source.unsplash.com/qoXgaF27zBc/100x100',
  },
  {
    'title': 'Car',
    'image': 'https://source.unsplash.com/p7tai9P7H-s/100x100',
  },
  {
    'title': 'Bike',
    'image': 'https://source.unsplash.com/2LTMNCN4nEg/100x100',
  },
];
