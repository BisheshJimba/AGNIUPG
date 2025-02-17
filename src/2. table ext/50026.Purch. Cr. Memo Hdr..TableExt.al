tableextension 50026 tableextension50026 extends "Purch. Cr. Memo Hdr."
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Posting Description"(Field 22)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Paid(Field 1302)".


        //Unsupported feature: Property Modification (CalcFormula) on "Cancelled(Field 1310)".


        //Unsupported feature: Property Modification (CalcFormula) on "Corrective(Field 1311)".

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
            // TableRelation = Table70000;//table  does not exist in nav
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
        field(25006170; "Vehicle Registration No."; Code[30])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE("Serial No." = FIELD("Vehicle Serial No.")));//neet to solve table error
        }
        field(25006378; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';
        }
        field(33019831; "Order Type"; Option)
        {
            OptionCaption = ' ,Local,VOR,Import';
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
        field(33020240; "Purch. VAT No."; Code[20])
        {
            Editable = false;
            TableRelation = "Exempt Purchase Nos.";
        }
        field(33020601; "Approved User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
    }
    keys
    {
        key(Key1; "Document Profile")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    PostPurchDelete.IsDocumentDeletionAllowed("Posting Date");
    LOCKTABLE;
    PostPurchDelete.DeletePurchCrMemoLines(Rec);
    #4..8
    ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
    PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetPurchDeferralDocType,'','',
      PurchCommentLine."Document Type"::"Posted Credit Memo","No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ERROR('Posted Purchase Credit Memo can not be deleted');
    #1..11
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

