tableextension 50070 tableextension50070 extends "G/L Entry"
{
    // 21.06.2007. EDMS P2
    //   * Added key G/L Account No.,Source Type,Source No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner";
        }
        modify("Source No.")
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        modify("FA Entry No.")
        {
            TableRelation = IF ("FA Entry Type" = CONST("Fixed Asset")) "FA Ledger Entry"
            ELSE IF ("FA Entry Type" = CONST(Maintenance)) "Maintenance Ledger Entry";
        }
        field(50000; "Cheque No."; Code[30])
        {
            Editable = false;
        }
        field(50001; "Document Class"; Option)
        {
            Caption = 'Document Class';
            Editable = false;
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets";
        }
        field(50002; "Document Subclass"; Code[20])
        {
            Caption = 'Document Subclass';
            Editable = false;
            TableRelation = IF ("Document Class" = CONST(Customer)) Customer
            ELSE IF ("Document Class" = CONST(Vendor)) Vendor
            ELSE IF ("Document Class" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Document Class" = CONST("Fixed Assets")) "Fixed Asset";
        }
        field(50003; "Employee Code"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Employee."No." WHERE("No." = FIELD("Employee Code"));
            CalcFormula = Lookup("Dimension Set Entry"."Dimension Value Code" WHERE("Dimension Set ID" = FIELD("Dimension Set ID"),
                                                                                     "Dimension Code" = CONST('EMPLOYEE')));
        }
        field(50004; "Sales Order No."; Code[20])
        {
            Editable = false;
            // TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order),
            //                                           "Document Profile" = CONST("Vehicles Trade"));//no document profile field
        }
        field(50005; "VIN - COGS"; Code[20])
        {
        }
        field(50006; "Created by"; Code[50])
        {
            Editable = false;
        }
        field(50007; "Employee Name"; Text[150])
        {
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee Code")));//no full name field
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
        field(50097; "COGS Type"; Option)
        {
            Description = 'Used for Alternative of way of Item Charge';
            OptionCaption = ' ,ACCESSORIES-CV,ACCESSORIES-PC,BANK CHARGE-CV,BANK CHARGE-PC,BATTERY-CV,BATTERY-PC,BODY BUILDING-CV,BODY BUILDING-PC,CHASSIS REGISTR-CV,CHASSIS REGISTR-PC,CLEARING & FORW-CV,CLEARING & FORW-PC,CUSTOM DUTY-CV,CUSTOM DUTY-PC,DENT / PENT-CV,DENT / PENT-PC,DRIVER-CV,DRIVER-PC,FOREIGN CHARGE-CV,FOREIGN CHARGE-PC,FUEL & OIL-CV,FUEL & OIL-PC,INSURANCE MANAG-CV,INSURANCE MANAG-PC,INSURANCE-CV,INSURANCE-PC,,L/C & BANK CHAR-CV,L/C & BANK CHAR-PC,LUBRICANTS-CV,LUBRICANTS-PC,NEW CHASSIS REP-CV,NEW CHASSIS REP-PC,PARKING CHARGE-CV,PARKING CHARGE-PC,PRAGYANPAN-CV,PRAGYANPAN-PC,SERVICE CHARGE-CV,SERVICE CHARGE-PC,SPARES-CV,SPARES-PC,TRANSPORTATION-CV,TRANSPORTATION-PC,VEHICLE LOGISTI-CV,VEHICLE LOGISTI-PC,VEHICLE TAX-CV,VEHICLE TAX-PC';
            OptionMembers = " ","ACCESSORIES-CV","ACCESSORIES-PC","BANK CHARGE-CV","BANK CHARGE-PC","BATTERY-CV","BATTERY-PC","BODY BUILDING-CV","BODY BUILDING-PC","CHASSIS REGISTR-CV","CHASSIS REGISTR-PC","CLEARING & FORW-CV","CLEARING & FORW-PC","CUSTOM DUTY-CV","CUSTOM DUTY-PC","DENT / PENT-CV","DENT / PENT-PC","DRIVER-CV","DRIVER-PC","FOREIGN CHARGE-CV","FOREIGN CHARGE-PC","FUEL & OIL-CV","FUEL & OIL-PC","INSURANCE MANAG-CV","INSURANCE MANAG-PC","INSURANCE-CV","INSURANCE-PC",,"L/C & BANK CHAR-CV","L/C & BANK CHAR-PC","LUBRICANTS-CV","LUBRICANTS-PC","NEW CHASSIS REP-CV","NEW CHASSIS REP-PC","PARKING CHARGE-CV","PARKING CHARGE-PC","PRAGYANPAN-CV","PRAGYANPAN-PC","SERVICE CHARGE-CV","SERVICE CHARGE-PC","SPARES-CV","SPARES-PC","TRANSPORTATION-CV","TRANSPORTATION-PC","VEHICLE LOGISTI-CV","VEHICLE LOGISTI-PC","VEHICLE TAX-CV","VEHICLE TAX-PC";
        }
        field(50099; "Sales Invoice No."; Code[20])
        {
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(50608; "Payroll Reversed"; Boolean)
        {
        }
        field(51020; Intransit; Boolean)
        {
        }
        field(59000; "TDS Group"; Code[20])
        {
            TableRelation = "TDS Posting Group";
        }
        field(59001; "TDS%"; Decimal)
        {
        }
        field(59002; "TDS Type"; Option)
        {
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(59003; "TDS Amount"; Decimal)
        {
        }
        field(59004; "TDS Base Amount"; Decimal)
        {
        }
        field(59050; "Commercial Invoice No"; Code[20])
        {
            Caption = 'Commercial Invoice No';
            TableRelation = "Commercial Invoice Header".No;
        }
        field(59055; "Loan Posting Type"; Option)
        {
            OptionMembers = " ","Loan Invoice","Loan Payment","Loan Interest Charges";
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
        field(25006001; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(25006050; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No';
        }
        field(25006170; "Vehicle Registration No."; Code[30])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE("Serial No." = FIELD("Vehicle Serial No.")));//need to solve table error
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(33020011; "System LC No."; Code[20])
        {
            Caption = 'LC No.';
            Editable = true;
            TableRelation = "LC Details"."No.";
        } 
        field(33020012; "Bank LC No."; Code[20])
        {
            Editable = false;
        }
        field(33020013; "LC Amend No."; Code[20])
        {
            Editable = false;
        }
        field(33020062; "VF Posting Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Principal,Interest,Penalty,Service Charge,Insurance,Other Charges,Prepayment,Insurance Interest,Interest on CAD';
            OptionMembers = " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges",Prepayment,"Insurance Interest","Interest on CAD";
        }
        field(33020063; "VF Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;
        }
        field(33020064; "Loan File No."; Code[20])
        {
            Editable = false;
            TableRelation = "Vehicle Finance Header"."Loan No.";
        }
        field(33020065; Narration; Text[250])
        {
            Editable = false;
        }
        field(33020066; "Pre Assigned No."; Code[20])
        {
        }
        field(33020240; "Exempt Purchase No."; Code[20])
        {
            TableRelation = "Exempt Purchase Nos.";
        }
        field(33020241; "Salary Error Line No."; Integer)
        {
        }
        field(33020242; "Scheme Code"; Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020243; "Membership No."; Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020244; "Import Invoice No."; Code[20])
        {
        }
        field(33020245; "Value Entry Doc 1"; Text[250])
        {
        }
        field(33020246; "Value Entry Doc 2"; Text[250])
        {
        }
        field(33020247; "Value Entry Doc 3"; Text[250])
        {
        }
        field(33020248; "Value Entry Doc 4"; Text[250])
        {
        }
        field(33020249; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(33020250; "Credit Type"; Option)
        {
            OptionCaption = ' ,BG,LC,Normal';
            OptionMembers = " ",BG,LC,Normal;
        }
        field(33020251; "VF Loan Clear Entry"; Boolean)
        {
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Posting Date,G/L Account No.,Dimension Set ID"(Key)".

        key(Key1; "G/L Account No.", "Vehicle Serial No.", "Vehicle Accounting Cycle No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key2; "G/L Account No.", "Source Type", "Source Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
        }
        key(Key3; "G/L Account No.", "Source Type", "Source No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Source Code", Intransit)
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key4; "Document Class", "Global Dimension 2 Code", "G/L Account No.", "Posting Date")
        {
            SumIndexFields = Amount;
        }
        key(Key5; "Document No.", "Posting Date", Amount)
        {
        }
        key(Key6; "Document Class", "G/L Account No.", "Vehicle Serial No.")
        {
            SumIndexFields = Amount;
        }
        key(Key7; "Document No.", "Document Class", "Document Subclass", "Posting Date")
        {
        }
        key(Key8; "System LC No.", "G/L Account No.", "Source Type", "Source No.", Intransit)
        {
            SumIndexFields = Amount;
        }
        key(Key9; "Document No.")
        {
        }
        key(Key10; "Commercial Invoice No", "Loan Posting Type", "G/L Account No.")
        {
            SumIndexFields = Amount;
        }
    }


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 4)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Posting Date" := GenJnlLine."Posting Date";
    "Document Date" := GenJnlLine."Document Date";
    "Document Type" := GenJnlLine."Document Type";
    #4..27
    "No. Series" := GenJnlLine."Posting No. Series";
    "IC Partner Code" := GenJnlLine."IC Partner Code";

    OnAfterCopyGLEntryFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..30

    Narration := GenJnlLine.Narration;
    "Sales Invoice No." := GenJnlLine."Sales Invoice No.";
    "COGS Type" := GenJnlLine."COGS Type";
    "Invertor Serial No." := GenJnlLine."Invertor Serial No."; //Agile Change 01 Sep 2015
    "Created by" := GenJnlLine."Created by";

    "Pre Assigned No." := GenJnlLine."Pre Assigned No."; //**SM 11-08-2013 to flow document no. before posting
    "Exempt Purchase No." := GenJnlLine."Exempt Purchase No.";
    "Import Invoice No." := GenJnlLine."Import Invoice No.";
    "Payroll Reversed" := GenJnlLine."Payroll Reversed";
    "Salary Error Line No." := GenJnlLine."Salary Error Line No.";
    //tds entry
    "Document Class" := GenJnlLine."Document Class";
    "Document Subclass" := GenJnlLine."Document Subclass";
    //tds entry

    //TDS2.00
    "TDS Group" := GenJnlLine."TDS Group";
    "TDS%" := GenJnlLine."TDS%";
    "TDS Type" := GenJnlLine."TDS Type";
    "TDS Amount" := GenJnlLine."TDS Amount";
    "TDS Base Amount" := GenJnlLine."TDS Base Amount";
    //TDS2.00

    //SS1.00
    "Scheme Code" := GenJnlLine."Scheme Code";
    "Membership No." := GenJnlLine."Membership No.";
    //SS1.00

    //----Purchase Order No.------
    "Sales Order No." := GenJnlLine."Sales Order No.";

    "Cost Type" := GenJnlLine."Cost Type";

    "Cheque No." := GenJnlLine."Cheque No."; //Added on 18 Jan 2012.
    //Agile CP 15 Feb 2017
    "Commercial Invoice No" := GenJnlLine."Commercial Invoice No";
    "Loan Posting Type" := GenJnlLine."Loan Posting Type";
    //Agile CP 15 Feb 2017

    //BG
    "Credit Type" := GenJnlLine."Credit Type";
    //
    VIN := GenJnlLine.VIN;
    OnAfterCopyGLEntryFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;

    procedure GetVINItemCharge(RecGLEntry: Record "17"): Code[20]
    var
        GLValueEntryRelation: Record "5823";
        ValueEntry: Record "5802";
        ILE: Record "32";
        PurchRcptLine: Record "121";
    begin
        //IF RecGLEntry."G/L Account No." IN ['110801','110802'] THEN BEGIN
        GLValueEntryRelation.RESET;
        GLValueEntryRelation.SETRANGE("G/L Entry No.", RecGLEntry."Entry No.");
        IF GLValueEntryRelation.FINDFIRST THEN BEGIN
            ValueEntry.RESET;
            ValueEntry.SETRANGE("Entry No.", GLValueEntryRelation."Value Entry No.");
            IF ValueEntry.FINDFIRST THEN BEGIN
                ILE.RESET;
                ILE.SETRANGE("Entry No.", ValueEntry."Item Ledger Entry No.");
                IF ILE.FINDFIRST THEN BEGIN
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Document No.", ILE."Document No.");
                    PurchRcptLine.SETRANGE("Line No.", ILE."Document Line No.");
                    IF PurchRcptLine.FINDFIRST THEN BEGIN
                        PurchRcptLine.CALCFIELDS(VIN);
                        EXIT(PurchRcptLine.VIN);
                    END;
                END;
            END;
        END;
        //END;
        EXIT('');
    end;
}

