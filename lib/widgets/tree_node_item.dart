import 'package:flutter/material.dart';
import 'package:tree_structure_view/node/list_node.dart';
import 'package:tree_structure_view/controllers/animated_list_controller.dart';
import 'package:tree_structure_view/tree_structure_view.dart';
import 'package:tree_structure_view/widgets/list_item_container.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TreeNodeItem<T extends Node<T>> extends StatelessWidget {
  final LeveledItemWidgetBuilder<T> builder;
  final AnimatedListController<T> animatedListController;
  final AutoScrollController scrollController;
  final Node<T> node;
  final Animation<double> animation;
  final double? indentPadding;
  final bool? showExpansionIndicator;
  final Icon? expandIcon;
  final Icon? collapseIcon;
  final bool remove;
  final int? index;
  final ValueSetter<T>? onItemTap;

  const TreeNodeItem(
      {Key? key,
        required this.builder,
        required this.animatedListController,
        required this.scrollController,
        required this.node,
        required this.animation,
        this.remove = false,
        this.index,
        this.indentPadding,
        this.showExpansionIndicator,
        this.expandIcon,
        this.collapseIcon,
        this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemContainer = ListItemContainer(
      animation: animation,
      item: node,
      child: builder(context, node.level, node as T),
      indentPadding: indentPadding! * node.level,
      showExpansionIndicator:
      showExpansionIndicator! && node.childrenAsList.isNotEmpty,
      expandedIndicatorIcon: node.isExpanded ? collapseIcon : expandIcon,
      onTap: remove
          ? null
          : (dynamic item) {
        animatedListController.toggleExpansion(item);
        if (onItemTap != null) onItemTap!(item);
      },
    );

    if (index == null || remove) return itemContainer;

    return AutoScrollTag(
      key: ValueKey(node.key),
      controller: scrollController,
      index: index!,
      child: itemContainer,
    );
  }
}