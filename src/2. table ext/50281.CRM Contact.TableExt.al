tableextension 50281 tableextension50281 extends "CRM Contact"
{
    fields
    {
        modify(OwnerId)
        {
            TableRelation = IF (OwnerIdType = CONST(systemuser)) "CRM Systemuser".SystemUserId
            ELSE
            IF (OwnerIdType = CONST(team)) "CRM Team".TeamId;
        }
        modify(ParentCustomerId)
        {
            TableRelation = IF (ParentCustomerIdType = CONST(account)) "CRM Account".AccountId
            ELSE
            IF (ParentCustomerIdType = CONST(contact)) "CRM Contact".ContactId;
        }
    }
}

