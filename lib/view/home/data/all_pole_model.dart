import '../../my_polls/data/my_poll_response_model.dart';

class AllPoles {
  int? status;
  String? message;
  List<PollData>? data;

  AllPoles({this.status, this.message, this.data});

  AllPoles.fromJson(Map<String, dynamic> json, {bool myPoll = false}) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PollData>[];
      json['data'].forEach((v) {
        data!.add(PollData.fromJson(v, myPoll));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class AllPolData {
//   String? sId;
//   String? userId;
//   String? title;
//   String? startTime;
//   String? endTime;
//   List<FamilyMembers>? familyMembers;
//   List<Button>? button;
//   int? isDelete;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//   // FamilyMembers? familyMembers;

//   AllPolData({
//     this.sId,
//     this.userId,
//     this.title,
//     this.startTime,
//     this.endTime,
//     this.familyMembers,
//     this.button,
//     this.isDelete,
//     this.createdAt,
//     this.updatedAt,
//     this.iV,
//   });

//   AllPolData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     userId = json['user_id'];
//     title = json['title'];
//     startTime = json['start_time'];
//     endTime = json['end_time'];
//     if (json['family_members'] != null) {
//       familyMembers = <FamilyMembers>[];
//       json['family_members'].forEach((v) {
//         familyMembers!.add(FamilyMembers.fromJson(v));
//       });
//     }
//     if (json['button'] != null) {
//       button = <Button>[];
//       json['button'].forEach((v) {
//         button!.add(Button.fromJson(v));
//       });
//     }
//     isDelete = json['is_delete'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//     // familyMembers = json['familyMembers'] != null
//     //     ? FamilyMembers.fromJson(json['familyMembers'])
//     //     : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['user_id'] = userId;
//     data['title'] = title;
//     data['start_time'] = startTime;
//     data['end_time'] = endTime;
//     if (familyMembers != null) {
//       data['family_members'] = familyMembers!.map((v) => v.toJson()).toList();
//     }
//     if (button != null) {
//       data['button'] = button!.map((v) => v.toJson()).toList();
//     }
//     data['is_delete'] = isDelete;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['__v'] = iV;
//     // if (familyMembers != null) {
//     //   // data['familyMembers'] = familyMembers!.toJson();
//     // }
//     return data;
//   }
// }



// class Button {
//   String? text;
//   String? sId;
//   List<Votes>? votes;
//   int? totalVotes;
//   int? buttonVotes;
//   double? percentage;
//   int? myVote;

//   Button(
//       {this.text,
//       this.sId,
//       this.votes,
//       this.totalVotes,
//       this.buttonVotes,
//       this.percentage,
//       this.myVote});

//   Button.fromJson(Map<String, dynamic> json) {
//     text = json['text'];
//     sId = json['_id'];
//     if (json['votes'] != null) {
//       votes = <Votes>[];
//       json['votes'].forEach((v) {
//         votes!.add(Votes.fromJson(v));
//       });
//     }
//     totalVotes = json['total_votes'];
//     buttonVotes = json['button_votes'];
//     percentage = json['percentage'] != null
//         ? double.parse(json['percentage'].toString())
//         : 0.0;
//     myVote = json['my_vote'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['text'] = text;
//     data['_id'] = sId;
//     if (votes != null) {
//       data['votes'] = votes!.map((v) => v.toJson()).toList();
//     }
//     data['total_votes'] = totalVotes;
//     data['button_votes'] = buttonVotes;
//     data['percentage'] = percentage;
//     data['my_vote'] = myVote;
//     return data;
//   }
// }

// class FamilyMembers {
//   String? sId;
//   String? senderId;
//   String? receiverId;
//   String? relation;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;

//   FamilyMembers(
//       {this.sId,
//       this.senderId,
//       this.receiverId,
//       this.relation,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.iV});

//   FamilyMembers.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     senderId = json['sender_id'];
//     receiverId = json['receiver_id'];
//     relation = json['relation'];
//     status = json['status'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['sender_id'] = senderId;
//     data['receiver_id'] = receiverId;
//     data['relation'] = relation;
//     data['status'] = status;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['__v'] = iV;
//     return data;
//   }
// }
