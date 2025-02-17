tableextension 50413 tableextension50413 extends "Campaign Target Group"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Customer)) Customer
            ELSE
            IF (Type = CONST(Contact)) Contact WHERE(Type = FILTER(' '));
        }
    }
}

