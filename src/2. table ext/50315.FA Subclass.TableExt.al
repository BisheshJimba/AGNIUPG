tableextension 50315 tableextension50315 extends "FA Subclass"
{
    fields
    {

        //Unsupported feature: Property Modification (Name) on ""FA Class Code"(Field 3)".

        field(50000; "FA Class Code"; Code[10])
        {
            TableRelation = "FA Class".Code;
        }
        field(50001; "FA Posting Group"; Code[10])
        {
            TableRelation = "FA Posting Group".Code;
        }
        field(50002; "Depreciation Book"; Code[10])
        {
            TableRelation = "Depreciation Book".Code;
        }
        field(50003; "Depreciation Method"; Option)
        {
            Caption = 'Depreciation Method';
            OptionCaption = 'Straight-Line,Declining-Balance 1,Declining-Balance 2,DB1/SL,DB2/SL,User-Defined,Manual';
            OptionMembers = "Straight-Line","Declining-Balance 1","Declining-Balance 2","DB1/SL","DB2/SL","User-Defined",Manual;
        }
        field(50004; "Depreciation Rate"; Decimal)
        {
        }
    }
}

