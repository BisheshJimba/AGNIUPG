table 25000 "Temp G/L Entry"
{
    // 21.06.2007. EDMS P2
    //   * Added key G/L Account No.,Source Type,Source No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date

    Caption = 'G/L Entry';
    // DrillDownPageID = 20;
    // LookupPageID = 20;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';

            trigger OnLookup()
            var
                // IncomingDocument: Record "130";
                IncomingDocument: Record "Incoming Document";
            begin
                // IncomingDocument.HyperlinkToDocument("Document No.", "Posting Date"); //internal scope issue
            end;
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            // TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
            //                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
            //                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
            //                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
            //                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset"
            //                 ELSE IF (Bal. Account Type=CONST(IC Partner)) "IC Partner";
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account" else if ("Bal. Account Type" = const(Customer)) Customer else if ("Bal. Account Type" = const(Vendor)) Vendor else if ("Bal. Account Type" = const("Bank Account")) "Bank Account" else if ("Bal. Account Type" = const("Fixed Asset")) "Fixed Asset" else if ("Bal. Account Type" = const("IC Partner")) "IC Partner";
        }
        field(17; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.LookupUserID("User ID");
            end;
        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(29; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(30; "Prior-Year Entry"; Boolean)
        {
            Caption = 'Prior-Year Entry';
        }
        field(41; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(42; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(43; "VAT Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(45; "Business Unit Code"; Code[10])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit";
        }
        field(46; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(47; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(48; "Gen. Posting Type"; Option)
        {
            Caption = 'Gen. Posting Type';
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(49; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(50; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(51; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(52; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(53; "Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(54; "Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(55; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
        }
        field(56; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(57; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(58; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Customer)) Customer
            else if ("Source Type" = const(Vendor)) Vendor
            else if ("Source Type" = const("Bank Account")) "Bank Account"
            else if ("Source Type" = const("Fixed Asset")) "Fixed Asset";
        }
        field(59; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(60; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(61; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(62; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(63; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
        }
        field(64; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(65; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(68; "Additional-Currency Amount"; Decimal)
        {
            AccessByPermission = TableData 4 = R;
            AutoFormatType = 1;
            Caption = 'Additional-Currency Amount';
        }
        field(69; "Add.-Currency Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Currency Debit Amount';
        }
        field(70; "Add.-Currency Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Currency Credit Amount';
        }
        field(71; "Close Income Statement Dim. ID"; Integer)
        {
            Caption = 'Close Income Statement Dim. ID';
        }
        field(72; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(73; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(74; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "G/L Entry";
        }
        field(75; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "G/L Entry";
        }
        field(76; "G/L Account Name"; Text[100])
        {
            CalcFormula = lookup("G/L Account".Name where("No." = field("G/L Account No.")));
            Caption = 'G/L Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(5400; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
        }
        field(5600; "FA Entry Type"; Option)
        {
            AccessByPermission = TableData 5600 = R;
            Caption = 'FA Entry Type';
            OptionCaption = ' ,Fixed Asset,Maintenance';
            OptionMembers = " ","Fixed Asset",Maintenance;
        }
        field(5601; "FA Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'FA Entry No.';
            TableRelation = if ("FA Entry Type" = const("Fixed Asset")) "FA Ledger Entry"
            else if ("FA Entry Type" = const(Maintenance)) "Maintenance Ledger Entry";
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
            TableRelation = if ("Document Class" = const(Customer)) Customer
            else if ("Document Class" = const(Vendor)) Vendor
            else if ("Document Class" = const("Bank Account")) "Bank Account"
            else if ("Document Class" = const("Fixed Assets")) "Fixed Asset";
        }
        field(50003; "Employee Code"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Employee."No." where("No." = field("Employee Code"));
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = const('EMPLOYEE')));
        }
        field(50004; "Sales Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order)); //,"Document Profile"=const("Vehicles Trade")); //need to add document profile
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
            // CalcFormula = lookup(Employee."Full Name" where("No." = field("Employee Code"))); //no full name in employee
        }
        field(50055; "Invertor Serial No."; Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
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
            TableRelation = "Commercial Invoice Header"."No.";
        }
        field(59055; "Loan Posting Type"; Option)
        {
            OptionMembers = " ","Loan Invoice","Loan Payment","Loan Interest Charges";
        }
        field(25006001; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
            CalcFormula = Lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
        }
        field(25006050; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No';
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE("Serial No." = FIELD("Vehicle Serial No."))); //need to add registration no
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
            OptionCaption = ' ,Principal,Interest,Penalty,Service Charge,Insurance,Other Charges';
            OptionMembers = " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges";
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
            OptionCaption = ' ,BG,LC';
            OptionMembers = " ",BG,LC;
        }
        field(33020251; "VF Loan Clear Entry"; Boolean)
        {
        }
        field(33020252; "Value Entry No."; Integer)
        {
        }
        field(33020253; "G/L Entry No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "G/L Account No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key3; "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key4; "G/L Account No.", "Vehicle Serial No.", "Vehicle Accounting Cycle No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key5; "Document No.", "Posting Date")
        {
        }
        key(Key6; "Transaction No.")
        {
        }
        key(Key7; "IC Partner Code")
        {
        }
        key(Key8; "G/L Account No.", "Job No.", "Posting Date")
        {
            SumIndexFields = Amount;
        }
        key(Key9; "G/L Account No.", "Source Type", "Source Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
        }
        key(Key10; "G/L Account No.", "Source Type", "Source No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Source Code", Intransit)
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key11; "Document Class", "Global Dimension 2 Code", "G/L Account No.", "Posting Date")
        {
            SumIndexFields = Amount;
        }
        key(Key12; "Document No.", "Posting Date", Amount)
        {
        }
        key(Key13; "Document Class", "G/L Account No.", "Vehicle Serial No.")
        {
            SumIndexFields = Amount;
        }
        key(Key14; "Document No.", "Document Class", "Document Subclass", "Posting Date")
        {
        }
        key(Key15; "System LC No.", "G/L Account No.", "Source Type", "Source No.", Intransit)
        {
            SumIndexFields = Amount;
        }
        key(Key16; "Document No.")
        {
        }
        key(Key17; "Commercial Invoice No", "Loan Posting Type", "G/L Account No.")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, "G/L Account No.", "Posting Date", "Document Type", "Document No.")
        {
        }
    }

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;
}

