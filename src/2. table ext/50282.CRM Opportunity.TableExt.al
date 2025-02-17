tableextension 50282 tableextension50282 extends "CRM Opportunity"
{
    fields
    {
        modify(CustomerId)
        {
            TableRelation = IF (CustomerIdType = CONST(account)) "CRM Account".AccountId
            ELSE
            IF (CustomerIdType = CONST(contact)) "CRM Contact".ContactId;
        }
        modify(OwnerId)
        {
            TableRelation = IF (OwnerIdType = CONST(systemuser)) "CRM Systemuser".SystemUserId
            ELSE
            IF (OwnerIdType = CONST(team)) "CRM Team".TeamId;
        }
    }
}

