public class MessageMaker {
           
    	
    		public static void helloMessage() {
            
                String x = 'The !shorn! sheep !sprang!.';
                System.debug (x.endsWith('.'));
                System.debug (x.length());
                System.debug (x.substring(5,10));
                System.debug (x.replaceAll ('!(.*?)!', '$1'));
          
            }     
     
}