trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
    If (trigger.isbefore && trigger.isinsert){
        For (Account acc : trigger.new){
            If (acc.Type == null){
                acc.Type = 'Prospect';
            } 
            If (acc.ShippingCity != null && acc.ShippingStreet != null && acc.ShippingState != null && acc.ShippingCountry != null && acc.ShippingPostalCode != null){
                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingCountry = acc.ShippingCountry;
                acc.BillingPostalCode = acc.ShippingPostalCode;
            }
            If(acc.Phone != null && acc.Website != null && acc.Fax != null){
                acc.Rating = 'Hot';
            }
        }
        }
    
    
    List<Contact> newContacts = new List<Contact>();
    If(Trigger.isAfter && Trigger.isInsert){
        For (Account acc : trigger.new){
            newContacts.add(new Contact(
                AccountId = acc.Id,
                LastName = 'DefaultContact',
                Email = 'default@email.com'));
        }
        Insert newContacts;
        }
    }

    

