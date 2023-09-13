import 'package:cloud_firestore/cloud_firestore.dart';

class IssueModel {
  final String? id; 
  final String issueDetails;
  final String issueType;
  final DateTime timestamp;
  final String userName;
  final String userEmail; 

  const IssueModel({
    this.id,
    required this.issueDetails,
    required this.issueType,
    required this.timestamp,
    required this.userName,
    required this.userEmail
  });

  toJson(){
    return {
      "IssueDetails": issueDetails,
      "IssueType": issueType,
      "Timestamp": timestamp,
      "UserEmail": userEmail,
      "UserName": userName,
    };
  }
}