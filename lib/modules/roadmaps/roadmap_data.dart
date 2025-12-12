import 'package:flutter/material.dart';

class TopicContent {
  final String title;
  final String content;

  const TopicContent({
    required this.title,
    required this.content,
  });
}

class RoadmapStep {
  final String title;
  final String description;
  final String duration;
  final List<TopicContent> topics;
  final List<String> resources;

  const RoadmapStep({
    required this.title,
    required this.description,
    required this.duration,
    required this.topics,
    required this.resources,
  });
}

class TechRoadmap {
  final String title;
  final String description;
  final String category;
  final String duration;
  final IconData icon;
  final Color color;
  final List<RoadmapStep> steps;

  const TechRoadmap({
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.icon,
    required this.color,
    required this.steps,
  });
}

class RoadmapRepository {
  static const List<TechRoadmap> allRoadmaps = [
    // Frontend Development (Detailed)
    TechRoadmap(
      title: 'Frontend Developer',
      description: 'Complete frontend development roadmap from basics to advanced',
      category: 'Web Development',
      duration: '6-9 months',
      icon: Icons.web,
      color: Colors.blue,
      steps: [
        RoadmapStep(
          title: 'Internet & Web Basics',
          description: 'Understand how the internet and web work',
          duration: '1 week',
          topics: [
            TopicContent(
              title: 'How does the internet work?',
              content: 'The internet is a global network of interconnected computers that communicate using standardized protocols. Data travels through routers, switches, and cables (fiber optic, copper) in packets. Learn about IP addresses, routing, and the client-server model.',
            ),
            TopicContent(
              title: 'What is HTTP/HTTPS?',
              content: 'HTTP (HyperText Transfer Protocol) is the foundation of data communication on the web. HTTPS adds encryption via SSL/TLS for secure communication. Understand request/response cycles, status codes (200, 404, 500), and HTTP methods (GET, POST, PUT, DELETE).',
            ),
            TopicContent(
              title: 'DNS and how it works',
              content: 'DNS (Domain Name System) translates human-readable domain names (google.com) into IP addresses (172.217.164.46). Learn about DNS servers, DNS records (A, CNAME, MX), and the DNS resolution process.',
            ),
          ],
          resources: [
            'MDN Web Docs - How the Web Works',
            'CS50 Web Programming',
            'roadmap.sh/frontend',
          ],
        ),
      ],
    ),

    // React Native Developer
    TechRoadmap(
      title: 'React Native Developer',
      description: 'Complete mobile app development with React Native',
      category: 'Mobile Development',
      duration: '6-8 months',
      icon: Icons.phone_android,
      color: Colors.purple,
      steps: [
        RoadmapStep(
          title: 'Prerequisites',
          description: 'Essential knowledge before starting React Native',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'JavaScript ES6+',
              content: 'Master modern JavaScript features essential for React Native: Arrow functions (const add = (a, b) => a + b), destructuring ({name, age} = person), spread operator (...array), template literals (`Hello \${name}`), async/await for promises, import/export modules. Practice with array methods: map(), filter(), reduce(), forEach(). Understand closures, this binding, and prototype inheritance.',
            ),
            TopicContent(
              title: 'React fundamentals',
              content: 'Master React concepts that translate to React Native: Functional components with JSX syntax, props for passing data between components, useState hook for local state management, useEffect for side effects and lifecycle events, conditional rendering with && and ternary operators, list rendering with map(), event handling patterns. Understand component composition, lifting state up, and one-way data flow principles.',
            ),
          ],
          resources: [
            'React Native Documentation',
            'JavaScript.info',
            'React Official Tutorial',
          ],
        ),
      ],
    ),

    // Data Scientist
    TechRoadmap(
      title: 'Data Scientist',
      description: 'Complete data science and machine learning roadmap',
      category: 'Data Science',
      duration: '8-12 months',
      icon: Icons.analytics,
      color: Colors.orange,
      steps: [
        RoadmapStep(
          title: 'Python Programming',
          description: 'Master Python for data science',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Python basics',
              content: 'Master Python fundamentals: Variables and naming conventions, data types (int, float, str, bool, None), control structures (if/elif/else, for/while loops, break/continue), functions (def, parameters, return, *args, **kwargs), classes and objects (init, methods, inheritance), exception handling (try/except/finally), file I/O operations. Follow PEP 8 style guide for clean code. Set up virtual environments with venv, pip, and conda for project isolation.',
            ),
          ],
          resources: [
            'Python.org Tutorial',
            'Automate the Boring Stuff',
            'Python Data Science Handbook',
          ],
        ),
      ],
    ),

    // DevOps Engineer
    TechRoadmap(
      title: 'DevOps Engineer',
      description: 'Complete DevOps and cloud infrastructure roadmap',
      category: 'DevOps',
      duration: '8-10 months',
      icon: Icons.cloud,
      color: Colors.teal,
      steps: [
        RoadmapStep(
          title: 'Linux & Command Line',
          description: 'Master Linux systems and command line',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Linux fundamentals',
              content: 'Master Linux file system hierarchy: / (root), /home (user directories), /etc (configuration), /var (variable data), /usr (user programs), /tmp (temporary files). Understand file permissions: read (r), write (w), execute (x) for owner, group, others. Learn user and group management: useradd, usermod, passwd, su, sudo. Master process management: ps, top, htop, kill, jobs, nohup. Understand system services, daemons, and init systems.',
            ),
          ],
          resources: [
            'Linux Command Line',
            'Ubuntu Server Guide',
            'Red Hat System Administration',
          ],
        ),
      ],
    ),

    // Cybersecurity Specialist
    TechRoadmap(
      title: 'Cybersecurity Specialist',
      description: 'Complete cybersecurity and ethical hacking roadmap',
      category: 'Security',
      duration: '10-12 months',
      icon: Icons.security,
      color: Colors.red,
      steps: [
        RoadmapStep(
          title: 'Security Fundamentals',
          description: 'Core security concepts and principles',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'CIA Triad',
              content: 'Master the CIA Triad fundamentals: Confidentiality (protecting sensitive information from unauthorized access through encryption, access controls, authentication), Integrity (ensuring data accuracy and preventing unauthorized modification through hashing, digital signatures, checksums), Availability (ensuring systems and data are accessible when needed through redundancy, backups, disaster recovery). Apply these principles to different scenarios: databases, networks, applications, cloud services, and physical security.',
            ),
          ],
          resources: [
            'NIST Cybersecurity Framework',
            'CISSP Study Guide',
            'Security+ Training',
          ],
        ),
      ],
    ),

    // Backend Developer
    TechRoadmap(
      title: 'Backend Developer',
      description: 'Complete backend development roadmap',
      category: 'Web Development',
      duration: '7-10 months',
      icon: Icons.dns,
      color: Colors.green,
      steps: [
        RoadmapStep(
          title: 'Internet Basics',
          description: 'Understand internet fundamentals',
          duration: '1 week',
          topics: [
            TopicContent(
              title: 'How does the internet work?',
              content: 'Global network of interconnected computers communicating via protocols. Data travels in packets through routers and switches. Client-server model: clients request, servers respond.',
            ),
          ],
          resources: [
            'MDN HTTP Guide',
            'roadmap.sh/backend',
            'CS50 Network',
          ],
        ),
      ],
    ),

    // Full Stack Developer
    TechRoadmap(
      title: 'Full Stack Developer',
      description: 'Complete full stack web development roadmap',
      category: 'Web Development',
      duration: '10-12 months',
      icon: Icons.layers,
      color: Colors.indigo,
      steps: [
        RoadmapStep(
          title: 'Frontend Foundations',
          description: 'Master frontend technologies',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'HTML5 & Semantic markup',
              content: 'Master semantic HTML5 elements: <header>, <nav>, <main>, <article>, <section>, <aside>, <footer> for proper document structure. Learn accessibility: ARIA attributes (aria-label, aria-describedby, role), proper heading hierarchy (h1-h6), alt text for images, keyboard navigation, screen reader compatibility. Understand form elements: input types (email, tel, date), validation attributes (required, pattern), fieldset and legend for grouping.',
            ),
          ],
          resources: [
            'MDN Web Docs',
            'React Documentation',
            'CSS-Tricks',
          ],
        ),
      ],
    ),

    // Machine Learning Engineer
    TechRoadmap(
      title: 'Machine Learning Engineer',
      description: 'Complete ML engineering and AI development roadmap',
      category: 'AI & Machine Learning',
      duration: '12-15 months',
      icon: Icons.psychology,
      color: Colors.deepPurple,
      steps: [
        RoadmapStep(
          title: 'Mathematics & Statistics',
          description: 'Mathematical foundations for ML',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'Linear algebra',
              content: 'Master vector operations: addition, scalar multiplication, dot product (similarity measure), cross product, vector norms (L1, L2). Learn matrix operations: multiplication, transpose, inverse, determinant, rank. Understand eigenvalues and eigenvectors (PCA, dimensionality reduction), matrix decompositions (LU, QR, SVD for recommendation systems), vector spaces and linear transformations. Apply to ML: feature vectors, weight matrices in neural networks, covariance matrices.',
            ),
          ],
          resources: [
            '3Blue1Brown Linear Algebra',
            'Khan Academy Statistics',
            'Mathematics for Machine Learning',
          ],
        ),
      ],
    ),

    // Cloud Engineer
    TechRoadmap(
      title: 'Cloud Engineer',
      description: 'Complete cloud infrastructure and services roadmap',
      category: 'Cloud Computing',
      duration: '8-10 months',
      icon: Icons.cloud_queue,
      color: Colors.lightBlue,
      steps: [
        RoadmapStep(
          title: 'Cloud Fundamentals',
          description: 'Understanding cloud computing basics',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Cloud service models',
              content: 'IaaS (Infrastructure as a Service), PaaS (Platform as a Service), SaaS (Software as a Service). Understanding when to use each model.',
            ),
          ],
          resources: [
            'AWS Cloud Practitioner',
            'Azure Fundamentals',
            'Google Cloud Basics',
          ],
        ),
      ],
    ),

    // Game Developer
    TechRoadmap(
      title: 'Game Developer',
      description: 'Complete game development roadmap',
      category: 'Game Development',
      duration: '10-12 months',
      icon: Icons.sports_esports,
      color: Colors.amber,
      steps: [
        RoadmapStep(
          title: 'Game Development Basics',
          description: 'Fundamental concepts and tools',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Game engines',
              content: 'Unity (C#), Unreal Engine (C++/Blueprints), Godot (GDScript/C#). Choose based on target platform, team size, and project scope.',
            ),
          ],
          resources: [
            'Unity Learn',
            'Unreal Engine Documentation',
            'Game Programming Patterns',
          ],
        ),
      ],
    ),

    // Blockchain Developer
    TechRoadmap(
      title: 'Blockchain Developer',
      description: 'Complete blockchain and Web3 development roadmap',
      category: 'Blockchain',
      duration: '8-10 months',
      icon: Icons.link,
      color: Colors.brown,
      steps: [
        RoadmapStep(
          title: 'Blockchain Fundamentals',
          description: 'Understanding blockchain technology',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Blockchain basics',
              content: 'Distributed ledger, blocks, transactions, hashing. Consensus mechanisms: Proof of Work, Proof of Stake. Immutability and transparency.',
            ),
          ],
          resources: [
            'Mastering Bitcoin',
            'Ethereum Whitepaper',
            'Blockchain Basics Course',
          ],
        ),
      ],
    ),
  ];

  // Helper methods for filtering and searching
  static List<TechRoadmap> getRoadmapsByCategory(String category) {
    return allRoadmaps.where((roadmap) => roadmap.category == category).toList();
  }

  static List<String> getAllCategories() {
    return allRoadmaps.map((roadmap) => roadmap.category).toSet().toList();
  }

  static List<TechRoadmap> searchRoadmaps(String query) {
    query = query.toLowerCase();
    return allRoadmaps.where((roadmap) {
      return roadmap.title.toLowerCase().contains(query) ||
             roadmap.description.toLowerCase().contains(query) ||
             roadmap.category.toLowerCase().contains(query);
    }).toList();
  }

  static TechRoadmap? getRoadmapById(String title) {
    try {
      return allRoadmaps.firstWhere((roadmap) => roadmap.title == title);
    } catch (e) {
      return null;
    }
  }
}