tableextension 50172 tableextension50172 extends "Detailed Cust. Ledg. Entry"
{
    //   20.11.2014 EB.P8 MERGE
    fields
    {

        //Unsupported feature: Property Modification (OptionString) on ""Entry Type"(Field 3)".

        field(50000; "Model Code"; Code[20])
        {
            TableRelation = Model.Code;
        }
        field(50001; "Sys. LC No."; Code[20])
        {
            Caption = 'LC No.';
            Editable = false;
            TableRelation = "LC Details";
        }
        field(50002; "Receipt Against"; Option)
        {
            OptionCaption = 'Normal,LC,BG';
            OptionMembers = Normal,LC,BG;
        }
        field(50003; "Credit Type"; Option)
        {
            OptionCaption = ' ,BG,LC,Normal';
            OptionMembers = " ",BG,LC,Normal;
        }
        field(50004; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';

            trigger OnValidate()
            var
                ShipToAddr: Record "222";
            begin
            end;
        }
        field(50005; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(50006; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(50007; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(50008; "Ship-to Country"; Text[30])
        {
        }
        field(50009; "Province No."; Option)
        {
            OptionCaption = ' ,Province 1, Province 2, Bagmati Province, Gandaki Province, Province 5, Karnali Province, Sudur Pachim Province ';
            OptionMembers = " ","Province 1"," Province 2"," Bagmati Province"," Gandaki Province"," Province 5"," Karnali Province"," Sudur Pachim Province";
        }
    }
    keys
    {
        key(Key1; "Cust. Ledger Entry No.", "Initial Entry Due Date", "Posting Date")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
    }
}

