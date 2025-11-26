import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';

class BloodInstructionScreen extends StatefulWidget {
  const BloodInstructionScreen({super.key});

  @override
  State<BloodInstructionScreen> createState() => _BloodInstructionScreenState();
}

class _BloodInstructionScreenState extends State<BloodInstructionScreen> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // Instructions as paragraph
    final String instructions =
        "Donating blood is a vital and lifesaving act. Ensure you are healthy and fit before donating. "
        "The minimum age for donation is 18 years, and there should be a gap of at least 3 months between donations. "
        "Eat a healthy meal and stay hydrated before donating. Avoid alcohol for 24 hours prior to donation and inform the staff about any medication you are taking.";

    // Blood compatibility chart
    final List<Map<String, String>> bloodChart = [
      {"Blood Group": "A+", "Can Donate To": "A+, AB+", "Can Receive From": "A+, A-, O+, O-"},
      {"Blood Group": "A-", "Can Donate To": "A+, A-, AB+, AB-", "Can Receive From": "A-, O-"},
      {"Blood Group": "B+", "Can Donate To": "B+, AB+", "Can Receive From": "B+, B-, O+, O-"},
      {"Blood Group": "B-", "Can Donate To": "B+, B-, AB+, AB-", "Can Receive From": "B-, O-"},
      {"Blood Group": "AB+", "Can Donate To": "AB+", "Can Receive From": "Everyone"},
      {"Blood Group": "AB-", "Can Donate To": "AB+, AB-", "Can Receive From": "A-, B-, AB-, O-"},
      {"Blood Group": "O+", "Can Donate To": "O+, A+, B+, AB+", "Can Receive From": "O+, O-"},
      {"Blood Group": "O-", "Can Donate To": "Everyone", "Can Receive From": "O-"},
    ];

    // App bar color
    final Color primaryRed = const Color(0xFF8B0000);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Blood Instructions"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions Section
              Text(
                "Donation Instructions",
                style: TextStyle(
                    fontSize: SizeConfig.blockWidth * 5.5,
                    fontWeight: FontWeight.bold,
                    color: primaryRed),
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              Text(
                instructions,
                style: TextStyle(
                  fontSize: SizeConfig.blockWidth * 4.2,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              SizedBox(height: SizeConfig.blockHeight * 3),

              // Blood Compatibility Chart Section
              Text(
                "Blood Compatibility Chart",
                style: TextStyle(
                    fontSize: SizeConfig.blockWidth * 5.5,
                    fontWeight: FontWeight.bold,
                    color: primaryRed),
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),

              // Table Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(primaryRed.withOpacity(0.2)),
                    headingTextStyle: TextStyle(
                      color: primaryRed,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockWidth * 4,
                    ),
                    dataTextStyle: TextStyle(
                      color: Colors.grey[800],
                      fontSize: SizeConfig.blockWidth * 3.8,
                    ),
                    columns: const [
                      DataColumn(label: Text("Blood Group")),
                      DataColumn(label: Text("Can Donate To")),
                      DataColumn(label: Text("Can Receive From")),
                    ],
                    rows: bloodChart
                        .map(
                          (data) => DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            int index = bloodChart.indexOf(data);
                            return index % 2 == 0 ? Colors.grey[50] : Colors.grey[100];
                          },
                        ),
                        cells: [
                          DataCell(Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: primaryRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(data["Blood Group"]!))),
                          DataCell(Text(data["Can Donate To"]!)),
                          DataCell(Text(data["Can Receive From"]!)),
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}


