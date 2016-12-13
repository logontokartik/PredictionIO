public with sharing class PredictionIO
{
    
public static NextBestOffer calloutToPredictionIO (String fName, String lName, String CustomerID ){
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('https://neuraflash-demo-cirrus-dev.herokuapp.com/api/NextBestAction');
request.setMethod('POST');
request.setHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');


String JsonBody = 'NextBestAction={'+'\"'+'customerName'+'\"' + ': ' +  '\"' + fName + '%20' + lName + '\"' + ','+ '\"'+ 'customerId' + '\"' +': '+'\"'+CustomerID+'\"'+'}';
System.debug('JsonBody--->' + JsonBody);
// Set the body as a JSON object
if ((fName !=null || lName !=null) && CustomerID !=null )
request.setBody(JsonBody);
else
request.setBody('NextBestAction={"customerName": "Natali%20Flas","customerId": "1234" }');

System.debug('request Sent to IO' + request);
HttpResponse response = http.send(request);
// Parse the JSON response
if (response.getStatusCode() != 200) {
    System.debug('The status code returned was not expected: ' +
        response.getStatusCode() + ' ' + response.getStatus());
} else {
    System.debug(response.getBody());
}

NextBestOffer result = NextBestOffer.parse(response.getBody());
return result;
}
}