import 'package:flutter/material.dart';
import 'package:madadgaar/Maps/maps.dart';
import 'package:madadgaar/splashscreen.dart';
Map<String,dynamic> selection={
  'ReportEmergency':'set1',
  'Catogery':'set2',
  'Subcatogery':'set3',

};

class EmergencyReportScreen extends StatefulWidget {
  const EmergencyReportScreen({super.key});

  @override
  State<EmergencyReportScreen> createState() => _EmergencyReportScreenState();
}

class _EmergencyReportScreenState extends State<EmergencyReportScreen> {
  final List<Option> _scaleOptions = [
    Option('Low-Scale Incident', 'few people, one place', Icons.person),
    Option('Medium-Scale Incident', 'multiple injuries/units', Icons.group),
    Option(
        'Large-Scale Incident', 'major hazard, many affected', Icons.warning),
  ];
  int? _selectedScale;

  final Map<String, List<Option>> _categoryMap = {
    'Low-Scale Incident': [
      Option('Fire', 'House or small fire', Icons.fire_extinguisher),
      Option('Medical', 'Health emergencies', Icons.local_hospital),
      Option('Accidents & Rescue', 'Trapped or injured', Icons.car_crash),
      Option('Dangerous Materials', 'Small leaks or exposure', Icons.science),
    ],
    'Medium-Scale Incident': [
      Option('Fire', 'Factory or bush fire', Icons.factory),
      Option('Medical', 'Multiple injured or pregnancy case',
          Icons.health_and_safety),
      Option('Accidents & Rescue', 'Collapse, heavy object injuries',
          Icons.carpenter),
      Option(
          'Dangerous Materials', 'Large spill, radiation', Icons.warning_amber),
    ],
    'Large-Scale Incident': [
      Option('Fire', 'Major factory or wildfire', Icons.local_fire_department),
      Option('Medical', 'Mass casualty incidents', Icons.medical_services),
      Option(
          'Accidents & Rescue', 'Building collapse, pile-up', Icons.apartment),
      Option('Dangerous Materials', 'Chemical plant or biohazard',
          Icons.coronavirus),
    ],
  };

  void _onCategoryTap(Option category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubcategoryScreen(
          category: category,
          scaleTitle: _scaleOptions[_selectedScale!].title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaleSelected = _selectedScale != null;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Please Select Option:')),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Report Emergency',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Select how serious the situation is:',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              itemCount: _scaleOptions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 100,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, idx) {
                final opt = _scaleOptions[idx];
                final selected = _selectedScale == idx;
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedScale = idx;
                      selection['ReportEmergency']=idx;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          selected ? Colors.red.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(opt.icon, size: 30, color: Colors.red),
                        const SizedBox(height: 4),
                        Text(opt.title, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            if (scaleSelected) ...[
              const Text('Choose Emergency Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _categoryMap[_scaleOptions[_selectedScale!].title]!
                      .length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, idx) {
                    final cat = _categoryMap[
                        _scaleOptions[_selectedScale!].title]![idx];
                    return ListTile(
                      leading: Icon(cat.icon, color: Colors.red),
                      title: Text(cat.title),
                      subtitle: Text(cat.subtitle),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        setState(() {
                          _onCategoryTap(cat);
                          selection["Catogery"]=cat.title;
                        });
                      },
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class SubcategoryScreen extends StatefulWidget {
  final Option category;
  final String scaleTitle;
  const SubcategoryScreen(
      {required this.category, required this.scaleTitle, super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, List<Option>> subcategoryData = {
      'Fire': [
        Option('House fire', 'aag lag gayi hai ghar mein', Icons.home),
        Option('Car or motorcycle fire', 'gaari ya motorcycle mein aag',
            Icons.directions_car),
        Option('Electric short-circuit fire', 'bijli ka short circuit',
            Icons.electrical_services),
        Option('Factory or warehouse fire', 'factory ya godown mein aag',
            Icons.factory),
        Option('Bush or grass fire', 'ghaas mein aag', Icons.park),
        // Option('Major factory blaze', 'bara carakhana jal gaya hai',
        //     Icons.fireplace),
        // Option('Wildfire', 'jangal mein aag', Icons.terrain),
      ],
      'Medical': [
        Option('Cardiac Arrest', 'dil ka daura', Icons.favorite),
        Option('Breathing Problem', 'saans mein takleef', Icons.air),
        Option('Bleeding', 'zyada khoon beh raha hai', Icons.healing),
        Option('Stroke or Seizure', 'fit aa gaya hai', Icons.emergency),
        Option('Pregnancy Emergency', 'zichgi ka masla', Icons.pregnant_woman),
        Option('Multiple Trauma Victims', 'kay log zakhmi hain', Icons.people),
        Option('Mass Injury Incident',
            'school ya factory mein choton ka waqiya', Icons.school),
        Option(
            'Stampede Injuries', 'bhaag daud se zakhmi', Icons.directions_run),
      ],
      'Accidents & Rescue': [
        Option('Road Crash', 'sarak ka hadsa', Icons.car_crash),
        Option('Fall from height', 'balcony ya chhat se gir gaya',
            Icons.vertical_align_bottom),
        Option('Trapped under heavy object', 'cheezein gir gayi hain',
            Icons.fitness_center),
        Option('Drowning or flood rescue', 'doob raha hai ya paani mein hai',
            Icons.water),
        Option('Building collapse', 'imarat gir gayi hai', Icons.apartment),
        Option('Crush injury', 'wazan se zakhmi', Icons.archive),
        Option('Pile-up accident', 'bahut saari gaariyan takra gayi',
            Icons.directions_car),
      ],
      'Dangerous Materials': [
        Option('Small chemical spill', 'thoda chemical gir gaya',
            Icons.local_drink),
        Option('Gas leak', 'gas ya petrol ki boo', Icons.local_gas_station),
        Option('Infectious exposure', 'zehreela kachra ya virus',
            Icons.coronavirus),
        Option(
            'Large spill', 'bara chemical gir gaya hai', Icons.local_pharmacy),
        Option('Radiation hazard', 'radiation ka khatra',
            Icons.wifi_tethering_error),
        Option('Biohazard leak', 'zehreela bahan public mein',
            Icons.warning_amber),
      ],
    };

    final subcats = subcategoryData[widget.category.title] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Individual ${widget.category.title} Cases'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: subcats.length,
        itemBuilder: (context, idx) {
          final sub = subcats[idx];
          return ListTile(
            leading: Icon(sub.icon, color: Colors.red),
            title: Text(sub.title),
            subtitle: Text(sub.subtitle),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              setState(() {
                selection["Subcatogery"]=sub.title;
                  print(selection["ReportEmergency"]);
                  print(selection["Catogery"]);
                  print(selection["Subcatogery"]);
                  {/*
                  API Called to send actions
                  */}
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Maps(),));


              });

            },
          );
        },
      ),
    );
  }
}

class Option {
  final String title;
  final String subtitle;
  final IconData icon;
  Option(this.title, this.subtitle, this.icon);
}



