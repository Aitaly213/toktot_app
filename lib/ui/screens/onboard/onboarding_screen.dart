import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildPage(
                title: 'Добро пожаловать в MyApp',
                description: 'Это первая страница нашей онбординг.',
                imagePath: 'assets/images/first.png',
              ),
              _buildPage(
                title: 'Исследуйте функции',
                description: 'Откройте для себя все функции, которые мы предлагаем.',
                imagePath: 'assets/images/second.png',
              ),
              _buildPage(
                title: 'Начнем',
                description: 'Давайте начнем!',
                imagePath: 'assets/images/third.png',
                isLastPage: true,
              ),
            ],
          ),

          // Индикатор текущей страницы
          Positioned(
            bottom: 130,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 12,
                  width: _currentPage == index ? 24 : 12,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < 2) {
                  _pageController.animateToPage(
                    2,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushNamed(context, '/registration');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Винный голубой цвет
                padding: EdgeInsets.symmetric(vertical: 16), // Размер кнопки
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text(
                _currentPage < 2 ? 'Пропустить' : 'Начнем',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required String imagePath,
    bool isLastPage = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.8, // 80% ширины экрана
                height: constraints.maxHeight * 0.4, // 40% высоты экрана
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}