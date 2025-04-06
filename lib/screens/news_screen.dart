import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  // Parameter untuk menentukan apakah tampilkan tombol back atau tidak
  final bool showBackButton;
  
  // Jumlah notifikasi (akan digunakan juga di HomeScreen)
  static const int notificationCount = 4;

  // Constructor dengan parameter opsional
  const NewsScreen({Key? key, this.showBackButton = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar dan padding horizontal yang konsisten
    final horizontalPadding = 16.0;
    final primaryColor = const Color(0xFF2D7BEE);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        // Tampilkan tombol back hanya jika showBackButton true
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton 
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.mark_email_read_rounded, color: primaryColor),
              onPressed: () {
                // Mark all as read functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All notifications marked as read')),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab('All', true, primaryColor),
                  const SizedBox(width: 10),
                  _buildFilterTab('Promos', false, primaryColor),
                  const SizedBox(width: 10),
                  _buildFilterTab('Updates', false, primaryColor),
                  const SizedBox(width: 10),
                  _buildFilterTab('Orders', false, primaryColor),
                ],
              ),
            ),
          ),
          
          // Notification List
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              children: [
                // Today header
                _buildDateHeader('Today', true),
                
                // Today's notifications
                _buildNotificationItem(
                  context,
                  imagePath: 'assets/images/banner1.png',
                  title: 'Special Skincare Promo',
                  description: 'Get up to 50% off on selected skincare products',
                  timeAgo: '15 min ago',
                  isNew: true,
                  primaryColor: primaryColor,
                ),
                
                _buildNotificationItem(
                  context,
                  imagePath: 'assets/images/banner2.png',
                  title: 'Cooking Oil Discount',
                  description: 'Save on your monthly cooking oil purchase',
                  timeAgo: '2 hours ago',
                  isNew: true,
                  primaryColor: primaryColor,
                ),
                
                // Yesterday header
                _buildDateHeader('Yesterday', false),
                
                // Yesterday's notifications
                _buildNotificationItem(
                  context,
                  imagePath: 'assets/images/banner3.png',
                  title: 'Eid Al-Fitr Special',
                  description: 'Exclusive THR deals for Ramadan celebration',
                  timeAgo: '1 day ago',
                  isNew: false,
                  primaryColor: primaryColor,
                ),
                
                _buildNotificationItem(
                  context,
                  imagePath: 'assets/images/banner4.png',
                  title: 'Weekend Sale Festival',
                  description: 'Explore amazing deals this weekend only',
                  timeAgo: '1 day ago',
                  isNew: false,
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Filter tab widget
  Widget _buildFilterTab(String label, bool isActive, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
  
  // Date header widget
  Widget _buildDateHeader(String date, bool isToday) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isToday ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  // Notification item widget
  Widget _buildNotificationItem(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String description,
    required String timeAgo,
    required bool isNew,
    required Color primaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and NEW badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Time and view button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Time ago
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    
                   
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}