tableextension 50018 tableextension50018 extends "Purch. Rcpt. Header"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name"(Field 5)".


        //Unsupported feature: Property Modification (Data type) on ""Posting Description"(Field 22)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }

        //Unsupported feature: Property Modification (Data type) on ""Buy-from Vendor Name"(Field 79)".


        //Unsupported feature: Property Modification (Data type) on ""Buy-from Vendor Name 2"(Field 80)".

        field(50002; "Battery Job No."; Code[20])
        {
        }
        field(50003; Remarks; Text[250])
        {
        }
        field(50005; Type; Option)
        {
            OptionMembers = " ",Memo;
        }
        field(50006; "Common Value"; Code[20])
        {
        }
        field(70000; "Supplier Code"; Code[10])
        {
            Description = ' QR19.00';
            // TableRelation = Table70000; //no table in nav with 70000 id
        }
        field(70001; "Lot No. Prefix"; Code[20])
        {
            Description = ' QR19.00';
        }
        field(70002; "Cost Type"; Option)
        {
            OptionCaption = ' ,Fixed Cost,Variable Cost';
            OptionMembers = " ","Fixed Cost","Variable Cost";
        }
        field(70071; "Procument Memo No."; Code[20])
        {
            Description = 'Procument Memo';
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(33019810; "Shipping Agent Code"; Code[10])
        {
        }
        field(33019831; "Order Type"; Option)
        {
            OptionCaption = 'Normal,VOR';
            OptionMembers = " ","Local",VOR,Import;
        }
        field(33019869; "Import Purch. Order"; Boolean)
        {
        }
        field(33019870; "Import Purch. Invoice"; Boolean)
        {
        }
        field(33019871; "Import Purch. Cr. Memo"; Boolean)
        {
        }
        field(33019872; "Import Purch. Return Order"; Boolean)
        {
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011; "Sys. LC No."; Code[20])
        {
            Caption = 'LC No.';

            trigger OnValidate()
            var
                LCDetail: Record "LC Details";
                LCAmendDetail: Record "LC Amend. Details";
                Text000: Label 'LC Amendment is not released.';
                Text001: Label 'LC Amendment is closed.';
                Text002: Label 'LC Details is not released.';
                Text003: Label 'LC Details is closed.';
            begin
            end;
        }
        field(33020012; "Bank LC No."; Code[20])
        {
        }
        field(33020013; "LC Amend No."; Code[20])
        {
        }
        field(33020235; "Service Order No."; Code[20])
        {
            Description = 'Used for External Service Order';
        }
        field(33020236; "Vendor Invoice No."; Code[20])
        {
            Editable = false;
        }
        field(33020237; "Veh. Accessories Document"; Boolean)
        {
            Description = 'Used for Vehicle Accessories';
            Editable = false;
        }
        field(33020238; "Veh. Accesories Memo No."; Code[20])
        {
            Description = 'Used for Vehicle Accessories';
            Editable = false;
            TableRelation = "Vehicle Accessories Header"."No.";
        }
        field(33020240; "Purch. VAT No."; Code[20])
        {
            TableRelation = "Exempt Purchase Nos.";
        }
        field(33020601; "Approved User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(33020602; Narration; Text[250])
        {
        }
        field(99008500; "Date Received"; Date)
        {
            Caption = 'Date Received';
        }
        field(99008501; "Time Received"; Time)
        {
            Caption = 'Time Received';
        }
        field(99008507; "BizTalk Purchase Receipt"; Boolean)
        {
            Caption = 'BizTalk Purchase Receipt';
        }
    }
    keys
    {
        key(Key1; "Document Profile")
        {
        }
        key(Key2; "Service Order No.")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    LOCKTABLE;
    PostPurchDelete.DeletePurchRcptLines(Rec);

    PurchCommentLine.SETRANGE("Document Type",PurchCommentLine."Document Type"::Receipt);
    PurchCommentLine.SETRANGE("No.","No.");
    PurchCommentLine.DELETEALL;
    ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ERROR('Posted Purchase Receipt can not be deleted');
    #1..7
    */
    //end;


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

