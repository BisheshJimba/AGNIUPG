tableextension 50098 tableextension50098 extends "Cust. Ledger Entry"
{
    // 22.05.2014 EDMS P8
    //   * MERGE with last changes
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".


        //Unsupported feature: Property Modification (CalcFormula) on "Amount(Field 13)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Remaining Amount"(Field 14)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Original Amt. (LCY)"(Field 15)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Remaining Amt. (LCY)"(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amount (LCY)"(Field 17)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal.Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount"(Field 58)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount"(Field 59)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount (LCY)"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount (LCY)"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Original Amount"(Field 75)".

        field(50000; VIN; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));

            trigger OnValidate()
            var
                tcAMT001: Label 'This VIN is being used in %1! Are you shore that you want to use exactly this VIN?';
                tcAMT002: Label 'Serial No. in Vehicle table differs from Serial No. in Sales Line!';
            begin
            end;
        }
        field(50001; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No';
            Editable = false;
        }
        field(50002; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(50004; "Sales Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order),
                                                      "Document Profile" = CONST("Vehicles Trade"));
        }
        field(50005; "Document Class"; Option)
        {
            Caption = 'Document Class';
            Editable = false;
            OptionCaption = ' ,Customer,Vendor,Bank Account';
            OptionMembers = " ",Customer,Vendor,"Bank Account";
        }
        field(50006; "Document Subclass"; Code[20])
        {
            Caption = 'Document Subclass';
            Editable = false;
            TableRelation = IF ("Document Class" = CONST(Customer)) Customer
            ELSE IF ("Document Class" = CONST(Vendor)) Vendor
            ELSE IF ("Document Class" = CONST("Bank Account")) "Bank Account";
        }
        field(50007; "Created by"; Code[50])
        {
            Editable = false;
        }
        field(50055; "Invertor Serial No."; Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(50056; "Receipt Against"; Option)
        {
            OptionCaption = 'Normal,LC,BG';
            OptionMembers = Normal,LC,BG;
        }
        field(50099; "Sales Invoice No."; Code[20])
        {
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(33020017; "Financed By"; Code[20])
        {
            Description = 'Financed Bank';
            Editable = true;
            TableRelation = Contact;
        }
        field(33020018; "Re-Financed By"; Code[20])
        {
            Description = 'Re-Financed By';
            Editable = false;
            TableRelation = Contact;
        }
        field(33020019; "Financed Amount"; Decimal)
        {
            Editable = true;
        }
        field(33020062; "VF Posting Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Principal,Interest,Penalty,Service Charge,Insurance,Other Charges';
            OptionMembers = " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges";
        }
        field(33020063; "Loan File No."; Code[10])
        {
            Editable = false;
            TableRelation = "Vehicle Finance Header"."Loan No.";
        }
        field(33020065; Narration; Text[250])
        {
            Editable = false;
        }
        field(33020235; "Job Type"; Code[20])
        {
            Editable = false;
        }
        field(33020236; "Make Code"; Code[20])
        {
            Editable = false;
            TableRelation = Make;
        }
        field(33020237; "Model Code"; Code[20])
        {
            Editable = false;
            TableRelation = Model.Code;
        }
        field(33020244; "Debit Note No."; Code[20])
        {
        }
        field(33020245; "Credit Note No."; Code[20])
        {
        }
        field(33020252; "Scheme Code"; Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253; "Membership No."; Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020254; "Vehicle Reg. No."; Code[30])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle."Registration No." WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(33020255; "Bank LC No."; Code[30])
        {
            Caption = 'Bank Lc No.';
        }
        field(33020256; "Credit Type"; Option)
        {
            OptionCaption = ' ,BG,LC,Normal';
            OptionMembers = " ",BG,LC,Normal;
        }
        field(33020257; "Sys. LC No."; Code[20])
        {

            trigger OnValidate()
            var
                LCAmendDetail: Record "LC Amend. Details";
                LCDetail: Record "LC Details";
                Text33020011: Label 'LC Amendment is not released.';
                Text33020012: Label 'LC Amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
            end;
        }
        field(33020258; "Province No."; Option)
        {
            OptionCaption = ' ,Province 1, Province 2, Bagmati Province, Gandaki Province, Province 5, Karnali Province, Sudur Pachim Province ';
            OptionMembers = " ","Province 1"," Province 2"," Bagmati Province"," Gandaki Province"," Province 5"," Karnali Province"," Sudur Pachim Province";
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Document No."(Key)".


        //Unsupported feature: Deletion (KeyCollection) on ""External Document No."(Key)".


        //Unsupported feature: Property Deletion (MaintainSQLIndex) on ""Document Type,Customer No.,Posting Date,Currency Code"(Key)".


        //Unsupported feature: Property Deletion (MaintainSIFTIndex) on ""Document Type,Customer No.,Posting Date,Currency Code"(Key)".

        key(Key1; "Document No.", "Document Type", "Customer No.")
        {
        }
        key(Key2; "External Document No.", "Document Type", "Customer No.")
        {
        }
        key(Key3; "Customer No.", "Posting Date")
        {
            SumIndexFields = "Sales (LCY)", "Profit (LCY)", "Inv. Discount (LCY)";
        }
        key(Key4; "Document No.", "Posting Date")
        {
        }
        key(Key5; "Posting Date")
        {
        }
        key(Key6; "Document Type", "Document No.")
        {
        }
        key(Key7; "Document No.", "Posting Date", "Currency Code")
        {
        }
        key(Key8; "Document Date")
        {
        }
    }


    //Unsupported feature: Code Modification on "ShowDoc(PROCEDURE 7)".

    //procedure ShowDoc();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE "Document Type" OF
      "Document Type"::Invoice:
        BEGIN
    #4..12
      "Document Type"::"Credit Memo":
        BEGIN
          IF SalesCrMemoHdr.GET("Document No.") THEN BEGIN
            PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHdr);
            EXIT(TRUE);
          END;
          IF ServiceCrMemoHeader.GET("Document No.") THEN BEGIN
            PAGE.RUN(PAGE::"Posted Service Credit Memo",ServiceCrMemoHeader);
            EXIT(TRUE);
          END;
        END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..15
            PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHdr);
    #17..24
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 6)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Customer No." := GenJnlLine."Account No.";
    "Posting Date" := GenJnlLine."Posting Date";
    "Document Date" := GenJnlLine."Document Date";
    #4..35
    "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
    "Payment Method Code" := GenJnlLine."Payment Method Code";
    "Exported to Payment File" := GenJnlLine."Exported to Payment File";

    OnAfterCopyCustLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..38
    Narration := GenJnlLine.Narration; // Sipradi-YS 7.10.2012
    "Sales Invoice No." := GenJnlLine."Sales Invoice No."; // SIpradi-YS 8.21.2012
    "Invertor Serial No." := GenJnlLine."Invertor Serial No."; // Agile Chandra 01 Sep 2015
    "Created by" := GenJnlLine."Created by";
    "Financed By":=GenJnlLine."Financed By";
    "Re-Financed By":=GenJnlLine."Re-Financed By";
    "Financed Amount":=GenJnlLine."Financed Amount";
    "Sales Order No." := GenJnlLine."Sales Order No.";
    "Document Class" := GenJnlLine."Document Class";
    "Document Subclass" := GenJnlLine."Document Subclass";
    "Make Code" := GenJnlLine."Make Code"; // Sipradi-YS 7.24.2012
    "Model Code" := GenJnlLine."Model Code"; // Sipradi-YS 7.24.2012
    //SS1.00
    "Scheme Code" := GenJnlLine."Scheme Code";
    "Membership No." := GenJnlLine."Membership No.";
    //SS1.00
    //--dms fields
    "Vehicle Serial No." := GenJnlLine."Vehicle Serial No.";
    "Vehicle Accounting Cycle No." := GenJnlLine."Vehicle Accounting Cycle No.";
    VIN := VIN;
    //--VF fields;
    "VF Posting Type" := GenJnlLine."VF Posting Type";
    "Loan File No." := GenJnlLine."VF Loan File No.";
    //--
    "Bank LC No." := GenJnlLine."Bank LC No.";  //Sameer
    "Credit Type" := GenJnlLine."Credit Type"; //Sameer
    "Sys. LC No." := GenJnlLine."Sys. LC No."; //Sameer
    "Province No." := GenJnlLine."Province No."; //Min
    OnAfterCopyCustLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;
}

