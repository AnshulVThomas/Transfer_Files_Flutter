
class CharImg {
  String iconpath;


CharImg({required this.iconpath});
static List<CharImg> getChar(){
  List<CharImg> Character=[];

  Character.add(
    CharImg(iconpath: "assets/characters/magician.svg"),
  );
   Character.add(
    CharImg(iconpath: "assets/characters/wiz.svg"),
  );
  
  return Character;
}
}