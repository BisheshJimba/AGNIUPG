table 25006016 Contract
{
    // 03.07.2015 EB.P30
    //   Specified Table DrillDownPageID
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added TableRelation to field:
    //     "Fin. Charge Terms Code"
    //   Modified trigger:
    //     OnModify()
    // 
    // 19.03.2014 Elva Baltic P8 #S0006 MMG7.00
    //   * Added fields:
    //     "Conclusion of Contract Date"
    //     "Contract Location"
    //     "Accepted Amount"
    //     "Fin. Charge Terms Code"

    Caption = 'Contract';
    DataCaptionFields = "Contract No.", Description;
    DrillDownPageID = "Contract List EDMS";
    LookupPageID = "Contract List EDMS";

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

            trigger OnValidate()
            begin
                IF "Contract No." <> xRec."Contract No." THEN BEGIN
                    ServMgtSetup.GET;
                    "No. Series" := '';
                END;
            end;
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
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("Service Comment Line EDMS" WHERE(Type = CONST(Contract),
                                                                   "No." = FIELD("Contract No.")));
        }
        field(60; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
                Cust.GET("Bill-to Customer No.");
                ServContractLine.SETRANGE("Contract No.", "Contract No.");
                IF ServContractLine.FIND('-') THEN
                    ERROR(text013, "Contract No.");
                IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
                    CALCFIELDS("Bill-to Name", "Bill-to Name 2", "Bill-to Address", "Bill-to Address 2", "Bill-to Post Code", "Bill-to City",
                    "Bill-to County", "Bill-to Country/Region");
            end;
        }
        field(70; "Bill-to Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE(No.=FIELD(Bill-to Customer No.)));
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
        field(80;"Bill-to Address";Text[50])
        {
            CalcFormula = Lookup(Customer.Address WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90;"Bill-to Address 2";Text[50])
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
        field(110;"Bill-to City";Text[50])
        {
            CalcFormula = Lookup(Customer.City WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(115;"Bill-to County";Text[50])
        {
            CalcFormula = Lookup(Customer.County WHERE (No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to County';
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

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF ("Bill-to Customer No." <> '') AND (Cont.GET("Contact No.")) THEN
                 Cont.SETRANGE("Company No.",Cont."Company No.")
                ELSE
                 IF "Bill-to Customer No." <> '' THEN
                  BEGIN
                   ContBusinessRelation.RESET;
                   ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                   ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                   ContBusinessRelation.SETRANGE("No.","Bill-to Customer No.");
                   IF ContBusinessRelation.FINDFIRST THEN
                    Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                  END
                 ELSE
                  Cont.SETFILTER("Company No.",'<>''''');

                IF "Contact No." <> '' THEN
                  IF Cont.GET("Contact No.") THEN ;

                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN
                 BEGIN
                  xRec := Rec;
                  VALIDATE("Contact No.",Cont."No.");
                 END;
            end;

            trigger OnValidate()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF ("Contact No." <> xRec."Contact No.") AND (xRec."Contact No." <> '') THEN
                 BEGIN
                  IF NOT CONFIRM(Text014,FALSE,FIELDCAPTION("Contact No.")) THEN
                   BEGIN
                    "Contact No." := xRec."Contact No.";
                    EXIT;
                   END;
                 END;

                IF ("Bill-to Customer No." <> '') AND ("Contact No." <> '') THEN
                 BEGIN
                  Cont.GET("Contact No.");
                  ContBusinessRelation.RESET;
                  ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                  ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                  ContBusinessRelation.SETRANGE("No.","Bill-to Customer No.");
                  IF ContBusinessRelation.FINDFIRST THEN
                   IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                    ERROR(Text045,Cont."No.",Cont.Name,"Bill-to Customer No.");
                 END;

                UpdateCust;
            end;
        }
        field(2000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,,Service';
            OptionMembers = " ","Spare Parts Trade",,Service;
        }
        field(5043;"No. of Archived Versions";Integer)
        {
            CalcFormula = Max("Contract Archive"."Version No." WHERE (Contract Type=FIELD(Contract Type),
                                                                      Contract No.=FIELD(Contract No.),
                                                                      Doc. No. Occurrence=FIELD(Doc. No. Occurrence)));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048;"Doc. No. Occurrence";Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(25006000;Suspended;Boolean)
        {
            Caption = 'Suspended';
        }
        field(25006010;"Conclusion of Contract Date";Date)
        {
            Caption = 'Conclusion of Contract Date';
        }
        field(25006020;"Contract Location";Text[30])
        {
            Caption = 'Contract Location';
        }
        field(25006030;"Accepted Amount";Decimal)
        {
            Caption = 'Accepted Amount';
        }
        field(25006040;"Fin. Charge Terms Code";Code[10])
        {
            Caption = 'Fin. Charge Terms Code';
            TableRelation = "Finance Charge Terms";
        }
    }

    keys
    {
        key(Key1;"Contract Type","Contract No.")
        {
            Clustered = true;
        }
        key(Key2;"Bill-to Customer No.")
        {
        }
        key(Key3;"Document Profile")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Status = Status::Active THEN
          ERROR(Text003,FORMAT(Status),TABLECAPTION);
        ServContractLine.RESET;
        ServContractLine.SETRANGE("Contract No.","Contract No.");
        ServContractLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        SalesSetup.GET;
        IF "Contract No." = '' THEN BEGIN
          SalesSetup.TESTFIELD("Contract Nos.");
          NoSeriesMgt.InitSeries(SalesSetup."Contract Nos.",xRec."No. Series",0D,
            "Contract No.","No. Series");
        END;
        "Starting Date" := WORKDATE;

        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::Contract,"Contract Type","Contract No.");
        VALIDATE("Contract Type", "Contract Type"::Contract);
    end;

    trigger OnModify()
    begin
        // TESTFIELD(Status, Status::Inactive);                                                 // 15.04.2014 Elva Baltic P21
    end;

    var
        text013: Label 'Can''t change customer No. %1, because there exist contract lines for this customer.';
        Text014: Label 'Do you want to change %1?';
        Text045: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text044: Label 'Contact %1 %2 is not related to customer %3.';
        SalesSetup: Record 311;
        SkipContact: Boolean;
        Text051: Label 'Contact %1 %2 is not related to a customer.';
        Cust: Record 18;
        DimMgt: Codeunit 408;
        ServOrderMgt: Codeunit 5900;
        ArchiveManagement: Codeunit 5063;
        ContactNo: Code[20];
        ServMgtSetup: Record 25006120;
        NoSeriesMgt: Codeunit 396;
        Text003: Label 'You cannot delete %1 %2.';
        ServContractLine: Record 25006017;

    [Scope('Internal')]
    procedure UpdateCust()
    var
        ContBusinessRelation: Record 5054;
        Cust: Record 18;
        Cont: Record 5050;
        CustTemplate: Record 5105;
        ContComp: Record 5050;
    begin

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
        ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
        IF ContBusinessRelation.FINDFIRST THEN BEGIN
          IF ("Bill-to Customer No." <> '') AND
             ("Bill-to Customer No." <> ContBusinessRelation."No.")
          THEN
            ERROR(Text044,Cont."No.",Cont.Name,"Bill-to Customer No.")
          ELSE IF "Bill-to Customer No." = '' THEN BEGIN
            SkipContact := TRUE;
            VALIDATE("Bill-to Customer No.",ContBusinessRelation."No.");
            SkipContact := FALSE;
          END;
        END ELSE
          ERROR(Text051,Cont."No.",Cont.Name);
    end;

    [Scope('Internal')]
    procedure UpdateCont(CustomerNo: Code[20])
    var
        ContBusRel: Record 5054;
        Cont: Record 5050;
        Cust: Record 18;
    begin
        IF Cust.GET(CustomerNo) THEN BEGIN
          CLEAR(ServOrderMgt);
          ContactNo := ServOrderMgt.FindContactInformation(Cust."No.");
          IF Cont.GET(ContactNo) THEN BEGIN
            "Contact No." := Cont."No.";
          END ELSE BEGIN
            IF Cust."Primary Contact No." <> '' THEN
              "Contact No." := Cust."Primary Contact No."
            ELSE BEGIN
              ContBusRel.RESET;
              ContBusRel.SETCURRENTKEY("Link to Table","No.");
              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
              ContBusRel.SETRANGE("No.","Bill-to Customer No.");
              IF ContBusRel.FINDFIRST THEN
                "Contact No." := ContBusRel."Contact No.";
            END;
          END;
        END;
    end;
}

