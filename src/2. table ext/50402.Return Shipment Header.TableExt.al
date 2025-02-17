tableextension 50402 tableextension50402 extends "Return Shipment Header"
{
    fields
    {
        modify("Pay-to City")
        {
            TableRelation = IF (Pay-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
        }
        modify("Ship-to City")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Posting Description"(Field 22)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }
        modify("Buy-from City")
        {
            TableRelation = IF (Buy-from Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
        }
        modify("Pay-to Post Code")
        {
            TableRelation = IF (Pay-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
        }
        modify("Buy-from Post Code")
        {
            TableRelation = IF (Buy-from Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
        }
        modify("Ship-to Post Code")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(33019831;"Order Type";Option)
        {
            OptionCaption = ' ,Local,VOR,Import';
            OptionMembers = " ","Local",VOR,Import;
        }
        field(33019869;"Import Purch. Order";Boolean)
        {
        }
        field(33019870;"Import Purch. Invoice";Boolean)
        {
        }
        field(33019871;"Import Purch. Cr. Memo";Boolean)
        {
        }
        field(33019872;"Import Purch. Return Order";Boolean)
        {
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            Caption = 'LC No.';

            trigger OnValidate()
            var
                LCDetail: Record "33020012";
                LCAmendDetail: Record "33020013";
                Text000: Label 'LC Amendment is not released.';
                Text001: Label 'LC Amendment is closed.';
                Text002: Label 'LC Details is not released.';
                Text003: Label 'LC Details is closed.';
            begin
            end;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
        }
        field(33020013;"LC Amend No.";Code[20])
        {
        }
        field(33020240;"Purch. VAT No.";Code[20])
        {
            TableRelation = "Exempt Purchase Nos.";
        }
        field(33020601;"Approved User ID";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
    }
    keys
    {
        key(Key1;"Document Profile")
        {
        }
    }


    //Unsupported feature: Code Modification on "SetSecurityFilterOnRespCenter(PROCEDURE 4)".

    //procedure SetSecurityFilterOnRespCenter();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF UserSetupMgt.GetPurchasesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
          FILTERGROUP(0);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        {
        #1..5
        }
        */
    //end;
}

