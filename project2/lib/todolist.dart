import 'package:flutter/material.dart';

/// Entry point when running this file directly via `flutter run lib/todolist.dart`
void main() {
  runApp(const TodoListApp());
}

/// Priority levels for Todo items
enum TodoPriority {
  high('High', Colors.red, Icons.priority_high_rounded),
  medium('Medium', Colors.orange, Icons.remove_rounded),
  low('Low', Colors.green, Icons.arrow_downward_rounded);

  final String label;
  final MaterialColor color;
  final IconData icon;

  const TodoPriority(this.label, this.color, this.icon);
}

/// Filter options for displaying tasks
enum TodoFilter { all, pending, completed }

/// Model class representing an individual Todo item
class TodoItem {
  final String id;
  String title;
  bool isCompleted;
  TodoPriority priority;
  final DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = TodoPriority.medium,
    required this.createdAt,
  });

  TodoItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    TodoPriority? priority,
    DateTime? createdAt,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Root application widget
class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C6BC0),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        cardTheme: CardThemeData(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const TodoListScreen(),
    );
  }
}

/// Main Screen implemented using StatefulWidget to manage dynamic list state
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // In-memory list storing the Todo items
  final List<TodoItem> _todos = [
    TodoItem(
      id: '1',
      title: 'Learn Flutter StatefulWidget & setState',
      isCompleted: true,
      priority: TodoPriority.high,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    TodoItem(
      id: '2',
      title: 'Implement Add, Delete & Mark-Complete operations',
      isCompleted: true,
      priority: TodoPriority.high,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    TodoItem(
      id: '3',
      title: 'Push code to the "todolist" branch on GitHub',
      isCompleted: false,
      priority: TodoPriority.medium,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    TodoItem(
      id: '4',
      title: 'Write 400-500 words learning report',
      isCompleted: false,
      priority: TodoPriority.medium,
      createdAt: DateTime.now(),
    ),
  ];

  // Active filter
  TodoFilter _currentFilter = TodoFilter.all;

  // Filtered list getter based on active filter
  List<TodoItem> get _filteredTodos {
    switch (_currentFilter) {
      case TodoFilter.pending:
        return _todos.where((t) => !t.isCompleted).toList();
      case TodoFilter.completed:
        return _todos.where((t) => t.isCompleted).toList();
      case TodoFilter.all:
      default:
        return _todos;
    }
  }

  int get _completedCount => _todos.where((t) => t.isCompleted).length;
  int get _pendingCount => _todos.where((t) => !t.isCompleted).length;

  /// -------------------------------------------------------------
  /// OPERATION 1: ADD A NEW TODO ITEM (using setState)
  /// -------------------------------------------------------------
  void _addTodo(String title, TodoPriority priority) {
    if (title.trim().isEmpty) return;

    final newItem = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      isCompleted: false,
      priority: priority,
      createdAt: DateTime.now(),
    );

    // Call setState to insert the item and notify Flutter to rebuild the UI
    setState(() {
      _todos.insert(0, newItem);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text('Task added: "${newItem.title}"')),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// -------------------------------------------------------------
  /// OPERATION 2: DELETE A TODO ITEM (using setState + Undo feature)
  /// -------------------------------------------------------------
  void _deleteTodo(String id) {
    final targetIndex = _todos.indexWhere((t) => t.id == id);
    if (targetIndex == -1) return;

    final removedItem = _todos[targetIndex];

    // Remove item and trigger rebuild
    setState(() {
      _todos.removeAt(targetIndex);
    });

    // Provide immediate undo option via SnackBar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${removedItem.title}"'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amberAccent,
          onPressed: () {
            // Restore item at its previous position and update UI
            setState(() {
              _todos.insert(targetIndex, removedItem);
            });
          },
        ),
      ),
    );
  }

  /// -------------------------------------------------------------
  /// OPERATION 3: MARK COMPLETE / TOGGLE STATUS (using setState)
  /// -------------------------------------------------------------
  void _toggleComplete(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) return;

    // Toggle completion flag and rebuild reactive widgets
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  /// Batch action to clear all completed items
  void _clearCompleted() {
    final completedItems = _todos.where((t) => t.isCompleted).toList();
    if (completedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No completed tasks to clear!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Completed Tasks'),
        content: Text(
          'Are you sure you want to remove all ${completedItems.length} completed task(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _todos.removeWhere((t) => t.isCompleted);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed ${completedItems.length} completed task(s)'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Modal Bottom Sheet for adding a new task
  void _showAddTodoBottomSheet() {
    final textController = TextEditingController();
    TodoPriority selectedPriority = TodoPriority.medium;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create New Task',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'What needs to be done?',
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      prefixIcon: const Icon(Icons.edit_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        Navigator.pop(ctx);
                        _addTodo(val, selectedPriority);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Priority Level',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: TodoPriority.values.map((priority) {
                      final isSelected = selectedPriority == priority;
                      return ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              priority.icon,
                              size: 16,
                              color: isSelected ? Colors.white : priority.color,
                            ),
                            const SizedBox(width: 4),
                            Text(priority.label),
                          ],
                        ),
                        selected: isSelected,
                        selectedColor: priority.color,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setSheetState(() {
                              selectedPriority = priority;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (textController.text.trim().isNotEmpty) {
                          final title = textController.text;
                          Navigator.pop(ctx);
                          _addTodo(title, selectedPriority);
                        }
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text(
                        'Add Task',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double completionRate =
        _todos.isEmpty ? 0.0 : (_completedCount / _todos.length);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Todo List',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text(
              'StatefulWidget & setState Demo',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          if (_completedCount > 0)
            IconButton(
              icon: const Icon(Icons.cleaning_services_rounded),
              tooltip: 'Clear completed tasks',
              onPressed: _clearCompleted,
            ),
        ],
      ),
      body: Column(
        children: [
          // 1. Metrics & Progress Header Card
          _buildMetricsCard(completionRate),

          // 2. Filter Selector Chips
          _buildFilterChips(),

          const SizedBox(height: 8),

          // 3. Dynamic Todo Items List View
          Expanded(
            child: _filteredTodos.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredTodos.length,
                    itemBuilder: (context, index) {
                      final item = _filteredTodos[index];
                      return _buildTodoCard(item);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTodoBottomSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Task'),
      ),
    );
  }

  /// Metrics Card showing total counts, progress bar, and completion percentage
  Widget _buildMetricsCard(double completionRate) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task Progress',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_completedCount of ${_todos.length} Completed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(completionRate * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionRate,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_pendingCount Pending',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                completionRate == 1.0 && _todos.isNotEmpty
                    ? 'All tasks done! 🎉'
                    : 'Stay productive today 💪',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Filter chips for All, Pending, Completed
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _filterChip(TodoFilter.all, 'All', _todos.length),
          const SizedBox(width: 8),
          _filterChip(TodoFilter.pending, 'Pending', _pendingCount),
          const SizedBox(width: 8),
          _filterChip(TodoFilter.completed, 'Completed', _completedCount),
        ],
      ),
    );
  }

  Widget _filterChip(TodoFilter filter, String label, int count) {
    final isSelected = _currentFilter == filter;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          setState(() {
            _currentFilter = filter;
          });
        }
      },
      selectedColor: const Color(0xFF4F46E5),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF475569),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
    );
  }

  /// Individual Todo Card with Dismissible swipe-to-delete and completion checkbox
  Widget _buildTodoCard(TodoItem item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline, color: Colors.white),
          ],
        ),
      ),
      onDismissed: (_) => _deleteTodo(item.id),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: item.isCompleted ? 0.5 : 2,
        color: item.isCompleted ? const Color(0xFFF1F5F9) : Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Transform.scale(
            scale: 1.15,
            child: Checkbox(
              value: item.isCompleted,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              activeColor: const Color(0xFF4F46E5),
              onChanged: (_) => _toggleComplete(item.id),
            ),
          ),
          title: Text(
            item.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration:
                  item.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              color: item.isCompleted
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF1E293B),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                // Priority badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.priority.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.priority.icon, size: 12, color: item.priority.color),
                      const SizedBox(width: 4),
                      Text(
                        item.priority.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: item.priority.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _formatTime(item.createdAt),
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
            tooltip: 'Delete task',
            onPressed: () => _deleteTodo(item.id),
          ),
        ),
      ),
    );
  }

  /// Empty state widget when list is empty
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentFilter == TodoFilter.completed
                ? Icons.fact_check_outlined
                : Icons.task_alt_rounded,
            size: 72,
            color: const Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 16),
          Text(
            _currentFilter == TodoFilter.completed
                ? 'No completed tasks yet'
                : (_currentFilter == TodoFilter.pending
                    ? 'No pending tasks!'
                    : 'No tasks found!'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap "+ New Task" below to add your first item.',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
