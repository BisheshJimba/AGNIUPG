tableextension 50227 tableextension50227 extends "Rlshp. Mgt. Comment Line"
{
    fields
    {
        modify("Table Name")
        {
            OptionCaption = 'Contact,Campaign,To-do,Web Source,Sales Cycle,Sales Cycle Stage,Opportunity,Recall Campaign';

            //Unsupported feature: Property Modification (OptionString) on ""Table Name"(Field 1)".

        }
        modify("No.")
        {
            TableRelation = IF (Table Name=CONST(Contact)) Contact
                            ELSE IF (Table Name=CONST(Campaign)) Campaign
                            ELSE IF (Table Name=CONST(To-do)) To-do
                            ELSE IF (Table Name=CONST(Web Source)) "Web Source"
                            ELSE IF (Table Name=CONST(Sales Cycle)) "Sales Cycle"
                            ELSE IF (Table Name=CONST(Sales Cycle Stage)) "Sales Cycle Stage"
                            ELSE IF (Table Name=CONST(Opportunity)) Opportunity;
        }
    }
}

