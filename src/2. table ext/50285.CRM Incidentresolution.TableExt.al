tableextension 50285 tableextension50285 extends "CRM Incidentresolution"
{
    fields
    {
        modify(OwnerId)
        {
            TableRelation = IF (OwnerIdType = CONST(systemuser)) "CRM Systemuser".SystemUserId
            ELSE
            IF (OwnerIdType = CONST(team)) "CRM Team".TeamId;
        }
    }
}

