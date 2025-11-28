import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  String _selectedSubject = 'IP';

  // Master Syllabus Data for all subjects
  static final Map<String, Map<String, dynamic>> syllabusData = {
    'IP': {
      'fullName': 'Introduction to Programming',
      'icon': Icons.code,
      'color': Colors.purple,
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Introduction to Problem Solving',
          'topics': [
            'Computer History & Evolution',
            'Problem Solving Techniques',
            'Algorithms & Flowcharts',
            'Pseudocode',
            'Introduction to Programming Languages',
            'Compilers vs Interpreters',
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Basics of C Programming',
          'topics': [
            'Structure of C Program',
            'Keywords & Identifiers',
            'Data Types (int, float, char, double)',
            'Variables & Constants',
            'Operators (Arithmetic, Relational, Logical)',
            'Expressions & Type Conversion',
            'Input/Output Functions (printf, scanf)',
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Control Structures & Arrays',
          'topics': [
            'Decision Making (if, if-else, nested if)',
            'Switch-Case Statements',
            'Loops (for, while, do-while)',
            'Break & Continue Statements',
            'One-Dimensional Arrays',
            'Two-Dimensional Arrays',
            'Array Operations',
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Pointers & Strings',
          'topics': [
            'Introduction to Pointers',
            'Pointer Declaration & Initialization',
            'Pointer Arithmetic',
            'Pointers & Arrays',
            'String Basics',
            'String Functions (strlen, strcpy, strcat, strcmp)',
            'Array of Strings',
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Functions, Structures & File Handling',
          'topics': [
            'Function Definition & Declaration',
            'Function Call & Return',
            'Recursion',
            'Structures & Unions',
            'Array of Structures',
            'File Operations (fopen, fclose, fread, fwrite)',
            'File Handling Functions',
          ],
        },
      ],
    },
    'LAAC': {
      'fullName': 'Linear Algebra & Analytical Calculus',
      'icon': Icons.functions,
      'color': Colors.blue,
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Matrices',
          'topics': [
            'Types of Matrices',
            'Matrix Operations',
            'Determinants',
            'Inverse of a Matrix',
            'Rank of a Matrix',
            'System of Linear Equations',
            'Gauss Elimination Method',
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Eigen Values & Eigen Vectors',
          'topics': [
            'Characteristic Equation',
            'Eigen Values & Eigen Vectors',
            'Cayley-Hamilton Theorem',
            'Diagonalization of Matrices',
            'Quadratic Forms',
            'Reduction to Canonical Form',
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Mean Value Theorems',
          'topics': [
            'Rolle\'s Theorem',
            'Lagrange\'s Mean Value Theorem',
            'Cauchy\'s Mean Value Theorem',
            'Taylor\'s Series',
            'Maclaurin\'s Series',
            'Indeterminate Forms',
            'L\'Hospital\'s Rule',
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Multivariable Calculus (Differentiation)',
          'topics': [
            'Partial Derivatives',
            'Total Differential',
            'Chain Rule',
            'Jacobians',
            'Maxima & Minima of Functions',
            'Lagrange\'s Method of Multipliers',
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Multivariable Calculus (Integration)',
          'topics': [
            'Double Integrals',
            'Triple Integrals',
            'Change of Order of Integration',
            'Change of Variables',
            'Applications to Area & Volume',
          ],
        },
      ],
    },
    'CHE': {
      'fullName': 'Engineering Chemistry',
      'icon': Icons.science,
      'color': Colors.green,
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Atomic Structure & Bonding',
          'topics': [
            'Bohr\'s Atomic Model',
            'Quantum Numbers',
            'Aufbau Principle',
            'Pauli\'s Exclusion Principle',
            'Hund\'s Rule',
            'Ionic & Covalent Bonding',
            'Hybridization (sp, sp2, sp3)',
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Electrochemistry',
          'topics': [
            'Electrochemical Cells',
            'Electrode Potential',
            'Nernst Equation',
            'Reference Electrodes',
            'Batteries (Primary & Secondary)',
            'Fuel Cells',
            'Corrosion & Prevention',
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Polymers',
          'topics': [
            'Classification of Polymers',
            'Polymerization Techniques',
            'Addition Polymerization',
            'Condensation Polymerization',
            'Properties of Polymers',
            'Plastics, Rubbers & Fibers',
            'Engineering Applications',
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Water Technology',
          'topics': [
            'Hardness of Water',
            'Units of Hardness',
            'Estimation of Hardness (EDTA Method)',
            'Water Softening Methods',
            'Ion Exchange Process',
            'Reverse Osmosis',
            'Boiler Troubles',
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Spectroscopy & Nanomaterials',
          'topics': [
            'UV-Visible Spectroscopy',
            'IR Spectroscopy',
            'NMR Spectroscopy',
            'Introduction to Nanomaterials',
            'Synthesis of Nanomaterials',
            'Properties & Applications',
          ],
        },
      ],
    },
    'CE': {
      'fullName': 'Communicative English',
      'icon': Icons.language,
      'color': Colors.orange,
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Vocabulary & Word Formation',
          'topics': [
            'Synonyms & Antonyms',
            'Prefixes & Suffixes',
            'Root Words',
            'One-Word Substitution',
            'Idioms & Phrases',
            'Collocations',
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Grammar Essentials',
          'topics': [
            'Parts of Speech',
            'Tenses (Present, Past, Future)',
            'Active & Passive Voice',
            'Direct & Indirect Speech',
            'Subject-Verb Agreement',
            'Articles (a, an, the)',
            'Prepositions',
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Reading Comprehension',
          'topics': [
            'Reading Strategies',
            'Skimming & Scanning',
            'Understanding Main Ideas',
            'Inference & Interpretation',
            'Critical Reading',
            'Note-Making',
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Writing Skills',
          'topics': [
            'Paragraph Writing',
            'Essay Writing',
            'Letter Writing (Formal & Informal)',
            'Email Etiquette',
            'Report Writing',
            'Resume & Cover Letter',
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Communication Skills',
          'topics': [
            'Listening Skills',
            'Speaking Skills',
            'Presentation Skills',
            'Group Discussion',
            'Interview Techniques',
            'Body Language & Non-Verbal Communication',
          ],
        },
      ],
    },
    'BME': {
      'fullName': 'Basic Mechanical Engineering',
      'icon': Icons.settings,
      'color': Colors.red,
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Force Systems & Equilibrium',
          'topics': [
            'Introduction to Mechanics',
            'Force & Types of Forces',
            'Resultant of Forces',
            'Moment of a Force',
            'Couple',
            'Free Body Diagrams',
            'Equilibrium of Rigid Bodies',
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Friction',
          'topics': [
            'Laws of Friction',
            'Coefficient of Friction',
            'Angle of Friction',
            'Friction on Inclined Planes',
            'Ladder Friction Problems',
            'Belt Friction',
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Properties of Materials',
          'topics': [
            'Stress & Strain',
            'Hooke\'s Law',
            'Elastic Moduli',
            'Stress-Strain Diagrams',
            'Poisson\'s Ratio',
            'Thermal Stresses',
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Thermodynamics',
          'topics': [
            'Basic Concepts & Definitions',
            'Zeroth Law of Thermodynamics',
            'First Law of Thermodynamics',
            'Second Law of Thermodynamics',
            'Heat Engines',
            'Carnot Cycle',
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Power Transmission',
          'topics': [
            'Belt Drives',
            'Chain Drives',
            'Gear Drives',
            'Types of Gears',
            'Gear Trains',
            'Clutches & Brakes',
          ],
        },
      ],
    },
    'BCE': {
      'fullName': 'Basic Civil Engineering',
      'icon': Icons.construction,
      'color': Colors.teal,
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Introduction to Civil Engineering',
          'topics': [
            'Scope of Civil Engineering',
            'Role of Civil Engineers',
            'Building Components',
            'Foundation Types',
            'Superstructure',
            'Building Materials Overview',
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Building Materials',
          'topics': [
            'Stones (Types & Properties)',
            'Bricks (Manufacturing & Testing)',
            'Cement (Types & Properties)',
            'Concrete (Ingredients & Mix Design)',
            'Steel (Properties & Uses)',
            'Timber (Types & Applications)',
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Surveying',
          'topics': [
            'Introduction to Surveying',
            'Chain Surveying',
            'Compass Surveying',
            'Levelling',
            'Theodolite Surveying',
            'Contouring',
            'Total Station',
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Transportation Engineering',
          'topics': [
            'Highway Engineering',
            'Road Classification',
            'Geometric Design of Roads',
            'Pavement Types',
            'Railway Engineering',
            'Airport Engineering',
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Environmental Engineering',
          'topics': [
            'Water Supply Systems',
            'Water Treatment',
            'Sewage & Sewerage',
            'Wastewater Treatment',
            'Solid Waste Management',
            'Air Pollution Control',
          ],
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentSubject = syllabusData[_selectedSubject]!;
    final units = currentSubject['units'] as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Subject Syllabus',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade900,
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: Column(
          children: [
            // Subject Dropdown
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSubject,
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade900,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  items: syllabusData.keys.map((String key) {
                    final subject = syllabusData[key]!;
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Row(
                        children: [
                          Icon(
                            subject['icon'] as IconData,
                            color: subject['color'] as Color,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$key - ${subject['fullName']}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSubject = newValue;
                      });
                    }
                  },
                ),
              ),
            ),

            // Syllabus Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (currentSubject['color'] as Color).withOpacity(0.8),
                          (currentSubject['color'] as Color).withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          currentSubject['icon'] as IconData,
                          size: 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentSubject['fullName'] as String,
                          style: GoogleFonts.orbitron(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Complete Syllabus - $_selectedSubject',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Units
                  ...units.map((unit) {
                    final index = units.indexOf(unit);
                    return _buildUnitCard(
                      unitNumber: unit['number'] as String,
                      unitTitle: unit['title'] as String,
                      topics: List<String>.from(unit['topics']),
                      color: currentSubject['color'] as Color,
                      icon: currentSubject['icon'] as IconData,
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  // Footer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.cyanAccent, size: 30),
                        const SizedBox(height: 10),
                        Text(
                          'Study regularly and practice problems',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Access resources from Home → Drawer Menu',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom padding for nav bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitCard({
    required String unitNumber,
    required String unitTitle,
    required List<String> topics,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: color, size: 30),
          title: Text(
            unitNumber,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            unitTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          iconColor: color,
          collapsedIconColor: Colors.grey,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: topics.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: color,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            topic,
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
