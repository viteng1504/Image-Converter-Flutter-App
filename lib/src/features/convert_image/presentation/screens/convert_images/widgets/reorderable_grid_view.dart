import 'dart:typed_data';
import 'package:flutter/material.dart';

class ReorderableGridView extends StatefulWidget {
  final List<Uint8List?> imagesBytes;
  const ReorderableGridView({super.key, required this.imagesBytes});

  @override
  State<ReorderableGridView> createState() => _ReorderableGridViewState();
}

class _ReorderableGridViewState extends State<ReorderableGridView> {
  final int crossAxisCount = 2;
  final double crossAxisSpacing = 16.0;
  final double mainAxisSpacing = 16.0;
  final double childAspectRatio = 0.9;

  final ScrollController scrollController = ScrollController();
  final GlobalKey containerKey = GlobalKey();

  late List<int> order;
  int? draggingIndex;
  bool isScrolling = false;

  @override
  void initState() {
    super.initState();
    order = List.generate(widget.imagesBytes.length, (index) => index);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void reorder(int from, int to) {
    final item = order.removeAt(from);
    order.insert(to, item);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 16 * 2;
    final itemWidth =
        ((availableWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
            crossAxisCount) -
        3.0;
    final itemHeight = itemWidth / childAspectRatio;

    return Container(
      key: containerKey,
      child: SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
          height:
              ((widget.imagesBytes.length / crossAxisCount).ceil()) *
              (itemHeight + mainAxisSpacing),
          child: Stack(
            children: List.generate(widget.imagesBytes.length, (index) {
              final itemIndex = order[index];
              final imageBytes = widget.imagesBytes[itemIndex];

              final left =
                  (index % crossAxisCount) * (itemWidth + crossAxisSpacing);
              final top =
                  (index ~/ crossAxisCount) * (itemHeight + mainAxisSpacing);

              final isBeingDragged = draggingIndex == itemIndex;

              return AnimatedPositioned(
                key: ValueKey(itemIndex),
                top: top,
                left: left,
                width: itemWidth,
                height: itemHeight,
                duration: const Duration(milliseconds: 300),
                child: DragTarget<int>(
                  onWillAccept: (from) {
                    if (from == null || from == itemIndex) return false;
                    setState(() {
                      reorder(order.indexOf(from), index);
                    });
                    return true;
                  },
                  onAccept: (_) => setState(() => draggingIndex = null),
                  builder: (_, __, ___) {
                    return LongPressDraggable<int>(
                      data: itemIndex,
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          height: itemHeight,
                          width: itemWidth,
                          child: buildItem(
                            imageBytes,
                            order.indexOf(itemIndex),
                            isDragging: true,
                          ),
                        ),
                      ),
                      childWhenDragging: const SizedBox(),
                      onDragStarted:
                          () => setState(() {
                            draggingIndex = itemIndex;
                          }),
                      onDragEnd:
                          (_) => setState(() {
                            draggingIndex = null;
                          }),
                      onDragUpdate: (details) {
                        final box =
                            containerKey.currentContext!.findRenderObject()
                                as RenderBox;
                        final local = box.globalToLocal(details.globalPosition);

                        final topOfDragged = local.dy;
                        final bottomOfDragged = topOfDragged + itemHeight;

                        const scrollStep = 100.0;
                        const scrollThreshold = 40.0;

                        if (!isScrolling) {
                          if (topOfDragged < scrollThreshold &&
                              scrollController.offset >
                                  scrollController.position.minScrollExtent) {
                            isScrolling = true;
                            final newOffset =
                                (scrollController.offset - scrollStep).clamp(
                                  scrollController.position.minScrollExtent,
                                  scrollController.position.maxScrollExtent,
                                );
                            scrollController
                                .animateTo(
                                  newOffset,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                )
                                .whenComplete(() => isScrolling = false);
                          } else if (bottomOfDragged >
                                  box.size.height - scrollThreshold &&
                              scrollController.offset <
                                  scrollController.position.maxScrollExtent) {
                            isScrolling = true;
                            final newOffset =
                                (scrollController.offset + scrollStep).clamp(
                                  scrollController.position.minScrollExtent,
                                  scrollController.position.maxScrollExtent,
                                );
                            scrollController
                                .animateTo(
                                  newOffset,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                )
                                .whenComplete(() => isScrolling = false);
                          }
                        }

                        for (int i = 0; i < order.length; i++) {
                          if (order[i] == draggingIndex) continue;

                          final leftI =
                              (i % crossAxisCount) *
                              (itemWidth + crossAxisSpacing);
                          final topI =
                              (i ~/ crossAxisCount) *
                              (itemHeight + mainAxisSpacing);
                          final adjustedTop = topI - scrollController.offset;

                          final center = Offset(
                            leftI + itemWidth / 2,
                            adjustedTop + itemHeight / 2,
                          );

                          if ((local - center).distance < itemWidth / 2) {
                            final from = order.indexOf(draggingIndex!);
                            if (from != i) {
                              setState(() {
                                reorder(from, i);
                              });
                            }
                            break;
                          }
                        }
                      },
                      child: buildItem(
                        imageBytes,
                        order.indexOf(itemIndex),
                        isDragging: isBeingDragged,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildItem(
    Uint8List? imageBytes,
    int displayIndex, {
    bool isDragging = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child:
                      imageBytes != null
                          ? Image.memory(
                            imageBytes,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          )
                          : Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey,
                            child: const Center(child: Text('Loading...')),
                          ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 2,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 20,
                              height: 2,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Text(
                          isDragging ? '' : displayIndex.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isDragging)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
