class Complexdatatypes {
  var grades = [1.0, 1.25, 1.5, 1.75] ;

  List<Map<String, dynamic>> userAccounts = [
    {'id' : 1, 'username' : 'skibidy', 'password' : 'rotbrain'},
    {'id' : 2, 'username' : 'toilet', 'password' : 'brainrot'},
    {'id' : 3, 'username' : '67', 'password' : 'k1llj0y'},
    {'id' : 4, 'username' : 'tungtung', 'password' : 's4hur'}
  ];
  void displayGrade() {

    for (int i = 0 ; i < 4 ; i++) {
      var grader = grades[i] ;
      var n = i + 1 ;
      print("$n : $grader") ;
    }
  }
}