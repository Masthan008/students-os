import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'roadmap_data.dart';

class RoadmapDetailScreen extends StatefulWidget {
  final TechRoadmap roadmap;

  const RoadmapDetailScreen({super.key, required this.roadmap});

  @override
  State<RoadmapDetailScreen> createState() => _RoadmapDetailScreenState();
}

class _RoadmapDetailScreenState extends State<RoadmapDetailScreen> {
  late Box _progressBox;
  Set<int> _completedSteps = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    _progressBox = await Hive.openBox('roadmap_progress');
    final progress = _progressBox.get(widget.roadmap.title, defaultValue: <int>[]);
    setState(() {
      _completedSteps = Set<int>.from(progress);
    });
  }

  Future<void> _toggleStep(int index) async {
    setState(() {
      if (_completedSteps.contains(index)) {
        _completedSteps.remove(index);
      } else {
        _completedSteps.add(index);
      }
    });
    await _progressBox.put(widget.roadmap.title, _completedSteps.toList());
  }

  @override
  Widget build(BuildContext context) {
    final progress = _completedSteps.length / widget.roadmap.steps.length;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          widget.roadmap.title,
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.roadmap.color.withOpacity(0.3),
                  widget.roadmap.color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.roadmap.color),
            ),
            child: Column(
              children: [
                Icon(widget.roadmap.icon, size: 48, color: widget.roadmap.color),
                const SizedBox(height: 12),
                Text(
                  widget.roadmap.description,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoChip(Icons.access_time, widget.roadmap.duration),
                    _buildInfoChip(Icons.list, '${widget.roadmap.steps.length} steps'),
                    _buildInfoChip(
                      Icons.check_circle,
                      '${(progress * 100).toInt()}%',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade800,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.roadmap.color),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          
          // Steps List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.roadmap.steps.length,
              itemBuilder: (context, index) {
                final step = widget.roadmap.steps[index];
                final isCompleted = _completedSteps.contains(index);
                
                return _buildStepCard(step, index, isCompleted);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: widget.roadmap.color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(RoadmapStep step, int index, bool isCompleted) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCompleted ? widget.roadmap.color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: () => _toggleStep(index),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? widget.roadmap.color
                    : Colors.grey.shade800,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 24)
                    : Text(
                        '${index + 1}',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
          title: Text(
            step.title,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                step.description,
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: widget.roadmap.color),
                  const SizedBox(width: 4),
                  Text(
                    step.duration,
                    style: GoogleFonts.montserrat(
                      color: widget.roadmap.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topics
                  Text(
                    'Topics to Learn:',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...step.topics.map((topic) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: widget.roadmap.color.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_right,
                                  color: widget.roadmap.color,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    topic.title,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (topic.content.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.only(left: 28),
                                child: Text(
                                  topic.content,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey.shade400,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  
                  // Resources
                  Text(
                    'Recommended Resources:',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...step.resources.map((resource) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.link,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              resource,
                              style: GoogleFonts.montserrat(
                                color: Colors.blue,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  
                  // Mark Complete Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _toggleStep(index),
                      icon: Icon(
                        isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      ),
                      label: Text(
                        isCompleted ? 'Completed' : 'Mark as Complete',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted
                            ? widget.roadmap.color
                            : Colors.grey.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
