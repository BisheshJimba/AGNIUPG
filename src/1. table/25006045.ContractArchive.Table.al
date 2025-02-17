table 25006045 "Contract Archive"
{
    Caption = 'Contract Archive';
    DataCaptionFields = "Contract No.", Description;
    DrillDownPageID = 25006062;
    LookupPageID = 25006062;

    fields
    {
        field(5; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            Description = 'Not Supported. Reserved for future.';
            OptionCaption = 'Quote,Contract';
            OptionMembers = Quote,Contract;
        }
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(30; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(40; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Inactive,Active';
            OptionMembers = Inactive,Active;
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Service Comment Line EDMS" WHERE(Type = CONST(Contract),
                                                                   No.=FIELD(Contract No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(70;"Bill-to Name";Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75;"Bill-to Name 2";Text[50])
        {
            CalcFormula = Lookup(Customer."Name 2" WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80;"Bill-to Address";Text[30])
        {
            CalcFormula = Lookup(Customer.Address WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90;"Bill-to Address 2";Text[30])
        {
            CalcFormula = Lookup(Customer."Address 2" WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Address 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Bill-to Post Code";Code[20])
        {
            CalcFormula = Lookup(Customer."Post Code" WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Post Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110;"Bill-to City";Text[30])
        {
            CalcFormula = Lookup(Customer.City WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(115;"Bill-to County";Text[30])
        {
            CalcFormula = Lookup(Customer.County WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to County';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120;"Bill-to Country/Region";Code[10])
        {
            CalcFormula = Lookup(Customer."Country/Region Code" WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Country/Region';
            Editable = false;
            FieldClass = FlowField;
        }
        field(140;"Salesperson Code";Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = Salesperson/Purchaser;
        }
        field(310;"Starting Date";Date)
        {
            Caption = 'Starting Date';
        }
        field(320;"Expiration Date";Date)
        {
            Caption = 'Expiration Date';
        }
        field(340;"Max. Labor Unit Price";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Max. Labor Unit Price';
        }
        field(380;"Combine Invoices";Boolean)
        {
            Caption = 'Combine Invoices';
        }
        field(420;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(430;"Cancel Reason Code";Code[10])
        {
            Caption = 'Cancel Reason Code';
            TableRelation = "Reason Code";
        }
        field(510;"Service Period";DateFormula)
        {
            Caption = 'Service Period';
        }
        field(520;"Payment Terms Code";Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(580;"Accept Before";Date)
        {
            Caption = 'Accept Before';
        }
        field(600;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(610;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(900;"Contact No.";Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
        }
        field(2000;"Document Profille";Option)
        {
            Caption = 'Document Profille';
            OptionCaption = ' ,Spare Parts Trade,,Service';
            OptionMembers = " ","Spare Parts Trade",,Service;
        }
        field(5043;"Interaction Exist";Boolean)
        {
            Caption = 'Interaction Exist';
        }
        field(5044;"Time Archived";Time)
        {
            Caption = 'Time Archived';
        }
        field(5045;"Date Archived";Date)
        {
            Caption = 'Date Archived';
        }
        field(5046;"Archived By";Code[50])
        {
            Caption = 'Archived By';
        }
        field(5047;"Version No.";Integer)
        {
            Caption = 'Version No.';
        }
        field(5048;"Doc. No. Occurrence";Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
    }

    keys
    {
        key(Key1;"Contract Type","Contract No.","Doc. No. Occurrence","Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ContractSignerArch: Record "25006047";
        ContractSalesPriceArch: Record "25006048";
        ContractSalesLineDiscArch: Record "25006046";
        ServCommentLineArch: Record "25006171";
    begin
        ContractSignerArch.SETRANGE("Contract Type", "Contract Type");
        ContractSignerArch.SETRANGE("Contract No.", "Contract No.");
        ContractSignerArch.SETRANGE("Doc. No. Occurrence", "Doc. No. Occurrence");
        ContractSignerArch.SETRANGE("Version No.", "Version No.");
        ContractSignerArch.DELETEALL(TRUE);

        ContractSalesPriceArch.SETRANGE("Contract Type", "Contract Type");
        ContractSalesPriceArch.SETRANGE("Contract No.", "Contract No.");
        ContractSalesPriceArch.SETRANGE("Doc. No. Occurrence", "Doc. No. Occurrence");
        ContractSalesPriceArch.SETRANGE("Version No.", "Version No.");
        ContractSalesPriceArch.DELETEALL(TRUE);

        ContractSalesLineDiscArch.SETRANGE("Contract Type", "Contract Type");
        ContractSalesLineDiscArch.SETRANGE("Contract No.", "Contract No.");
        ContractSalesLineDiscArch.SETRANGE("Doc. No. Occurrence", "Doc. No. Occurrence");
        ContractSalesLineDiscArch.SETRANGE("Version No.", "Version No.");
        ContractSalesLineDiscArch.DELETEALL(TRUE);

        ServCommentLineArch.SETRANGE(Type, ServCommentLineArch.Type::Contract);
        ServCommentLineArch.SETRANGE("No.", "Contract No.");
        ServCommentLineArch.SETRANGE("Doc. No. Occurrence", "Doc. No. Occurrence");
        ServCommentLineArch.SETRANGE("Version No.", "Version No.");
        ServCommentLineArch.DELETEALL(TRUE);
    end;
}

