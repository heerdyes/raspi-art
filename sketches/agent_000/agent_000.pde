class Agent{
  String political_leaning="right";
  int num_years_in_education=12;
  int salary=30000;
  Agent[] neighbors;
  Agent[] coworkers;
  Agent[] friends;
  
  Agent(){
    num_years_in_education=11+int(random(8));
    if(num_years_in_education<13){
      if(random(1)>0.8){
        political_leaning="right";
      }else{
        political_leaning="left";
      }
    }else{
      if(random(1)>0.3){
        political_leaning="right";
      }else{
        political_leaning="left";
      }
    }
  }
  
  boolean isHappy(){
    if(political_leaning=="right"){
      if(salary>60000){
        return true;
      }else{
        return false;
      }
    }else{
      if(friends.length>25){
        return true;
      }else{
        return false;
      }
    }
  }
}
