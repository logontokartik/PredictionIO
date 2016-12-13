public with sharing class ImageController {
  

 Public id accRecId;
 Public contact accRec{get;set;}   
 public  String imageURL{get;set;}
 Public  Integer seconds{get;set;}
 Public  String OfferName {get;set;}
 public NextBestOffer NextBestOfferData {get;set;}
 public Decimal count {get; set;}
 
 public Map<String,ProductImages__c> productImageMap {get;set;}   
    
    
    public void increment(){
        count++;
    }
 
  Public void CounterMethod(){
  
   // predictionIO.calloutToPredictionIO(); 
   // this.NextBestOfferData = predictionIO.calloutToPredictionIO (accRec.Name, accRec.Contactid__c);
  //  seconds = seconds + 2;
    imageURL='/servlet/servlet.FileDownload?file=';
    List< document > documentList=[select name from document where 
                                    Name='SamplePic'];
   
    if(documentList.size()>0)
    {
      imageURL=imageURL+documentList[0].id;
    }
  }
   public void ImageController1()
  { 
  //  seconds = 10;
    
    if(ApexPages.currentPage().getParameters().get('id') != null) {
   
     accRecId = [select id,contactid from case where id = :ApexPages.currentPage().getParameters().get('id')].contactid;
      if(accRecId != null)
         accRec = [select id,name,contactID__c,FirstName,LastName from contact where id =:accRecId];
         String cfname = '' ;
         String clname = '' ;
         String ContactId = '';
         if(accRec == null){
         cfname = 'Sandeep';
         clname ='Singh'    ;
         contactId= '9874';
         }
         else
         {
          cfname = accRec.FirstName ;
          clname = accRec.LastName ;
          ContactId = accRec.contactID__c;
         }
        // if ( count ==2 )
         this.NextBestOfferData = predictionIO.calloutToPredictionIO (cfname,clname, contactId );
         
         
   }
    
   // return null;
  }
  public ImageController()
  { 
  //  seconds = 10;
    count = 1;
    productImageMap = new Map<String,ProductImages__c>();
    
    for (ProductImages__c pi : ProductImages__c.getAll().values()) {
      productImageMap.put(pi.Name,pi);
    }

   // if(ApexPages.currentPage().getParameters().get('id') != null) {
   
   //  accRecId = [select id,contactid from case where id = :ApexPages.currentPage().getParameters().get('id')].contactid;
   //   if(accRecId != null)
   //      accRec = [select id,name,contactID__c,FirstName,LastName from contact where id =:accRecId];
   //      String cfname = '' ;
   //      String clname = '' ;
   //      String ContactId = '';
   //      if(accRec == null){
   //      cfname = 'Sandeep';
   //      clname ='Singh'    ;
   //      contactId= '9874';
   //      }
   //      else
   //      {
   //       cfname = accRec.FirstName ;
   //       clname = accRec.LastName ;
   //       ContactId = accRec.contactID__c;
   //      }
         
         
   //      this.NextBestOfferData = predictionIO.calloutToPredictionIO (cfname,clname, contactId );
         
         
   //}
  }

  @RemoteAction
  public static List<ProductImages__c> allSettings() {
    return ProductImages__c.getAll().values();
  }

  @RemoteAction
  public static List<PredictiveActions__c> allActions() {
    return PredictiveActions__c.getAll().values();
  }

  @RemoteAction
  public static NextBestOffer calltoNextBestOffer(String caseId) {
      
      Case theCase;
      
      try {
        theCase = [Select Id, ContactId, Contact.FirstName, Contact.LastName, Contact.Contactid__c FROM Case where id = :caseId];
      } catch (Exception ex) {

      }
      
      String cfname = '' ;
      String clname = '' ;
      String ContactId = '';
       
      if(theCase == null){
         cfname = 'Sandeep';
         clname ='Singh'    ;
         contactId= '9874';
      }
      else
      {
        cfname = theCase.Contact.FirstName ;
        clname = theCase.Contact.LastName ;
        ContactId = theCase.Contact.contactID__c;
      }
         
      NextBestOffer nextBestOfferData = predictionIO.calloutToPredictionIO (cfname,clname, contactId ); 
      nextBestOfferData.recommendation = new List<NextBestOffer.cls_recommendation>();
      String currentProvider = DemoSettings__c.getOrgDefaults().Provider__c;

      if (!String.isBlank(currentProvider)) {
        for (ProductImages__c pi : ProductImages__c.getAll().values()) {
          if (pi.Provider__c.equalsIgnoreCase(currentProvider)) {
            NextBestOffer.cls_recommendation recm = new NextBestOffer.cls_recommendation();
            recm.product = pi.Name;
            nextBestOfferData.recommendation.add(recm);
          }

        }        
      } else {
        // Defaults in case of any issues with currentProvider.
        NextBestOffer.cls_recommendation vpsHosting = new NextBestOffer.cls_recommendation();
        vpsHosting.product = 'VPSHosting';

        NextBestOffer.cls_recommendation dedicatedHosting = new NextBestOffer.cls_recommendation();
        dedicatedHosting.product = 'DedicatedHosting';
        nextBestOfferData.recommendation.add(vpsHosting);
        nextBestOfferData.recommendation.add(dedicatedHosting);
      }
      return nextBestOfferData;

  }

  @RemoteAction
  public static List<String> callToNextBestAction(String acctId) {
    String currentProvider = DemoSettings__c.getOrgDefaults().Provider__c;
    List<String> actions = new List<String>();
    
    if (!String.isBlank(currentProvider)) {
      for (PredictiveActions__c pa : PredictiveActions__c.getAll().values()) {
        if (pa.Provider__c.equalsIgnoreCase(currentProvider)) {
          actions.add(pa.Name);
        }
      }
    } else {
      // Defaults in case of any issues with currentProvider.
      actions.add('LocalInternetConnection');
      actions.add('UpgradeHosting');
    }

    return actions;
  }

  
}