public class RaceResultTriggerHandler {
    
    // Method to Update points on Race result object
    Public static void handlerBeforeInsert(List <Race_Result__c> newRaceResult){
        //List to bulkify records
        List<Race_Result__c> resultToUpdate = new List <Race_result__c>();
        //Iterate through incoming parameter list
        for(Race_Result__c result : newRaceResult){
            Integer points = calculatePoints(result);
            result.points_Earned__c = points;
            //Add result in List
            resultToUpdate.add(result);   
        }
    }
    // method to update points on driver object
    Public static void handlerAfterInsert(List<Race_Result__c> newRaceResult){
        List<Driver__c> driverToUpdate = new List<Driver__c>();
        for(Race_Result__c result : newRaceResult){
            Decimal previousPoints;
            Driver__c driverRecord = [select points_earned__c from driver__c where id =:result.Driver__c];
            if(driverRecord != Null){
                previousPoints = driverRecord.points_earned__c;
            }
            Integer points = calculatePoints(result);
            if(result.Driver__c != Null){
                Driver__c d = new driver__c ();
                d.id = result.Driver__c;
                d.Points_Earned__c = previousPoints +  points;
                driverToUpdate.add(d);
            }
            
        }
        update driverToUpdate;
        
    }
    
    // before delete a rece record subtract point from driver
    public static void handlerBeforeDelete(List<Race_result__c> raceResults){
        List<driver__c> driverToUpdate = new List <driver__c>();
        For(Race_result__c result : raceResults){
            decimal previousPoints;
            driver__c driverRecord = [select points_earned__c from driver__c where id =:result.Driver__c];
            if(driverRecord != Null){
                previousPoints = driverRecord.Points_Earned__c;
                
            }
            if(result.driver__c != Null){
                driver__c driver = new driver__C();
                driver.id = result.Driver__c;
                driver.points_earned__c = previousPoints - result.Points_Earned__c;
                driverToUpdate.add(driver);
            }
        }
        if(!driverToUpdate.isEmpty()){
            update driverToUpdate;
        }
    }
    
    
    
    
    
    
    
    
    
    // Method to decide points
    public static integer calculatePoints(Race_Result__c raceResult){
        Integer points = 0;
        Integer Position = Integer.valueOf(raceResult.Position__c);
            If(Position == 1){
                points = 25;
            }
            else if(Position == 2){
                Points = 18;
            }
            else if(Position == 3){
                Points = 15;
            }
            else if(Position == 4){
                Points = 12;
            }
            else if(Position == 5){
                Points = 10;
            }
            else if(Position == 6){
                Points = 8;
            }
            else if(Position == 7){
                Points = 6;
            }
            else if(Position == 8){
                Points = 4;
            }
            else if(Position == 9){
                Points = 2;
            }
            else if(Position == 10){
                Points = 1;
            }
            else{
                Points = 0;
            }
            if(raceResult.Fastest_Lap__c == True){
                Points += 1;
            } 
        return Points;
    }
    Public static integer calculatePoints (Id driverID){
        Integer totalPoints = 0;
        List<Race_Result__c> raceResult = [Select position__c, Fastest_Lap__c from Race_result__c where driver__c = : driverID ];
        for(Race_result__c result : raceResult){
            totalPoints += calculatePoints(result);
            
        }
        return totalPoints; 
        
    }

}