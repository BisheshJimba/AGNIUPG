tableextension 50254 tableextension50254 extends "Customer Template"
{
    fields
    {
        modify("Territory Code")
        {
            TableRelation = "Dealer Segment Type";
        }
        field(25006000; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
            InitValue = true;
        }
        field(25006001; Reserve; Option)
        {
            Caption = 'Reserve';
            InitValue = Optional;
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
    }
}

