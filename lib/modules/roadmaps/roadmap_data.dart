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
    // Frontend Developer
    TechRoadmap(
      title: 'Frontend Developer',
      description: 'Master the art of creating beautiful, interactive web interfaces.',
      category: 'Web Development',
      duration: '6-9 months',
      icon: Icons.web,
      color: Colors.blue,
      steps: [
        RoadmapStep(
          title: 'Internet & Web Fundamentals',
          description: 'Understanding the underlying infrastructure of the web.',
          duration: '1-2 weeks',
          topics: [
            TopicContent(
              title: 'How the Internet Works',
              content: 'The internet is a vast global network. Learn about the TCP/IP model, packet switching, routers, ISPs, and the physical infrastructure (cables, satellites) that connects the world.',
            ),
            TopicContent(
              title: 'HTTP/HTTPS & Protocols',
              content: 'Deep dive into HyperText Transfer Protocol. Understand methods (GET, POST, PUT, DELETE), status codes (200s, 300s, 400s, 500s), headers, cookies, and the handshake process of SSL/TLS for security.',
            ),
            TopicContent(
              title: 'DNS & Domains',
              content: 'The phonebook of the internet. Learn how Domain Name Systems resolve human-readable URLs into IP addresses, record types (A, CNAME, MX), and propagation.',
            ),
             TopicContent(
              title: 'Browsers & Rendering',
              content: 'How browsers work: The DOM (Document Object Model) tree, CSSOM, Render Tree, Layout, and Paint. Understand the V8 engine (Chrome) and SpiderMonkey (Firefox).',
            ),
          ],
          resources: [
            'MDN Web Docs - How the Web Works',
            'CS50 Computer Science Introduction',
            'High Performance Browser Networking',
          ],
        ),
        RoadmapStep(
          title: 'HTML & Semantic Web',
          description: 'The skeleton of all web pages.',
          duration: '2 weeks',
          topics: [
            TopicContent(
              title: 'Semantic HTML5',
              content: 'Beyond <div>. Using <header>, <nav>, <main>, <article>, <section>, <aside>, <footer> for better SEO and accessibility. Understanding the document outline.',
            ),
            TopicContent(
              title: 'Forms & Validation',
              content: 'Creating robust forms with proper input types, labels, and native HTML5 validation attributes (required, pattern, min/max). Handling form submission and accessibility.',
            ),
            TopicContent(
              title: 'SEO & Accessibility (A11y)',
              content: 'Writing code for everyone and machines. Meta tags, Open Graph, ARIA roles, landmarks, tab limits, and ensuring screen reader compatibility.',
            ),
          ],
          resources: [
            'W3C HTML Standard',
            'WebAIM Accessibility Guide',
          ],
        ),
        RoadmapStep(
          title: 'CSS & Modern Layouts',
          description: 'Styling and responsive design mastery.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'The Box Model & Selectors',
              content: 'Mastering margins, borders, padding, and content. Understanding specificity wars, pseudo-classes (:hover, :focus), and pseudo-elements (::before, ::after).',
            ),
            TopicContent(
              title: 'Flexbox & Grid',
              content: 'Modern layout systems. Flexbox for 1D layouts (alignment, distribution) and CSS Grid for complex 2D layouts (areas, tracks). When to use which?',
            ),
            TopicContent(
              title: 'Responsive Design',
              content: 'Mobile-first approach. Media queries (@media), fluid typography (rem, em, vw), and responsive images (srcset, sizes).',
            ),
             TopicContent(
              title: 'Modern CSS Features',
              content: 'CSS Variables (Custom Properties), calc(), clamp(), transitions, animations, and transforms3D.',
            ),
          ],
          resources: [
            'CSS-Tricks Flexbox Guide',
            'CSS Grid Garden',
            'Smashing Magazine CSS',
          ],
        ),
        RoadmapStep(
          title: 'JavaScript Deep Dive',
          description: 'The programming language of the web.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'ES6+ Syntax',
              content: 'Arrow functions, destructuring, spread/rest operators, template literals, default parameters, and modules (import/export).',
            ),
            TopicContent(
              title: 'Async Programming',
              content: 'The Event Loop unraveled. Callbacks, Promises, async/await pattern, and error handling with try/catch. Microtasks vs Macrotasks.',
            ),
            TopicContent(
              title: 'DOM Manipulation',
              content: 'Selecting elements, traversing the tree, adding/removing nodes, and handling events (bubbling, capturing, delegation) efficiently.',
            ),
             TopicContent(
              title: 'Data Structures',
              content: 'Working with Arrays (map, filter, reduce), Objects, Maps, and Sets. Understanding reference vs value types.',
            ),
          ],
          resources: [
            'You Don\'t Know JS (Book Series)',
            'JavaScript.info',
            'Eloquent JavaScript',
          ],
        ),
        RoadmapStep(
          title: 'Frontend Frameworks',
          description: 'Building complex apps efficiently.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'React.js Ecosystem',
              content: 'Components, Props, Hooks (useState, useEffect, useMemo, useCallback), Virtual DOM, and unidirectional data flow. React Router for navigation.',
            ),
            TopicContent(
              title: 'State Management',
              content: 'Prop drilling vs Context API vs Global State libraries (Redux Toolkit, Zustand, Recoil). When to use which?',
            ),
            TopicContent(
              title: 'Framework Concepts',
              content: 'Understanding Single Page Applications (SPA), client-side routing, and component lifecycles.',
            ),
          ],
          resources: [
            'React Official Docs',
            'Redux Toolkit Essentials',
            'Kent C. Dodds Blog',
          ],
        ),
         RoadmapStep(
          title: 'Modern Ecosystem',
          description: 'Tools that power modern development.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Package Managers',
              content: 'npm vs yarn vs pnpm. Understanding package.json, semantic versioning, and locking dependencies.',
            ),
            TopicContent(
              title: 'Build Tools',
              content: 'Vite (fast dev server), Webpack (bundling, loaders, plugins), Babel (transpiling). ESLint and Prettier for code quality.',
            ),
            TopicContent(
              title: 'Git Version Control',
              content: 'Branching strategies (Git Flow), pull requests, merge conflicts, and conventional commits.',
            ),
          ],
          resources: [
            'Vite Documentation',
            'Pro Git Book',
          ],
        ),
      ],
    ),

    // Backend Developer
    TechRoadmap(
      title: 'Backend Developer',
      description: 'Architecting the server-side, databases, and APIs.',
      category: 'Web Development',
      duration: '7-10 months',
      icon: Icons.dns,
      color: Colors.green,
      steps: [
        RoadmapStep(
          title: 'OS & Server Basics',
          description: 'Linux and Runtime Environments.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Linux Command Line',
              content: 'Bash scripting, file permissions (chmod/chown), process management (ps, kill), and SSH for remote server access.',
            ),
            TopicContent(
              title: 'Process & Threads',
              content: 'Understanding concurrency, parallelism, blocking vs non-blocking I/O, and memory management basics.',
            ),
          ],
          resources: [
            'Linux Command Line Adventure',
            'Operating Systems Concepts',
          ],
        ),
        RoadmapStep(
          title: 'Programming Languages',
          description: 'Choosing a backend weapon.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Node.js (JavaScript)',
              content: 'Event-driven, non-blocking I/O model. Express.js or NestJS frameworks. Great for real-time apps.',
            ),
            TopicContent(
              title: 'Python',
              content: 'Django (batteries included) or FastAPI (modern, fast). Great for AI/ML integration and rapid development.',
            ),
             TopicContent(
              title: 'Go / Rust',
              content: 'High-performance systems. Go for microservices, Rust for safety and speed.',
            ),
          ],
          resources: [
            'Node.js Design Patterns',
            'FastAPI Documentation',
          ],
        ),
        RoadmapStep(
          title: 'Databases',
          description: 'Storing and managing data.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Relational (SQL)',
              content: 'PostgreSQL/MySQL. ACID compliance, normalization (1NF-3NF), complex joins, indexing strategies, and transactions.',
            ),
            TopicContent(
              title: 'NoSQL',
              content: 'MongoDB (Document), Redis (Key-Value/Caching), Cassandra (Column). Understanding CAP theorem and eventual consistency.',
            ),
             TopicContent(
              title: 'ORMs vs Query Builders',
              content: 'Prisma, TypeORM, Hibernate. Pros and cons of abstraction layers.',
            ),
          ],
          resources: [
            'Use The Index, Luke!',
            'PostgreSQL Official Docs',
          ],
        ),
        RoadmapStep(
          title: 'API Design',
          description: 'Communication interfaces.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'RESTful Architecture',
              content: 'Resources, statelessness, HATEOAS, HTTP verbs, status codes, and versioning strategies.',
            ),
            TopicContent(
              title: 'GraphQL',
              content: 'Schemas, types, queries, mutations, resolvers. Avoiding N+1 problem. Apollo Server.',
            ),
            TopicContent(
              title: 'Authentication & Authorization',
              content: 'JWT (JSON Web Tokens), OAuth2, OIDC, Session-based auth. RBAC (Role-Based Access Control).',
            ),
          ],
          resources: [
            'REST API Design Rulebook',
            'GraphQL.org',
          ],
        ),
         RoadmapStep(
          title: 'System Design & DevOps',
          description: 'Scaling and deploying.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Caching Strategies',
              content: 'Client-side, CDN, Load Balancer, Server-side (Redis/Memcached). Cache-aside vs Write-through.',
            ),
            TopicContent(
              title: 'Containerization',
              content: 'Docker images, containers, volumes, networking. Docker Compose for dev environments.',
            ),
             TopicContent(
              title: 'CI/CD Pipelines',
              content: 'Automated testing and deployment using GitHub Actions or GitLab CI.',
            ),
          ],
          resources: [
            'System Design Primer',
            'Docker Documentation',
          ],
        ),
      ],
    ),

    // Full Stack Developer
    TechRoadmap(
      title: 'Full Stack Developer',
      description: 'The complete package: Frontend, Backend, and DevOps.',
      category: 'Web Development',
      duration: '10-12 months',
      icon: Icons.layers,
      color: Colors.indigo,
      steps: [
        RoadmapStep(
          title: 'The T-Shaped Skillset',
          description: 'Breadth across the stack, depth in one area.',
          duration: 'Ongoing',
          topics: [
            TopicContent(
              title: 'Balancing the Stack',
              content: 'Understanding how frontend decisions impact backend load and vice versa. Managing shared interfaces and types.',
            ),
          ],
          resources: [],
        ),
        RoadmapStep(
          title: 'Integration & Architecture',
          description: 'Connecting the pieces.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'API Integration',
              content: 'Consuming your own APIs. Error handling patterns, loading states, and data fetching (React Query/SWR).',
            ),
             TopicContent(
              title: 'Monorepos',
              content: 'Managing frontend and backend in one repo with tools like TurboRepo or Nx. Shared packages (types, utils).',
            ),
          ],
          resources: ['Monorepo Tools Guide'],
        ),
         RoadmapStep(
          title: 'Full Stack Frameworks',
          description: 'The meta-frameworks era.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Next.js / Nuxt',
              content: 'Server-Side Rendering (SSR), Static Site Generation (SSG), API Routes, Middleware, and Edge Functions.',
            ),
            TopicContent(
              title: 'Server Actions',
              content: 'Blurring the line between client and server code securely.',
            ),
          ],
          resources: ['Next.js Documentation'],
        ),
      ],
    ),

    // React Native Developer
    TechRoadmap(
      title: 'React Native Developer',
      description: 'Cross-platform mobile apps with React.',
      category: 'Mobile Development',
      duration: '6-8 months',
      icon: Icons.phone_android,
      color: Colors.purple,
      steps: [
        RoadmapStep(
          title: 'React Native Core',
          description: 'It is not the web.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Native Components',
              content: 'View, Text, Image, ScrollView, FlatList. Differences from HTML tags. Styling with Flexbox (defaults to column).',
            ),
            TopicContent(
              title: 'Metro Bundler',
              content: 'How the JS bundle is created and served to the simulator/device.',
            ),
          ],
          resources: ['React Native Docs'],
        ),
        RoadmapStep(
          title: 'Navigation & Architecture',
          description: 'Structuring mobile apps.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'React Navigation',
              content: 'Stack, Tab, Drawer navigators. Param passing and deep linking.',
            ),
            TopicContent(
              title: 'Native Modules',
              content: 'Bridging JavaScript to Native (Swift/Kotlin) code for platform-specific features.',
            ),
          ],
          resources: ['React Navigation Docs'],
        ),
        RoadmapStep(
          title: 'Performance',
          description: 'Hitting 60 FPS.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'JS Thread vs UI Thread',
              content: 'Keeping the bridge uncongested. Understanding frame drops.',
            ),
            TopicContent(
              title: 'Reanimated',
              content: 'Running animations on the UI thread for buttery smooth interactions.',
            ),
          ],
          resources: ['React Native Performance Guide'],
        ),
      ],
    ),

    // Flutter Developer
    TechRoadmap(
      title: 'Flutter Developer',
      description: 'Building beautiful native apps with Dart.',
      category: 'Mobile Development',
      duration: '4-6 months',
      icon: Icons.flutter_dash,
      color: Colors.blueAccent,
      steps: [
        RoadmapStep(
          title: 'Dart Mastery',
          description: 'The language engine.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Type System',
              content: 'Sound null safety, extensions, mixins, and generics.',
            ),
             TopicContent(
              title: 'Async Dart',
              content: 'Features, Streams, Isolates (concurrency). Event loop mechanics.',
            ),
          ],
          resources: ['Dart Language Guided Tour'],
        ),
        RoadmapStep(
          title: 'Flutter Framework',
          description: 'Widget composition.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Widget Tree',
              content: 'Everything is a widget. Element Tree and RenderObject Tree concepts for performance.',
            ),
            TopicContent(
              title: 'Layout',
              content: 'Constraint system: "Constraints go down. Sizes go up. Parent sets position."',
            ),
          ],
          resources: ['Flutter Internals'],
        ),
        RoadmapStep(
          title: 'Advanced State Management',
          description: 'Scalable app architecture.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Bloc / Cubit',
              content: 'Event-driven state management. Separating business logic from UI.',
            ),
             TopicContent(
              title: 'Riverpod',
              content: 'Compile-safe dependency injection and state management. Providers and modifiers.',
            ),
          ],
          resources: ['Bloc Library Docs', 'Riverpod Docs'],
        ),
      ],
    ),

    // DevOps Engineer
    TechRoadmap(
      title: 'DevOps Engineer',
      description: 'Bridging development and operations.',
      category: 'DevOps',
      duration: '8-10 months',
      icon: Icons.cloud,
      color: Colors.teal,
      steps: [
        RoadmapStep(
          title: 'Automation & Scripting',
          description: 'Automate everything.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Python for DevOps',
              content: 'Writing automation scripts, interacting with cloud APIs (boto3), and data processing.',
            ),
            TopicContent(
              title: 'Infrastructure as Code (IaC)',
              content: 'Terraform or OpenTofu. Declarative infrastructure management. State logic.',
            ),
          ],
          resources: ['Terraform Up & Running'],
        ),
        RoadmapStep(
          title: 'Container Orchestration',
          description: 'Managing fleets of containers.',
          duration: '5-6 weeks',
          topics: [
            TopicContent(
              title: 'Kubernetes (K8s) Architecture',
              content: 'Control Plane, Nodes, Pods, Services, Ingress, ConfigMaps, and Secrets.',
            ),
            TopicContent(
              title: 'Helm Charts',
              content: 'Package manager for K8s. Templating manifests.',
            ),
          ],
          resources: ['Kubernetes The Hard Way'],
        ),
        RoadmapStep(
          title: 'Observability',
          description: 'Logs, Metrics, and Traces.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'ELK / EFK Stack',
              content: 'Elasticsearch, Logstash/Fluentd, Kibana for logging.',
            ),
            TopicContent(
              title: 'Prometheus & Grafana',
              content: 'Time-series metrics collection and visualization dashboards.',
            ),
          ],
          resources: ['Prometheus Specs'],
        ),
      ],
    ),

    // Machine Learning Engineer
    TechRoadmap(
      title: 'Machine Learning Engineer',
      description: 'Building intelligent systems.',
      category: 'AI & Machine Learning',
      duration: '12-15 months',
      icon: Icons.psychology,
      color: Colors.deepPurple,
      steps: [
        RoadmapStep(
          title: 'Data Engineering',
          description: 'Getting data ready.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Data Pipelines',
              content: 'ETL (Extract, Transform, Load) processes. Apache Airflow / Prefect.',
            ),
            TopicContent(
              title: 'Feature Engineering',
              content: 'Encoding categorical data, normalization, handling missing values, and dimensionality reduction.',
            ),
          ],
          resources: ['Data Engineering Cookbook'],
        ),
        RoadmapStep(
          title: 'Model Architectures',
          description: 'Choosing the right brain.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Transformers',
              content: 'Attention mechanism. BERT, GPT architectures. Foundation of modern NLP.',
            ),
            TopicContent(
              title: 'Computer Vision',
              content: 'CNNs (ResNet, EfficientNet), Object Detection (YOLO), Segmentation.',
            ),
          ],
          resources: ['Fast.ai Deep Learning'],
        ),
        RoadmapStep(
          title: 'MLOps & Deployment',
          description: 'From notebook to production.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Model Serving',
              content: 'TF Serving, TorchServe, Triton Inference Server. ONNX runtime.',
            ),
            TopicContent(
              title: 'Experiment Tracking',
              content: 'MLflow, Weights & Biases. Versioning data and models.',
            ),
          ],
          resources: ['MLOps Community'],
        ),
      ],
    ),

    // NEW ROADMAPS START HERE

    // Data Scientist
    TechRoadmap(
      title: 'Data Scientist',
      description: 'Extracting insights from data.',
      category: 'Data Science',
      duration: '8-12 months',
      icon: Icons.analytics,
      color: Colors.orange,
      steps: [
        RoadmapStep(
          title: 'Mathematical Foundations',
          description: 'The language of data.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Statistics & Probability',
              content: 'Distributions (Normal, Binomial), Hypothesis testing (p-values, A/B testing), Bayesian inference.',
            ),
            TopicContent(
              title: 'Linear Algebra',
              content: 'Vectors, Matrices, Eigenvalues - essential for understanding ML algorithms.',
            ),
          ],
          resources: ['Khan Academy Statistics'],
        ),
        RoadmapStep(
          title: 'Data Visualization',
          description: 'Storytelling with data.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Libraries',
              content: 'Matplotlib, Seaborn, Plotly (interactive), Tableau/PowerBI (business intelligence).',
            ),
            TopicContent(
              title: 'Principles',
              content: 'Color theory, chart selection (scatter vs bar vs heatmaps), and avoiding misleading visuals.',
            ),
          ],
          resources: ['Storytelling with Data'],
        ),
         RoadmapStep(
          title: 'Machine Learning',
          description: 'Predictive modeling.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Supervised Learning',
              content: 'Regression (Linear, Logistic), Classification (Decision Trees, Random Forests, SVM).',
            ),
            TopicContent(
              title: 'Unsupervised Learning',
              content: 'Clustering (K-Means, DBSCAN), Dimensionality Reduction (PCA).',
            ),
          ],
          resources: ['Scikit-Learn User Guide'],
        ),
      ],
    ),

    // Cybersecurity Specialist
    TechRoadmap(
      title: 'Cybersecurity Specialist',
      description: 'Protecting digital assets and infrastructure.',
      category: 'Security',
      duration: '10-12 months',
      icon: Icons.security,
      color: Colors.red,
      steps: [
        RoadmapStep(
          title: 'Networking Security',
          description: 'Securing the pipes.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'OSI Model Security',
              content: 'Attacks and defenses at each layer. ARP spoofing, Man-in-the-Middle, DDoS.',
            ),
             TopicContent(
              title: 'Firewalls & IDS/IPS',
              content: 'Configuring rules, monitoring traffic patterns, and intrusion detection.',
            ),
          ],
          resources: ['CompTIA Network+'],
        ),
        RoadmapStep(
          title: 'Ethical Hacking',
          description: 'Thinking like an attacker.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Reconnaissance',
              content: 'OSINT (Open Source Intelligence), Nmap scanning, Shodan.',
            ),
            TopicContent(
              title: 'Web App Pentesting',
              content: 'OWASP Top 10 deep dive. SQL Injection, XSS, CSRF, IDOR attacks.',
            ),
             TopicContent(
              title: 'Metasploit',
              content: 'Using frameworks for exploit development and payload delivery.',
            ),
          ],
          resources: ['The Web Application Hacker\'s Handbook'],
        ),
        RoadmapStep(
          title: 'Cryptography',
          description: 'The science of secrets.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Encryption Standards',
              content: 'Symmetric (AES) vs Asymmetric (RSA, ECC). Hashing (SHA-256).',
            ),
            TopicContent(
              title: 'PKI',
              content: 'Public Key Infrastructure. Certificates, X.509, and Chain of Trust.',
            ),
          ],
          resources: ['Practical Cryptography'],
        ),
      ],
    ),

    // Cloud Engineer
    TechRoadmap(
      title: 'Cloud Engineer',
      description: 'Architecting scalable cloud solutions.',
      category: 'Cloud Computing',
      duration: '8-10 months',
      icon: Icons.cloud_queue,
      color: Colors.lightBlue,
      steps: [
        RoadmapStep(
          title: 'AWS / Azure / GCP',
          description: 'Mastering a provider.',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'Compute',
              content: 'AWS EC2, Lambda, ECS. Azure VMs, Functions. GCP Compute Engine.',
            ),
            TopicContent(
              title: 'Storage',
              content: 'Object storage (S3), Block storage (EBS), File storage (EFS). Lifecycle policies.',
            ),
             TopicContent(
              title: 'Networking',
              content: 'VPC design, Subnets, Route Tables, Internet Gateways, Peering.',
            ),
          ],
          resources: ['AWS Solutions Architect Study Guide'],
        ),
        RoadmapStep(
          title: 'Serverless Architecture',
          description: 'Focus on code, not servers.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Event-Driven Patterns',
              content: 'Triggering functions from queues (SQS), streams (Kinesis), or API Gateway.',
            ),
            TopicContent(
              title: 'Cold Starts & Limits',
              content: 'Understanding execution limits, timeouts, and optimization strategies.',
            ),
          ],
          resources: ['Serverless Framework'],
        ),
      ],
    ),

    // Game Developer
    TechRoadmap(
      title: 'Game Developer',
      description: 'Creating immersive virtual worlds.',
      category: 'Game Development',
      duration: '10-12 months',
      icon: Icons.sports_esports,
      color: Colors.amber,
      steps: [
        RoadmapStep(
          title: 'Game Engines',
          description: 'The tools of the trade.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Unity (C#)',
              content: 'GameObjects, Components, Prefabs, Physics Engine, and Asset pipeline.',
            ),
            TopicContent(
              title: 'Unreal Engine (C++ / Blueprints)',
              content: 'Actors, Pawns, Material Editor, Niagara (VFX), and Lumen/Nanite rendering.',
            ),
          ],
          resources: ['Unity Learn', 'Unreal Online Learning'],
        ),
        RoadmapStep(
          title: 'Game Mathematics',
          description: 'Physics and transforms.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: '3D Math',
              content: 'Vectors, Dot/Cross products (lighting/facing), Quaternions (rotation without gimbal lock).',
            ),
            TopicContent(
              title: 'Physics',
              content: 'Collision detection (Raycasting, AABB, Mesh colliders), Rigidbodies, Forces.',
            ),
          ],
          resources: ['3D Math Primer for Graphics'],
        ),
        RoadmapStep(
          title: 'Game Design Patterns',
          description: 'Architecting maintainable games.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Pattern Library',
              content: 'Game Loop, Object Pool (memory management), State Machine, Component pattern, Command pattern (input).',
            ),
          ],
          resources: ['Game Programming Patterns'],
        ),
      ],
    ),

    // Blockchain Developer
    TechRoadmap(
      title: 'Blockchain Developer',
      description: 'Decentralized applications and Web3.',
      category: 'Blockchain',
      duration: '8-10 months',
      icon: Icons.link,
      color: Colors.brown,
      steps: [
        RoadmapStep(
          title: 'Smart Contracts',
          description: 'Code on the chain.',
          duration: '5-6 weeks',
          topics: [
            TopicContent(
              title: 'Solidity',
              content: 'Contract structure, mappings, modifiers, payable functions, inheritance. EVM (Ethereum Virtual Machine).',
            ),
             TopicContent(
              title: 'Security',
              content: 'Reentrancy attacks, Overflow/Underflow, Gas optimization, Checking-Effects-Interaction pattern.',
            ),
          ],
          resources: ['CryptoZombies', 'Solidity Documentation'],
        ),
        RoadmapStep(
          title: 'Web3 Development',
          description: 'Connecting frontend to blockchain.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Libraries',
              content: 'Ethers.js / Web3.js. Connecting wallets (MetaMask), signing transactions, reading contract state.',
            ),
            TopicContent(
              title: 'Indexing',
              content: 'Using The Graph protocol to query blockchain data efficiently utilizing subgraphs.',
            ),
          ],
          resources: ['Scaffold-ETH'],
        ),
        RoadmapStep(
          title: 'DeFi & Protocols',
          description: 'Financial legos.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Concepts',
              content: 'Liquidity Pools, AMMs (Automated Market Makers) like Uniswap, Yield Farming, Flash Loans.',
            ),
            TopicContent(
              title: 'Token Standards',
              content: 'ERC-20 (Fungible), ERC-721 (NFT), ERC-1155 (Multi-token).',
            ),
          ],
          resources: ['Mastering Ethereum'],
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