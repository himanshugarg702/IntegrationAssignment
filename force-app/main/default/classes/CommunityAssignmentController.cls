global class CommunityAssignmentController {

  
   
    @AuraEnabled
    global static String checkPortal(String username, String password) {
        System.debug(username);
        System.debug(password);
        try {
            ApexPages.PageReference lgn =
            Site.login(username,
            password, '');
            aura.redirect(lgn);
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();
        }
    }
    
     @AuraEnabled
     public static WrapperForUserInformation getUserInformation(){
        WrapperForUserInformation user=new WrapperForUserInformation();
        user.userName=UserInfo.getUserName();
        user.Name=UserInfo.getName();
        user.contactId=UserInfo.getUserId();
        return user;
//         // Id profileId= userinfo.getProfileId();
//          String FirstName = UserInfo.getFirstName();//Returns the context user's first name.
//         System.Debug('FirstName-' + FirstName);
//         String FirstName = UserInfo.getFirstName();//Returns the context user's first name.
//         System.Debug('FirstName-' + FirstName);
// String LastName = UserInfo.getLastName();//Returns the context user's last name.
// System.Debug('LastName-' + LastName);
// String Name = UserInfo.getName();//Returns the context user's full name.
// System.Debug('Name-' + Name);
// String UserEmail = UserInfo.getUserEmail();//Returns the current user’s email address.
// System.Debug('UserEmail-' + UserEmail);
// String UserType = UserInfo.getUserType();//Returns the context user's type.
// System.Debug('UserType-' + UserType);
// String UserId = UserInfo.getUserId();//Returns the context user's ID.
// System.Debug('UserId-' + UserId);
// String UserName = UserInfo.getUserName();//Returns the context user's login name.
// System.Debug('UserName-' + UserName);
// String ProfileId = UserInfo.getProfileId();//Returns the context user's profile ID.
// System.Debug('ProfileId-' + ProfileId);
// String UserRoleId = UserInfo.getUserRoleId();//Returns the context user's role ID.
// System.Debug('UserRoleId-' + UserRoleId);
// String SessionId = UserInfo.getSessionId();//Returns the session ID for the current session.
// System.Debug('SessionId-' + SessionId);
//         String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
//         system.debug('ProfileName'+profileName);
//         return profileName;
     }
     public class WrapperForUserInformation{
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String userName{get;set;}
        @AuraEnabled
        public String contactId{get;set;}
        // public WrapperForUserInformation(String Name,String userName, String contactId){
        //     this.Name=Name;
        //     this.userName=userName;
        //     this.contactId=contactId;
        // }
     }
    // @AuraEnabled
    // global static String forgotPassowrd(
    // String username) {
    // String procesMsg = '';
     
    // if (Site.isValidUsername(
    // username)) {
     
    // Site.forgotPassword(
    // username);
    // procesMsg = Label.LoginResetSuccess;
    // }
    // else {
     
    // procesMsg = Label.LoginResetWarning;
    // }
     
    // return procesMsg;
     
    // }
    }
// global class CommunityAssignmentController {
    
//     public CommunityAssignmentController() {
        
//     }

//     @AuraEnabled
//     public static String login(String username, String password, String startUrl) {
//         try{
//             ApexPages.PageReference lgn = Site.login(username, password, startUrl);
//             aura.redirect(lgn);
//             return null;
//         }
//         catch (Exception ex) {
//             return ex.getMessage();            
//         }
//     }
    
//     @AuraEnabled
//     public static Boolean getIsUsernamePasswordEnabled() {
//         Auth.AuthConfiguration authConfig = getAuthConfig();
//         return authConfig.getUsernamePasswordEnabled();
//     }

//     @AuraEnabled
//     public static Boolean getIsSelfRegistrationEnabled() {
//         Auth.AuthConfiguration authConfig = getAuthConfig();
//         return authConfig.getSelfRegistrationEnabled();
//     }

//     @AuraEnabled
//     public static String getSelfRegistrationUrl() {
//         Auth.AuthConfiguration authConfig = getAuthConfig();
//         if (authConfig.getSelfRegistrationEnabled()) {
//             return authConfig.getSelfRegistrationUrl();
//         }
//         return null;
//     }

//     @AuraEnabled
//     public static String getForgotPasswordUrl() {
//         Auth.AuthConfiguration authConfig = getAuthConfig();
//         return authConfig.getForgotPasswordUrl();
//     }
    
//     @TestVisible
//     private static Auth.AuthConfiguration getAuthConfig(){
//         Id networkId = Network.getNetworkId();
//         Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');
//         return authConfig;
//     }

//     @AuraEnabled
//     global static String setExperienceId(String expId) {
//         // Return null if there is no error, else it will return the error message 
//         try {
//             if (expId != null) {
//                 Site.setExperienceId(expId);
//             }
//             return null; 
//         } catch (Exception ex) {
//             return ex.getMessage();            
//         }
//     }   
// }