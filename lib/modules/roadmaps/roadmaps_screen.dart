import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'roadmap_data.dart';
import 'roadmap_detail_screen.dart';

class RoadmapsScreen extends StatefulWidget {
  const RoadmapsScreen({super.key});

  @override
  State<RoadmapsScreen> createState() => _RoadmapsScreenState();
}

class _RoadmapsScreenState extends State<RoadmapsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Programming',
    'Web Development',
    'Mobile Development',
    'Data Science',
    'DevOps',
    'Design',
    'Cybersecurity',
    'Blockchain',
    'Game Development',
    'Cloud',
    'Testing',
    'Product Management',
    'AI/ML',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roadmaps = RoadmapRepository.allRoadmaps;
    
    // Filter by category
    final filteredByCategory = _selectedCategory == 'All'
        ? roadmaps
        : roadmaps.where((r) => r.category == _selectedCategory).toList();
    
    // Filter by search
    final filteredRoadmaps = _searchQuery.isEmpty
        ? filteredByCategory
        : filteredByCategory.where((r) {
            return r.title.toLowerCase().contains(_searchQuery) ||
                r.description.toLowerCase().contains(_searchQuery);
          }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Tech Roadmaps',
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade900,
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search roadmaps...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          
          // Category Filter
          Container(
            height: 50,
            color: Colors.grey.shade900,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey.shade800,
                    selectedColor: Colors.cyanAccent,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Roadmaps Grid
          Expanded(
            child: filteredRoadmaps.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 64, color: Colors.grey.shade700),
                        const SizedBox(height: 16),
                        Text(
                          'No roadmaps found',
                          style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredRoadmaps.length,
                    itemBuilder: (context, index) {
                      final roadmap = filteredRoadmaps[index];
                      return _buildRoadmapCard(roadmap);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapCard(TechRoadmap roadmap) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoadmapDetailScreen(roadmap: roadmap),
          ),
        );
      },
      child: Card(
        color: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: roadmap.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  roadmap.icon,
                  color: roadmap.color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                roadmap.title,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Description
              Text(
                roadmap.description,
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              
              // Duration & Steps
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    roadmap.duration,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: roadmap.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${roadmap.steps.length} steps',
                      style: GoogleFonts.montserrat(
                        color: roadmap.color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
