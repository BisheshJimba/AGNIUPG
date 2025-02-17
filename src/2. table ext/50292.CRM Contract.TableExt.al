tableextension 50292 tableextension50292 extends "CRM Contract"
{
    fields
    {
        modify(CustomerId)
        {
            TableRelation = IF (CustomerIdType = CONST(account)) "CRM Account".AccountId
            ELSE
            IF (CustomerIdType = CONST(contact)) "CRM Contact".ContactId;
        }
        modify(BillingCustomerId)
        {
            TableRelation = IF (BillingCustomerIdType = CONST(account)) "CRM Account".AccountId
            ELSE
            IF (BillingCustomerIdType = CONST(contact)) "CRM Contact".ContactId;
        }
        modify(OwnerId)
        {
            TableRelation = IF (OwnerIdType = CONST(systemuser)) "CRM Systemuser".SystemUserId
            ELSE
            IF (OwnerIdType = CONST(team)) "CRM Team".TeamId;
        }
    }
}

