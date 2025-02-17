tableextension 50176 tableextension50176 extends "Detailed CV Ledg. Entry Buffer"
{
    fields
    {
        field(50000; "Model Code"; Code[20])
        {
            Editable = false;
            TableRelation = Model;
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


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 2)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Entry Type" := "Entry Type"::"Initial Entry";
    "Posting Date" := GenJnlLine."Posting Date";
    "Document Type" := GenJnlLine."Document Type";
    #4..11
    "Initial Entry Global Dim. 1" := GenJnlLine."Shortcut Dimension 1 Code";
    "Initial Entry Global Dim. 2" := GenJnlLine."Shortcut Dimension 2 Code";
    "Initial Document Type" := GenJnlLine."Document Type";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..14
    "Model Code" := GenJnlLine."Model Code";
    "Sys. LC No." := GenJnlLine."Sys. LC No.";   //ratan 10/16/2020
    "Receipt Against" := GenJnlLine."Receipt Against"; //Sameer feb 15
    "Credit Type" := GenJnlLine."Credit Type"; //Sameer Feb 17
    "Ship-to Code" := GenJnlLine."Ship-to Code"; //Min >>
    "Ship-to Address" := GenJnlLine."Ship-to Address";
    "Ship-to Address 2" := GenJnlLine."Ship-to Address 2";
    "Ship-to City" := GenJnlLine."Ship-to City";
    "Ship-to Country" := GenJnlLine."Ship-to Country";
    "Province No." := GenJnlLine."Province No.";
    */
    //end;
}

