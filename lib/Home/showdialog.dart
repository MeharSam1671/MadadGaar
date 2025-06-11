import 'package:flutter/material.dart';
import 'package:madadgaar/Maps/maps.dart';

String? selectedScale;
String? selectedCategory;
String? selectedSubcategory;

class Option {
  final String title;
  final String description;
  final IconData icon;

  Option(this.title, this.description, this.icon);
}

  final List<Option> _scaleOptions = [
    Option('Low-Scale Incident', 'few people, one place', Icons.person),
    Option('Medium-Scale Incident', 'multiple injuries/units', Icons.group),
    Option('Large-Scale Incident', 'major hazard, many affected', Icons.warning),
  ];

  final Map<String, List<Option>> _categoryMap = {
    'Low-Scale Incident': [
      Option('Fire', 'House or small fire', Icons.fire_extinguisher),
      Option('Medical', 'Health emergencies', Icons.local_hospital),
      Option('Accidents & Rescue', 'Trapped or injured', Icons.car_crash),
      Option('Dangerous Materials', 'Small leaks or exposure', Icons.science),
    ],
    'Medium-Scale Incident': [
      Option('Fire', 'Factory or bush fire', Icons.factory),
      Option('Medical', 'Multiple injured or pregnancy case', Icons.health_and_safety),
      Option('Accidents & Rescue', 'Collapse, heavy object injuries', Icons.carpenter),
      Option('Dangerous Materials', 'Large spill, radiation', Icons.warning_amber),
    ],
    'Large-Scale Incident': [
      Option('Fire', 'Major factory or wildfire', Icons.local_fire_department),
      Option('Medical', 'Mass casualty incidents', Icons.medical_services),
      Option('Accidents & Rescue', 'Building collapse, pile-up', Icons.apartment),
      Option('Dangerous Materials', 'Chemical plant or biohazard', Icons.coronavirus),
    ],
  };

  final Map<String, List<Option>> _subcategoryData = {
    'Fire': [
      Option('House fire', 'aag lag gayi hai ghar mein', Icons.home),
      Option('Car or motorcycle fire', 'gaari ya motorcycle mein aag', Icons.directions_car),
      Option('Electric short-circuit fire', 'bijli ka short circuit', Icons.electrical_services),
      Option('Factory or warehouse fire', 'factory ya godown mein aag', Icons.factory),
      Option('Bush or grass fire', 'ghaas mein aag', Icons.park),
    ],
    'Medical': [
      Option('Cardiac Arrest', 'dil ka daura', Icons.favorite),
      Option('Breathing Problem', 'saans mein takleef', Icons.air),
      Option('Bleeding', 'zyada khoon beh raha hai', Icons.healing),
      Option('Stroke or Seizure', 'fit aa gaya hai', Icons.emergency),
      Option('Pregnancy Emergency', 'zichgi ka masla', Icons.pregnant_woman),
      Option('Multiple Trauma Victims', 'kay log zakhmi hain', Icons.people),
      Option('Mass Injury Incident', 'school ya factory mein choton ka waqiya', Icons.school),
      Option('Stampede Injuries', 'bhaag daud se zakhmi', Icons.directions_run),
    ],
    'Accidents & Rescue': [
      Option('Road Crash', 'sarak ka hadsa', Icons.car_crash),
      Option('Fall from height', 'balcony ya chhat se gir gaya', Icons.vertical_align_bottom),
      Option('Trapped under heavy object', 'cheezein gir gayi hain', Icons.fitness_center),
      Option('Drowning or flood rescue', 'doob raha hai ya paani mein hai', Icons.water),
      Option('Building collapse', 'imarat gir gayi hai', Icons.apartment),
      Option('Crush injury', 'wazan se zakhmi', Icons.archive),
      Option('Pile-up accident', 'bahut saari gaariyan takra gayi', Icons.directions_car),
    ],
    'Dangerous Materials': [
      Option('Small chemical spill', 'thoda chemical gir gaya', Icons.local_drink),
      Option('Gas leak', 'gas ya petrol ki boo', Icons.local_gas_station),
      Option('Infectious exposure', 'zehreela kachra ya virus', Icons.coronavirus),
      Option('Large spill', 'bara chemical gir gaya hai', Icons.local_pharmacy),
      Option('Radiation hazard', 'radiation ka khatra', Icons.wifi_tethering_error),
      Option('Biohazard leak', 'zehreela bahan public mein', Icons.warning_amber),
    ],
  };

void showScaleDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => SimpleDialog(
      title: const Text('Select Scale of Incident'),
      children: _scaleOptions.map((option) {
        return SimpleDialogOption(
          onPressed: () {
            selectedScale = option.title;
            print(option.title);
            Navigator.pop(context);
            _showCategoryDialog(context, option.title);
          },
          child: ListTile(
            leading: Icon(option.icon, color: Colors.red),
            title: Text(option.title),
            subtitle: Text(option.description),
          ),
        );
      }).toList(),
    ),
  );
}

void _showCategoryDialog(BuildContext context, String scale) {
  final categories = _categoryMap[scale] ?? [];

  showDialog(
    context: context,
    builder: (_) => SimpleDialog(
      title: Text('Select Category for $scale'),
      children: categories.map((category) {
        return SimpleDialogOption(
          onPressed: () {
            selectedCategory = category.title; // 🟢 Store category
            print(category.title);
            Navigator.pop(context);
            _showSubcategoryDialog(context, category.title);
          },
          child: ListTile(
            leading: Icon(category.icon, color: Colors.blue),
            title: Text(category.title),
            subtitle: Text(category.description),
          ),
        );
      }).toList(),
    ),
  );
}

void _showSubcategoryDialog(BuildContext context, String category) {
  final subcategories = _subcategoryData[category] ?? [];

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Select a Subcategory for $category'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: subcategories.map((sub) {
            return ListTile(
              leading: Icon(sub.icon, color: Colors.green),
              title: Text(sub.title),
              subtitle: Text(sub.description),
              onTap: () {
                selectedSubcategory = sub.title; // 🟢 Store subcategory
                print(sub.title);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Maps(),));

               },
            );
          }).toList(),
        ),
      ),
    ),
  );
}


