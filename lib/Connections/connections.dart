class Active {
  String iconpath;
  String username;
  bool inTransfer=false;
  String filename="dummy";
  int progress =0;


Active({required this.iconpath,required this.username});
static List<Active> getActive(){
  List<Active> profile=[];
  profile.add(
    Active(iconpath: "assets/characters/magician.svg", username: "Dummy")
  );
   profile.add(
    Active(iconpath: "assets/characters/wiz.svg", username: "Dummy2")
  );
profile.add(
    Active(iconpath: "assets/characters/default.svg", username: "Default")
  );
  


  return profile;
}
}