class Active {
  String iconpath="assets/characters/magician.svg";
  String username="";
  String ip;
  String port;
  String mode;
  bool inTransfer=false;
  String filename="";
  int progress =0;
  static List<Active> profile=[];


Active({required this.ip,required this.port,required this.mode});
static List<Active> getActive(){
 
   if (profile.isEmpty) {
    Active a=Active(ip: "demo", port: "demo", mode: "demo");
    a.username="demo";

    addActive(a);

  }


  return profile;
}

static addActive(Active a){
   
 
  profile.add(a);
  print("profile Added");
}
}