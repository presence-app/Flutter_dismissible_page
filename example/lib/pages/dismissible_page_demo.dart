import 'dart:math';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:example/models/models.dart';
import 'package:example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DismissiblePageDemo extends StatefulWidget {
  const DismissiblePageDemo({Key? key}) : super(key: key);

  @override
  _DismissiblePageDemoState createState() => _DismissiblePageDemoState();
}

class _DismissiblePageDemoState extends State<DismissiblePageDemo> {
  final DismissiblePageModel pageModel = DismissiblePageModel();

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get contacts => [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tornike',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                'Find me on',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: pageModel.contacts.entries.map((item) {
              return ActionChip(
                onPressed: () => launch(item.value),
                label: Text(item.key, style: GoogleFonts.poppins()),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
      ];

  @override
  Widget build(BuildContext context) {
    return FirstPage();
    return Scaffold(
      bottomNavigationBar: _stories(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: max(20, MediaQuery.of(context).padding.top)),
            ...contacts,
            Title('Bool Parameters'),
            Wrap(spacing: 10, runSpacing: 10, children: [
              AppChip(
                onSelected: () => setState(
                    () => pageModel.isFullScreen = !pageModel.isFullScreen),
                isSelected: pageModel.isFullScreen,
                title: 'isFullscreen',
              ),
              AppChip(
                onSelected: () =>
                    setState(() => pageModel.disabled = !pageModel.disabled),
                isSelected: pageModel.disabled,
                title: 'disabled',
              ),
            ]),
            SizedBox(height: 20),
            Title('Dismiss Direction'),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: DismissiblePageDismissDirection.values.map((item) {
                return AppChip(
                  onSelected: () {
                    setState(() => pageModel.direction = item);
                  },
                  isSelected: item == pageModel.direction,
                  title: '$item'
                      .replaceAll('DismissiblePageDismissDirection.', ''),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            DurationSlider(
              title: 'Transition Duration',
              duration: pageModel.transitionDuration,
              onChanged: (value) {
                setState(() => pageModel.transitionDuration = value);
              },
            ),
            SizedBox(height: 30),
            DurationSlider(
              title: 'Reverse Transition Duration',
              duration: pageModel.reverseTransitionDuration,
              onChanged: (value) {
                setState(() => pageModel.reverseTransitionDuration = value);
              },
            ),
            SizedBox(height: 30),
            DurationSlider(
              title: 'Reverse Animation Duration',
              duration: pageModel.reverseDuration,
              onChanged: (value) {
                setState(() => pageModel.reverseDuration = value);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _stories() {
    return Padding(
      padding: EdgeInsets.only(
        top: 5,
        bottom: max(24, MediaQuery.of(context).padding.bottom),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final width = constraints.maxWidth;
          final itemHeight = width / 3;
          final itemWidth = width / 4;
          return SizedBox(
            height: itemHeight,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) {
                final item = pageModel.stories.elementAt(index);

                return SizedBox(
                  width: itemWidth,
                  child: StoryWidget(
                    story: item,
                    pageModel: pageModel,
                  ),
                );
              },
              separatorBuilder: (_, int i) => SizedBox(width: 10),
              itemCount: pageModel.stories.length,
            ),
          );
        },
      ),
    );
  }
}

class Title extends StatelessWidget {
  final String text;

  Title(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class AppChip extends StatelessWidget {
  final VoidCallback onSelected;
  final bool isSelected;
  final String title;

  AppChip({
    required this.onSelected,
    required this.isSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      onSelected: (_) => onSelected(),
      selected: isSelected,
      label: Text(
        title,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

const imagePath = 'assets/images/demo.png';
const home1ImagePath = 'assets/images/home_1.png';
const home2ImagePath = 'assets/images/home_2.png';
const images = [home1ImagePath, home2ImagePath];

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ...images.map((imagePath) {
                return GestureDetector(
                  onTap: () {
                    // Use extension method to use [TransparentRoute]
                    // This will push page without route background
                    context
                        .pushTransparentRoute(SecondPage(imagePath: imagePath));
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Stack(
                      children: [
                        Hero(
                          tag: imagePath,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      // Note that scrollable widget inside DismissiblePage might limit the functionality
      // If scroll direction matches DismissiblePage direction
      // direction: DismissiblePageDismissDirection.multi,
      // onDragUpdate: print,
      // direction: DismissiblePageDismissDirection.multi,
      isFullScreen: false,
      minScale: .5,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: imagePath,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
              ...List.generate(20, (index) => index + 1).map((index) {
                return ListTile(
                  title: Text(
                    'Item $index',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
