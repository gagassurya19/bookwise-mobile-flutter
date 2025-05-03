import 'package:flutter/material.dart';
import '../widgets/book_grid.dart';

class ExploreScreen extends StatefulWidget {
  final String? searchQuery;
  
  const ExploreScreen({super.key, this.searchQuery});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late String searchQuery;
  String selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchQuery = widget.searchQuery ?? '';
    _searchController.text = searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar with Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search books...',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Clear Search Button
                  if (searchQuery.isNotEmpty)
                    IconButton(
                      onPressed: _clearSearch,
                      icon: Icon(Icons.clear, color: Colors.grey.shade600),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  // Category Filter Button
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Select Category',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  'Semua',
                                  'fiction',
                                  'romance',
                                  'memoir',
                                  'fantasy',
                                ].map((category) => ChoiceChip(
                                  label: Text(category[0].toUpperCase() + category.substring(1)),
                                  selected: selectedCategory == category,
                                  selectedColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: selectedCategory == category ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  backgroundColor: Colors.grey.shade200,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        selectedCategory = category;
                                      });
                                      Navigator.pop(context);
                                    }
                                  },
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.filter_list, color: Colors.grey.shade600),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Book grid
              Expanded(
                child: BookGrid(
                  searchQuery: searchQuery,
                  filterCategory: selectedCategory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
