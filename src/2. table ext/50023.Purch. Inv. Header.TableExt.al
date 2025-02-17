tableextension 50023 tableextension50023 extends "Purch. Inv. Header"
{

    //Unsupported feature: Property Insertion (Permissions) on ""Purch. Inv. Header"(Table 122)".

    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name"(Field 5)".


        //Unsupported feature: Property Modification (Data type) on ""Posting Description"(Field 22)".


        //Unsupported feature: Property Modification (Data type) on ""Invoice Disc. Code"(Field 37)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }

        //Unsupported feature: Property Modification (Data type) on ""Buy-from Vendor Name"(Field 79)".


        //Unsupported feature: Property Modification (CalcFormula) on "Closed(Field 1302)".


        //Unsupported feature: Property Modification (CalcFormula) on "Cancelled(Field 1310)".


        //Unsupported feature: Property Modification (CalcFormula) on "Corrective(Field 1311)".

        field(50000; "Pragyapan Patra No."; Code[20])
        {
        }
        field(50001; "Import Invoice No."; Code[20])
        {
            Editable = false;
            TableRelation = "Purch. Inv. Header";
        }
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
        field(50098; "Sales Order Created"; Boolean)
        {
            Description = '//Used for GPD Sales Order';
        }
        field(50099; VIN; Code[20])
        {
            Description = '//Used for Service';
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Posted Serv. Order Header".VIN WHERE("Order No." = FIELD("Service Order No.")));//need to solve table error
        }
        field(70000; "Supplier Code"; Code[10])
        {
            Description = ' QR19.00';
            // TableRelation = Table70000;//no table with this id
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
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE("Serial No." = FIELD("Vehicle Serial No.")));//need to solve table error
        }
        field(25006378; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';
        }
        field(33019810; "Shipping Agent Code"; Code[10])
        {
            TableRelation = "Shipping Agent";
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
        field(33019962; "TDS Posting Group"; Code[20])
        {
            TableRelation = "TDS Posting Group";
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
            Editable = true;
            TableRelation = "Posted Serv. Order Header";
            ValidateTableRelation = false;
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
            Editable = true;
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
    PostPurchDelete.IsDocumentDeletionAllowed("Posting Date");
    LOCKTABLE;
    PostPurchDelete.DeletePurchInvLines(Rec);
    #4..8
    ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
    PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetPurchDeferralDocType,'','',
      PurchCommentLine."Document Type"::"Posted Invoice","No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ERROR('Posted Purchase Invoice can not be deleted.');
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


    //Unsupported feature: Code Modification on "ShowCorrectiveCreditMemo(PROCEDURE 19)".

    //procedure ShowCorrectiveCreditMemo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CALCFIELDS(Cancelled);
    IF NOT Cancelled THEN
      EXIT;

    IF CancelledDocument.FindPurchCancelledInvoice("No.") THEN BEGIN
      PurchCrMemoHdr.GET(CancelledDocument."Cancelled By Doc. No.");
      PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
      PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHdr);
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "ShowCancelledCreditMemo(PROCEDURE 5)".

    //procedure ShowCancelledCreditMemo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CALCFIELDS(Corrective);
    IF NOT Corrective THEN
      EXIT;

    IF CancelledDocument.FindPurchCorrectiveInvoice("No.") THEN BEGIN
      PurchCrMemoHdr.GET(CancelledDocument."Cancelled Doc. No.");
      PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
      PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHdr);
    END;
    */
    //end;

    procedure CreateSalesOrder(var PurchInvHeader: Record "Purch. Inv. Header")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchInvLine: Record "Purch. Inv. Line";
        OrderCreated: Boolean;
        Text000: Label 'Sales Order %1 is Created.';
        Text001: Label 'Sales Order has already been created.';
        Text002: Label 'There is no item within the filter.';
    begin
        IF NOT PurchInvHeader."Sales Order Created" THEN BEGIN
            SalesHeader.RESET;
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
            SalesHeader."No." := '';
            SalesHeader."Posting Date" := TODAY;
            SalesHeader.INSERT(TRUE);
            PurchSetup.GET;
            SalesHeader.VALIDATE("External Document No.", PurchInvHeader."No.");
            SalesHeader.VALIDATE("Sell-to Customer No.", PurchSetup."GPD Internal Customer");
            SalesHeader.VALIDATE("Location Code", PurchInvHeader."Location Code");
            SalesHeader.VALIDATE("Shortcut Dimension 1 Code", PurchInvHeader."Shortcut Dimension 1 Code");
            SalesHeader.VALIDATE("Shortcut Dimension 2 Code", PurchInvHeader."Shortcut Dimension 2 Code");
            SalesHeader.MODIFY;
            PurchInvLine.RESET;
            PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
            PurchInvLine.SETRANGE(Type, PurchInvLine.Type::Item);
            IF PurchInvLine.FINDSET THEN BEGIN
                REPEAT
                    IF PurchInvLine.Type = PurchInvLine.Type::Item THEN BEGIN
                        CLEAR(SalesLine);
                        SalesLine.INIT;
                        SalesLine."Document Type" := SalesLine."Document Type"::Order;
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine."Line No." := PurchInvLine."Line No.";
                        SalesLine.VALIDATE(Type, PurchInvLine.Type);
                        SalesLine.VALIDATE("No.", PurchInvLine."No.");
                        SalesLine.VALIDATE(Quantity, PurchInvLine.Quantity);
                        SalesLine.VALIDATE("Unit of Measure Code", PurchInvLine."Unit of Measure Code");
                        SalesLine.VALIDATE("Location Code", PurchInvLine."Location Code");
                        SalesLine.VALIDATE("Responsibility Center", PurchInvLine."Responsibility Center");
                        SalesLine.INSERT(TRUE);
                        SalesLine.VALIDATE("Shortcut Dimension 1 Code", PurchInvLine."Shortcut Dimension 1 Code");
                        SalesLine.VALIDATE("Shortcut Dimension 2 Code", PurchInvLine."Shortcut Dimension 2 Code");
                        SalesLine.MODIFY;
                        OrderCreated := TRUE;
                    END;
                UNTIL PurchInvLine.NEXT = 0
            END
            ELSE
                ERROR(Text002);

            IF OrderCreated THEN BEGIN
                PurchInvHeader."Sales Order Created" := TRUE;
                PurchInvHeader.MODIFY;
                MESSAGE(Text000, SalesHeader."No.");
            END;
        END
        ELSE
            ERROR(Text001);
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
}

