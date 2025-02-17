tableextension 50293 tableextension50293 extends "CRM Customeraddress"
{
    fields
    {
        modify(ParentId)
        {
            TableRelation = IF (ParentIdTypeCode = CONST(account)) "CRM Account".AccountId
            ELSE
            IF (ParentIdTypeCode = CONST(contact)) "CRM Contact".ContactId;
        }
        modify(OwnerId)
        {
            TableRelation = IF (OwnerIdType = CONST(systemuser)) "CRM Systemuser".SystemUserId
            ELSE
            IF (OwnerIdType = CONST(team)) "CRM Team".TeamId;
        }
    }
}

