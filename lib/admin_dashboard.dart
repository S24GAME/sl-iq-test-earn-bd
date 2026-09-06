import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // পেমেন্ট স্ট্যাটাস (approved / rejected) আপডেট করার ফাংশন
  Future<void> _updateWithdrawalStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('withdrawals')
        .doc(docId)
        .update({'status': status});
  }

  // কুইজ এন্ট্রি মুছে ফেলার ফাংশন
  Future<void> _deleteQuiz(String docId) async {
    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.indigo,
      ),
      body: _selectedIndex == 0
          ? _buildWithdrawalRequests()
          : _buildQuizManagement(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Withdrawals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Manage Quizzes',
          ),
        ],
      ),
    );
  }

  // উইথড্র রিকোয়েস্ট লিস্ট
  Widget _buildWithdrawalRequests() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('withdrawals').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('No withdrawal requests.'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final docId = docs[index].id;
            final status = data['status'] ?? 'pending';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text('User: ${data['userId'] ?? 'Unknown'}'),
                subtitle: Text('Amount: ৳${data['amount']} | Method: ${data['method']}\nStatus: $status'),
                isThreeLine: true,
                trailing: status == 'pending'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () => _updateWithdrawalStatus(docId, 'approved'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => _updateWithdrawalStatus(docId, 'rejected'),
                          ),
                        ],
                      )
                    : Icon(
                        status == 'approved' ? Icons.check : Icons.close,
                        color: status == 'approved' ? Colors.green : Colors.red,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  // কুইজ ম্যানেজমেন্ট লিস্ট
  Widget _buildQuizManagement() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('No quizzes found.'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final docId = docs[index].id;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(data['question'] ?? 'No Question'),
                subtitle: Text('Answer: ${data['answer'] ?? 'N/A'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteQuiz(docId),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
