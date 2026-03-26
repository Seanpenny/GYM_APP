import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';

// Lime green color matching the auth screen
const Color limeGreen = Color(0xFF39FF14);

class AiAssistantView extends StatefulWidget {
  const AiAssistantView({super.key});

  @override
  State<AiAssistantView> createState() => _AiAssistantViewState();
}

class _AiAssistantViewState extends State<AiAssistantView>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0; // 0: Welcome, 1-6: Questions, 7: Results
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Circular carousel state
  String? _selectedFeature; // null = carousel view, otherwise feature name
  double _carouselRotation = 0.0; // Rotation angle in radians
  double _previousAngle = 0.0;
  bool _showChatbot = false;

  // Feature definitions - All AI-Powered
  final List<Map<String, dynamic>> _features = [
    {
      'id': 'workout',
      'title': 'AI Custom Workout',
      'icon': Icons.fitness_center_rounded,
      'color': limeGreen,
      'description': 'AI-powered personalized workout plans',
    },
    {
      'id': 'progress',
      'title': 'AI Progress Analysis',
      'icon': Icons.camera_alt_rounded,
      'color': limeGreen,
      'description': 'AI analyzes your progress photos',
    },
    {
      'id': 'form',
      'title': 'AI Form Checker',
      'icon': Icons.video_camera_back_rounded,
      'color': limeGreen,
      'description': 'AI-powered exercise form analysis',
    },
    {
      'id': 'rest',
      'title': 'AI Rest Day Coach',
      'icon': Icons.bedtime_rounded,
      'color': limeGreen,
      'description': 'AI recommends optimal rest activities',
    },
    {
      'id': 'injury',
      'title': 'AI Injury Prevention',
      'icon': Icons.medical_services_rounded,
      'color': limeGreen,
      'description': 'AI-powered injury prevention tips',
    },
  ];

  // Form data
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedMuscleGroup;
  String? _selectedIntensity;
  String? _selectedDuration;
  String? _selectedBreakFrequency;

  // Workout result
  Map<String, dynamic>? _workoutPlan;

  final List<String> _muscleGroups = [
    'Full Body',
    'Upper Body',
    'Lower Body',
    'Chest & Triceps',
    'Back & Biceps',
    'Legs & Glutes',
    'Core & Abs',
    'Cardio',
  ];

  final List<String> _intensityLevels = ['Easy', 'Medium', 'Hard'];
  final List<String> _durations = [
    '15 minutes',
    '30 minutes',
    '45 minutes',
    '60 minutes',
  ];
  final List<String> _breakFrequencies = [
    'No breaks',
    '30 seconds between exercises',
    '1 minute between exercises',
    '2 minutes between exercises',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _ageController.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Move from welcome to first question
      setState(() => _currentStep = 1);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentStep >= 1 && _currentStep < 6) {
      // Validate current step before proceeding
      if (_validateCurrentStep()) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentStep == 6) {
      // Last question - generate workout
      if (_validateCurrentStep()) {
        _generateWorkout();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentStep == 1) {
      setState(() => _currentStep = 0);
      _pageController.jumpToPage(0);
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1:
        if (_weightController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your weight')),
          );
          return false;
        }
        return true;
      case 2:
        if (_ageController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your age')),
          );
          return false;
        }
        return true;
      case 3:
        if (_selectedMuscleGroup == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a muscle group')),
          );
          return false;
        }
        return true;
      case 4:
        if (_selectedIntensity == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select intensity level')),
          );
          return false;
        }
        return true;
      case 5:
        if (_selectedDuration == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select workout duration')),
          );
          return false;
        }
        return true;
      case 6:
        if (_selectedBreakFrequency == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select break frequency')),
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _generateWorkout() {
    // Mock AI workout generation
    final age = int.tryParse(_ageController.text) ?? 30;
    final duration = _selectedDuration ?? '30 minutes';
    final durationMinutes = int.tryParse(duration.split(' ').first) ?? 30;

    // Generate exercises based on selections
    final exercises = _generateExercises(
      muscleGroup: _selectedMuscleGroup!,
      intensity: _selectedIntensity!,
      duration: durationMinutes,
      age: age,
    );

    setState(() {
      _workoutPlan = {
        'exercises': exercises,
        'totalDuration': duration,
        'startTime': DateTime.now(),
        'muscleGroup': _selectedMuscleGroup,
        'intensity': _selectedIntensity,
        'breakFrequency': _selectedBreakFrequency,
        'recommendations': _getRecommendations(age, _selectedIntensity!),
      };
      _currentStep = 7;
    });

    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  List<Map<String, dynamic>> _generateExercises({
    required String muscleGroup,
    required String intensity,
    required int duration,
    required int age,
  }) {
    // Mock exercise database
    final allExercises = {
      'Full Body': [
        {
          'name': 'Jumping Jacks',
          'sets': 3,
          'reps': '20',
          'rest': '30s',
          'video':
              'https://www.youtube.com/results?search_query=jumping+jacks+exercise',
        },
        {
          'name': 'Push-ups',
          'sets': 3,
          'reps': '10-15',
          'rest': '45s',
          'video': 'https://www.youtube.com/results?search_query=push+ups+form',
        },
        {
          'name': 'Squats',
          'sets': 3,
          'reps': '15',
          'rest': '45s',
          'video': 'https://www.youtube.com/results?search_query=squats+form',
        },
        {
          'name': 'Plank',
          'sets': 3,
          'reps': '30-60s',
          'rest': '30s',
          'video':
              'https://www.youtube.com/results?search_query=plank+exercise',
        },
        {
          'name': 'Lunges',
          'sets': 3,
          'reps': '12 each leg',
          'rest': '45s',
          'video':
              'https://www.youtube.com/results?search_query=lunges+exercise',
        },
      ],
      'Upper Body': [
        {
          'name': 'Push-ups',
          'sets': 4,
          'reps': '12-15',
          'rest': '60s',
          'video': 'https://www.youtube.com/results?search_query=push+ups+form',
        },
        {
          'name': 'Dumbbell Rows',
          'sets': 3,
          'reps': '12',
          'rest': '60s',
          'video': 'https://www.youtube.com/results?search_query=dumbbell+rows',
        },
        {
          'name': 'Shoulder Press',
          'sets': 3,
          'reps': '10-12',
          'rest': '60s',
          'video':
              'https://www.youtube.com/results?search_query=shoulder+press',
        },
        {
          'name': 'Tricep Dips',
          'sets': 3,
          'reps': '10-12',
          'rest': '45s',
          'video': 'https://www.youtube.com/results?search_query=tricep+dips',
        },
      ],
      'Lower Body': [
        {
          'name': 'Squats',
          'sets': 4,
          'reps': '15',
          'rest': '60s',
          'video': 'https://www.youtube.com/results?search_query=squats+form',
        },
        {
          'name': 'Lunges',
          'sets': 3,
          'reps': '12 each leg',
          'rest': '60s',
          'video':
              'https://www.youtube.com/results?search_query=lunges+exercise',
        },
        {
          'name': 'Deadlifts',
          'sets': 3,
          'reps': '10',
          'rest': '90s',
          'video': 'https://www.youtube.com/results?search_query=deadlift+form',
        },
        {
          'name': 'Leg Press',
          'sets': 3,
          'reps': '12',
          'rest': '60s',
          'video': 'https://www.youtube.com/results?search_query=leg+press',
        },
      ],
      'Chest & Triceps': [
        {
          'name': 'Bench Press',
          'sets': 4,
          'reps': '8-10',
          'rest': '90s',
          'video':
              'https://www.youtube.com/results?search_query=bench+press+form',
        },
        {
          'name': 'Incline Dumbbell Press',
          'sets': 3,
          'reps': '10-12',
          'rest': '60s',
          'video':
              'https://www.youtube.com/results?search_query=incline+dumbbell+press',
        },
        {
          'name': 'Cable Flyes',
          'sets': 3,
          'reps': '12',
          'rest': '45s',
          'video': 'https://www.youtube.com/results?search_query=cable+flyes',
        },
        {
          'name': 'Tricep Pushdowns',
          'sets': 3,
          'reps': '12-15',
          'rest': '45s',
          'video':
              'https://www.youtube.com/results?search_query=tricep+pushdowns',
        },
      ],
      'Back & Biceps': [
        {
          'name': 'Pull-ups',
          'sets': 3,
          'reps': '8-10',
          'rest': '90s',
          'video': 'https://www.youtube.com/results?search_query=pull+ups+form',
        },
        {
          'name': 'Barbell Rows',
          'sets': 4,
          'reps': '10-12',
          'rest': '60s',
          'video': 'https://www.youtube.com/results?search_query=barbell+rows',
        },
        {
          'name': 'Bicep Curls',
          'sets': 3,
          'reps': '12-15',
          'rest': '45s',
          'video': 'https://www.youtube.com/results?search_query=bicep+curls',
        },
        {
          'name': 'Hammer Curls',
          'sets': 3,
          'reps': '12',
          'rest': '45s',
          'video': 'https://www.youtube.com/results?search_query=hammer+curls',
        },
      ],
      'Legs & Glutes': [
        {
          'name': 'Barbell Squats',
          'sets': 4,
          'reps': '12',
          'rest': '90s',
          'video':
              'https://www.youtube.com/results?search_query=barbell+squats',
        },
        {
          'name': 'Romanian Deadlifts',
          'sets': 3,
          'reps': '10',
          'rest': '90s',
          'video':
              'https://www.youtube.com/results?search_query=romanian+deadlift',
        },
        {
          'name': 'Leg Curls',
          'sets': 3,
          'reps': '12',
          'rest': '60s',
          'video': 'https://www.youtube.com/results?search_query=leg+curls',
        },
        {
          'name': 'Hip Thrusts',
          'sets': 3,
          'reps': '12',
          'rest': '60s',
          'video': 'https://www.youtube.com/results?search_query=hip+thrusts',
        },
      ],
      'Core & Abs': [
        {
          'name': 'Plank',
          'sets': 3,
          'reps': '45-60s',
          'rest': '30s',
          'video':
              'https://www.youtube.com/results?search_query=plank+exercise',
        },
        {
          'name': 'Crunches',
          'sets': 3,
          'reps': '20',
          'rest': '30s',
          'video':
              'https://www.youtube.com/results?search_query=crunches+exercise',
        },
        {
          'name': 'Russian Twists',
          'sets': 3,
          'reps': '20 each side',
          'rest': '30s',
          'video':
              'https://www.youtube.com/results?search_query=russian+twists',
        },
        {
          'name': 'Leg Raises',
          'sets': 3,
          'reps': '15',
          'rest': '30s',
          'video': 'https://www.youtube.com/results?search_query=leg+raises',
        },
      ],
      'Cardio': [
        {
          'name': 'Treadmill Running',
          'sets': 1,
          'reps': '20 minutes',
          'rest': '0s',
          'video': 'https://www.youtube.com/results?search_query=running+form',
        },
        {
          'name': 'Cycling',
          'sets': 1,
          'reps': '20 minutes',
          'rest': '0s',
          'video': 'https://www.youtube.com/results?search_query=cycling+form',
        },
        {
          'name': 'Rowing',
          'sets': 1,
          'reps': '15 minutes',
          'rest': '0s',
          'video':
              'https://www.youtube.com/results?search_query=rowing+machine',
        },
        {
          'name': 'HIIT Circuit',
          'sets': 4,
          'reps': '30s on, 30s off',
          'rest': '60s',
          'video': 'https://www.youtube.com/results?search_query=hiit+workout',
        },
      ],
    };

    List<Map<String, dynamic>> exercises =
        (allExercises[muscleGroup] ?? allExercises['Full Body']!)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

    // Adjust based on intensity
    if (intensity == 'Easy') {
      exercises = exercises.take(3).toList();
      exercises = exercises.map((e) {
        final newE = Map<String, dynamic>.from(e);
        newE['sets'] = (newE['sets'] as int) - 1;
        if (newE['reps'] is String && (newE['reps'] as String).contains('-')) {
          final parts = (newE['reps'] as String).split('-');
          newE['reps'] = parts.first; // Take lower rep count
        }
        return newE;
      }).toList();
    } else if (intensity == 'Hard') {
      exercises = exercises.map((e) {
        final newE = Map<String, dynamic>.from(e);
        newE['sets'] = (newE['sets'] as int) + 1;
        return newE;
      }).toList();
    }

    // Adjust for duration
    if (duration < 30) {
      exercises = exercises.take(3).toList();
    } else if (duration >= 45) {
      exercises = exercises.take(5).toList();
    }

    return exercises;
  }

  List<String> _getRecommendations(int age, String intensity) {
    final recommendations = <String>[];

    if (age > 40) {
      recommendations.add(
        'Focus on proper warm-up (5-10 minutes) before starting.',
      );
      recommendations.add(
        'Consider lower impact exercises if you experience joint discomfort.',
      );
    }

    if (intensity == 'Easy') {
      recommendations.add(
        'Perfect for beginners! Start slow and focus on form.',
      );
      recommendations.add('Stay hydrated and listen to your body.');
    } else if (intensity == 'Hard') {
      recommendations.add('Ensure adequate rest between sessions (48 hours).');
      recommendations.add(
        'Consider consulting a trainer for advanced techniques.',
      );
    }

    recommendations.add(
      'Remember to cool down and stretch after your workout.',
    );

    return recommendations;
  }

  Future<void> _openVideoLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open video link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If a feature is selected, show that feature page
    if (_selectedFeature != null && _selectedFeature != 'workout') {
      return _buildFeaturePage(theme, _selectedFeature!);
    }

    return Scaffold(
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Welcome Screen with Carousel
                _buildWelcomeScreenWithCarousel(theme),
                // Step 1: Weight
                _buildQuestionScreen(
                  theme,
                  title: 'What\'s your weight?',
                  subtitle: 'This helps us customize your workout intensity',
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      hintText: 'e.g., 70',
                      prefixIcon: Icon(Icons.monitor_weight_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      }
                      final weight = int.tryParse(value);
                      if (weight == null || weight < 30 || weight > 300) {
                        return 'Please enter a valid weight';
                      }
                      return null;
                    },
                  ),
                ),
                // Step 2: Age
                _buildQuestionScreen(
                  theme,
                  title: 'How old are you?',
                  subtitle: 'Age helps us recommend age-appropriate exercises',
                  child: TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      hintText: 'e.g., 30',
                      prefixIcon: Icon(Icons.cake_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age < 13 || age > 120) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                ),
                // Step 3: Muscle Group
                _buildQuestionScreen(
                  theme,
                  title: 'Which muscle group?',
                  subtitle: 'Select the area you want to focus on',
                  child: Column(
                    children: _muscleGroups.map((group) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ChoiceChip(
                          label: Text(group),
                          selected: _selectedMuscleGroup == group,
                          onSelected: (selected) {
                            setState(() => _selectedMuscleGroup = group);
                          },
                          selectedColor: limeGreen.withValues(alpha: 0.2),
                          checkmarkColor: limeGreen,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Step 4: Intensity
                _buildQuestionScreen(
                  theme,
                  title: 'Intensity level?',
                  subtitle: 'Choose based on your fitness level',
                  child: Column(
                    children: _intensityLevels.map((intensity) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          elevation: _selectedIntensity == intensity ? 4 : 0,
                          color: _selectedIntensity == intensity
                              ? limeGreen.withValues(alpha: 0.1)
                              : null,
                          child: InkWell(
                            onTap: () =>
                                setState(() => _selectedIntensity = intensity),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    intensity == 'Easy'
                                        ? Icons.trending_down_rounded
                                        : intensity == 'Medium'
                                        ? Icons.trending_flat_rounded
                                        : Icons.trending_up_rounded,
                                    color: _selectedIntensity == intensity
                                        ? limeGreen
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          intensity,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color:
                                                    _selectedIntensity ==
                                                        intensity
                                                    ? limeGreen
                                                    : null,
                                                fontWeight:
                                                    _selectedIntensity ==
                                                        intensity
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          intensity == 'Easy'
                                              ? 'Perfect for beginners'
                                              : intensity == 'Medium'
                                              ? 'Moderate challenge'
                                              : 'Advanced training',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_selectedIntensity == intensity)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: limeGreen,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Step 5: Duration
                _buildQuestionScreen(
                  theme,
                  title: 'Workout duration?',
                  subtitle: 'How long do you want to exercise?',
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _durations.map((duration) {
                      final isSelected = _selectedDuration == duration;
                      return ChoiceChip(
                        label: Text(duration),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedDuration = duration);
                        },
                        selectedColor: limeGreen.withValues(alpha: 0.2),
                        checkmarkColor: limeGreen,
                      );
                    }).toList(),
                  ),
                ),
                // Step 6: Break Frequency
                _buildQuestionScreen(
                  theme,
                  title: 'Rest breaks?',
                  subtitle: 'How often do you want to rest?',
                  child: Column(
                    children: _breakFrequencies.map((frequency) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          elevation: _selectedBreakFrequency == frequency
                              ? 4
                              : 0,
                          color: _selectedBreakFrequency == frequency
                              ? limeGreen.withValues(alpha: 0.1)
                              : null,
                          child: InkWell(
                            onTap: () => setState(
                              () => _selectedBreakFrequency = frequency,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(child: Text(frequency)),
                                  if (_selectedBreakFrequency == frequency)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: limeGreen,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Step 7: Results
                _buildResultsScreen(theme),
              ],
            ),
          ),
          // Floating Chatbot Button
          if (!_showChatbot && _selectedFeature == null)
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () => setState(() => _showChatbot = true),
                backgroundColor: limeGreen,
                child: const Icon(
                  Icons.chat_bubble_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          // Chatbot Overlay
          if (_showChatbot) _buildChatbotOverlay(theme),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreenWithCarousel(ThemeData theme) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Splash enhanced image background
        Image.asset(
          'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('AI Assistant image error: $error');
            return Container(color: Colors.black);
          },
        ),
        // Dark overlay for readability
        Container(color: Colors.black.withValues(alpha: 0.5)),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // AI Assistant Avatar with robot face
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: limeGreen,
                  boxShadow: [
                    BoxShadow(
                      color: limeGreen.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to our assistant',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'AI-Powered Fitness Solutions',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Circular Carousel
              Expanded(child: _buildCircularCarousel(theme)),
              const SizedBox(height: 20),
              Text(
                'Rotate to explore features',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularCarousel(ThemeData theme) {
    const double radius = 140.0;
    const double buttonSize = 70.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final carouselHeight = radius * 2 + buttonSize + 100;
    final centerX = screenWidth / 2;
    final centerY = carouselHeight / 2;

    return GestureDetector(
      onPanStart: (details) {
        final center = Offset(centerX, centerY);
        final touchPoint = details.localPosition;
        final delta = touchPoint - center;
        _previousAngle = delta.direction;
      },
      onPanUpdate: (details) {
        final center = Offset(centerX, centerY);
        final touchPoint = details.localPosition;
        final delta = touchPoint - center;
        final currentAngle = delta.direction;
        final angleDelta = currentAngle - _previousAngle;
        setState(() {
          _carouselRotation += angleDelta;
          _previousAngle = currentAngle;
        });
      },
      child: SizedBox(
        width: double.infinity,
        height: carouselHeight,
        child: Stack(
          children: [
            // Circle outline in green
            Positioned(
              left: centerX - radius,
              top: centerY - radius,
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: limeGreen.withValues(alpha: 0.5),
                    width: 3,
                  ),
                ),
              ),
            ),
            // Central rotating robot face icon in green
            Positioned(
              left: centerX - 40,
              top: centerY - 40,
              child: Transform.rotate(
                angle: _carouselRotation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: limeGreen,
                    boxShadow: [
                      BoxShadow(
                        color: limeGreen.withValues(alpha: 0.6),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),
            ),
            // Feature buttons arranged in circle
            ...List.generate(_features.length, (index) {
              final angle =
                  (2 * pi / _features.length) * index + _carouselRotation;
              // Calculate position relative to center
              final x = centerX + radius * 0.85 * cos(angle);
              final y = centerY + radius * 0.85 * sin(angle);

              final feature = _features[index];
              final normalizedAngle = angle % (2 * pi);
              final isTop =
                  normalizedAngle > (pi * 0.5) && normalizedAngle < (pi * 1.5);

              return Positioned(
                left: x - buttonSize / 2,
                top: y - buttonSize / 2,
                child: GestureDetector(
                  onTap: () {
                    if (feature['id'] == 'workout') {
                      _nextStep();
                    } else {
                      setState(
                        () => _selectedFeature = feature['id'] as String,
                      );
                    }
                  },
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isTop
                          ? (feature['color'] as Color).withValues(alpha: 0.9)
                          : (feature['color'] as Color).withValues(alpha: 0.6),
                      border: Border.all(
                        color: Colors.white,
                        width: isTop ? 4 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          feature['icon'] as IconData,
                          color: Colors.white,
                          size: isTop ? 28 : 24,
                        ),
                        if (isTop)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              feature['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturePage(ThemeData theme, String featureId) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _features.firstWhere((f) => f['id'] == featureId)['title'] as String,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => setState(() => _selectedFeature = null),
        ),
      ),
      body: _getFeatureContent(theme, featureId),
    );
  }

  Widget _getFeatureContent(ThemeData theme, String featureId) {
    switch (featureId) {
      case 'progress':
        return _buildProgressPhotoAnalysis(theme);
      case 'form':
        return _buildFormChecker(theme);
      case 'rest':
        return _buildRestDayRecommendations(theme);
      case 'injury':
        return _buildInjuryPrevention(theme);
      default:
        return const Center(child: Text('Feature not found'));
    }
  }

  Widget _buildProgressPhotoAnalysis(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.camera_alt_rounded, color: limeGreen, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Progress Analysis',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: limeGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.smart_toy_rounded,
                                  size: 14,
                                  color: limeGreen,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'AI-Powered',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: limeGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Our AI analyzes your progress photos to track muscle growth, body composition changes, and overall transformation. Get detailed insights and visual comparisons over time.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Camera feature coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_photo_alternate_rounded),
                  label: const Text('Upload Progress Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: limeGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Photos', style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_rounded,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No photos yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormChecker(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.video_camera_back_rounded,
                      color: AppColors.energeticCoral,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Form Checker',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.energeticCoral.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.smart_toy_rounded,
                                  size: 14,
                                  color: AppColors.energeticCoral,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'AI-Powered',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.energeticCoral,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Record your exercise form and get real-time AI-powered feedback on your technique. Our AI analyzes your movements and provides personalized corrections to prevent injuries and maximize results.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Video recording feature coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.videocam_rounded),
                  label: const Text('Record Exercise'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.energeticCoral,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for Better Form',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _buildTipCard(
                  theme,
                  'Squats',
                  'Keep your back straight, knees aligned with toes',
                ),
                const SizedBox(height: 12),
                _buildTipCard(
                  theme,
                  'Deadlifts',
                  'Maintain neutral spine, engage your core',
                ),
                const SizedBox(height: 12),
                _buildTipCard(
                  theme,
                  'Bench Press',
                  'Keep feet flat, retract shoulder blades',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(ThemeData theme, String exercise, String tip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.platinumMist,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.energeticCoral,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(tip, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestDayRecommendations(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          color: Colors.purple.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bedtime_rounded, color: Colors.purple, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Rest Day Coach',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.smart_toy_rounded,
                                  size: 14,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'AI-Powered',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Our AI analyzes your workout patterns, intensity, and recovery needs to recommend optimal rest day activities. Get personalized suggestions to maximize recovery and prevent burnout.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildRestActivityCard(
          theme,
          'Light Stretching',
          '15-20 minutes of gentle stretching',
          Icons.fitness_center_rounded,
        ),
        const SizedBox(height: 12),
        _buildRestActivityCard(
          theme,
          'Yoga Session',
          '30-minute restorative yoga flow',
          Icons.self_improvement_rounded,
        ),
        const SizedBox(height: 12),
        _buildRestActivityCard(
          theme,
          'Walking',
          '30-45 minute leisurely walk',
          Icons.directions_walk_rounded,
        ),
        const SizedBox(height: 12),
        _buildRestActivityCard(
          theme,
          'Meditation',
          '10-15 minutes of mindfulness',
          Icons.psychology_rounded,
        ),
        const SizedBox(height: 12),
        _buildRestActivityCard(
          theme,
          'Foam Rolling',
          '15 minutes of self-massage',
          Icons.roller_skating_rounded,
        ),
      ],
    );
  }

  Widget _buildRestActivityCard(
    ThemeData theme,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple.withValues(alpha: 0.1),
          child: Icon(icon, color: Colors.purple),
        ),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(description, style: theme.textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  Widget _buildInjuryPrevention(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          color: Colors.teal.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medical_services_rounded,
                      color: Colors.teal,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Injury Prevention',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.smart_toy_rounded,
                                  size: 14,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'AI-Powered',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Our AI analyzes your workout patterns, exercise history, and body mechanics to provide personalized injury prevention tips. Get tailored warm-up routines and exercises based on your specific needs and risk factors.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildInjuryTipCard(
          theme,
          'Warm-Up Routine',
          '5-10 minutes before every workout',
          [
            'Light cardio (5 min)',
            'Dynamic stretching',
            'Joint mobility exercises',
          ],
        ),
        const SizedBox(height: 12),
        _buildInjuryTipCard(theme, 'Knee Protection', 'Prevent knee injuries', [
          'Strengthen quadriceps',
          'Proper squat form',
          'Avoid overextension',
        ]),
        const SizedBox(height: 12),
        _buildInjuryTipCard(
          theme,
          'Shoulder Safety',
          'Protect your shoulders',
          [
            'Rotator cuff exercises',
            'Proper bench press form',
            'Avoid overhead press if injured',
          ],
        ),
        const SizedBox(height: 12),
        _buildInjuryTipCard(theme, 'Lower Back Care', 'Protect your spine', [
          'Core strengthening',
          'Proper deadlift form',
          'Stretch hip flexors',
        ]),
      ],
    );
  }

  Widget _buildInjuryTipCard(
    ThemeData theme,
    String title,
    String subtitle,
    List<String> tips,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(tip, style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatbotOverlay(ThemeData theme) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Column(
        children: [
          const Spacer(),
          Container(
            height: 400,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: limeGreen,
                        child: Icon(
                          Icons.smart_toy_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Assistant',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'Ask me anything!',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() => _showChatbot = false),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildChatBubble(
                        theme,
                        'Hi! How can I help you today?',
                        true,
                      ),
                      const SizedBox(height: 12),
                      _buildQuickQuestion(
                        theme,
                        'What\'s the best workout for beginners?',
                      ),
                      _buildQuickQuestion(theme, 'How often should I rest?'),
                      _buildQuickQuestion(
                        theme,
                        'What should I eat before a workout?',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type your question...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, color: limeGreen),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('AI response feature coming soon!'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ThemeData theme, String message, bool isBot) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isBot ? AppColors.platinumMist : limeGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isBot ? Colors.black87 : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickQuestion(ThemeData theme, String question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('AI response for: $question')));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: limeGreen.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.help_outline_rounded, size: 16, color: limeGreen),
              const SizedBox(width: 8),
              Expanded(child: Text(question, style: theme.textTheme.bodySmall)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionScreen(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            Row(
              children: List.generate(6, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: _currentStep > index + 1
                          ? limeGreen
                          : _currentStep == index + 1
                          ? limeGreen
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(child: child),
            const SizedBox(height: 24),
            Row(
              children: [
                if (_currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 1) const SizedBox(width: 16),
                Expanded(
                  flex: _currentStep > 1 ? 1 : 1,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _currentStep == 6 ? 'Generate Workout' : 'Next',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen(ThemeData theme) {
    if (_workoutPlan == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final exercises = _workoutPlan!['exercises'] as List<Map<String, dynamic>>;
    final recommendations = _workoutPlan!['recommendations'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Workout Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                _currentStep = 0;
                _workoutPlan = null;
                _weightController.clear();
                _ageController.clear();
                _selectedMuscleGroup = null;
                _selectedIntensity = null;
                _selectedDuration = null;
                _selectedBreakFrequency = null;
              });
              _pageController.jumpToPage(0);
            },
            tooltip: 'Start Over',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Summary Card
          Card(
            color: limeGreen,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.fitness_center_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Workout Summary',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _workoutPlan!['totalDuration'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildSummaryChip(
                        theme,
                        'Muscle Group',
                        _workoutPlan!['muscleGroup'] as String,
                      ),
                      const SizedBox(width: 8),
                      _buildSummaryChip(
                        theme,
                        'Intensity',
                        _workoutPlan!['intensity'] as String,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Exercises List
          Text('Exercises', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          ...exercises.asMap().entries.map((entry) {
            final index = entry.key;
            final exercise = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: limeGreen.withValues(alpha: 0.1),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: limeGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(
                  exercise['name'] as String,
                  style: theme.textTheme.titleMedium,
                ),
                subtitle: Text(
                  '${exercise['sets']} sets × ${exercise['reps']}',
                  style: theme.textTheme.bodySmall,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer_rounded,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Rest: ${exercise['rest']}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () =>
                              _openVideoLink(exercise['video'] as String),
                          icon: const Icon(Icons.play_circle_outline_rounded),
                          label: const Text('Watch 5-minute tutorial'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: limeGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          // Recommendations
          Text('Recommendations', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recommendations.map((rec) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          color: AppColors.energeticCoral,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(rec, style: theme.textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Start Workout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Workout started! Track your progress as you go.',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text(
                'Start Workout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(ThemeData theme, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
          ),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
