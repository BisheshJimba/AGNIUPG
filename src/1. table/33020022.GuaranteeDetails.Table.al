table 33020022 "Guarantee Details"
{
    DrillDownPageID = 33020013;
    LookupPageID = 33020013;

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Automatic generated No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    VMSetup.GET;
                    NoSeriesMngt.TestManual(VMSetup."LC Details Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Guarantee No."; Code[20])
        {
            Description = 'LC No. from bank.';
        }
        field(3; Description; Text[50])
        {
        }
        field(4; "Transaction Type"; Option)
        {
            Description = 'LC purpose - sales LC or Purchase LC.';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;

            trigger OnValidate()
            begin
                /*
                IF Rec."Transaction Type" <> xRec."Transaction Type" THEN BEGIN
                  "Issued To/Received From" := '';
                  "Issuing Bank" := '';
                  "LC Value" := 0;
                END;
                */

            end;
        }
        field(5; "Issued To/Received From"; Code[20])
        {
            Description = 'Link to Customer/Vendor - if Sale then customer else vendor.';
            TableRelation = IF (Transaction Type=CONST(Sale)) Customer.No.
                            ELSE IF (Transaction Type=CONST(Purchase)) Vendor.No.;

            trigger OnValidate()
            begin
                IF ("Transaction Type" = "Transaction Type"::Purchase) THEN BEGIN
                    GblVendor.RESET;
                    GblVendor.SETRANGE("No.", "Issued To/Received From");
                    IF GblVendor.FIND('-') THEN BEGIN
                        "Issued To/Received From Name" := GblVendor.Name;
                        MODIFY;
                    END;
                END ELSE
                    IF ("Transaction Type" = "Transaction Type"::Sale) THEN BEGIN
                        GblCustomer.RESET;
                        GblCustomer.SETRANGE("No.", "Issued To/Received From");
                        IF GblCustomer.FIND('-') THEN BEGIN
                            "Issued To/Received From Name" := GblCustomer.Name;
                            MODIFY;
                        END;
                    END;

                /*
                IF Rec."Issued To/Received From" <> xRec."Issued To/Received From" THEN BEGIN
                  "Issuing Bank" := '';
                  "LC Value" := 0;
                END;
                */

            end;
        }
        field(6; "Issuing Bank"; Code[20])
        {
            Description = 'LC Issuing bank no., Linked to Customer/Vendor Bank account, condition applied, see table relation for details.';
            TableRelation = IF (Transaction Type=CONST(Sale)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Issued To/Received From))
                            ELSE IF (Transaction Type=CONST(Purchase)) "Bank Account".No.;

            trigger OnValidate()
            begin
                IF ("Transaction Type" = "Transaction Type"::Purchase) THEN BEGIN
                  GblBankAcc.RESET;
                  GblBankAcc.SETRANGE("No.","Issuing Bank");
                  IF GblBankAcc.FIND('-') THEN BEGIN
                    "Issue Bank Name" := GblBankAcc.Name;
                    MODIFY;
                  END;
                END ELSE IF ("Transaction Type" = "Transaction Type"::Sale) THEN BEGIN
                  GblCustBankAcc.RESET;
                  GblCustBankAcc.SETRANGE(Code,"Issuing Bank");
                  IF GblCustBankAcc.FIND('-') THEN BEGIN
                    "Issue Bank Name" := GblCustBankAcc.Name;
                    MODIFY;
                  END;
                END;
                
                /*
                IF Rec."Issuing Bank" <> xRec."Issuing Bank" THEN
                  "LC Value" := 0;
                */

            end;
        }
        field(7;"Date of Issue";Date)
        {
        }
        field(8;"Receiving Bank";Code[20])
        {
            Caption = 'Negotiating Bank';
            Description = 'link to Customer or Vendor bank.';
            TableRelation = IF (Transaction Type=CONST(Purchase)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Issued To/Received From))
                            ELSE IF (Transaction Type=CONST(Sale)) "Bank Account".No. WHERE (Blocked=CONST(No));

            trigger OnValidate()
            begin
                IF ("Transaction Type" = "Transaction Type"::Purchase) THEN BEGIN
                  GblVenBankAcc.RESET;
                  GblVenBankAcc.SETRANGE(Code,"Receiving Bank");
                  IF GblVenBankAcc.FIND('-') THEN BEGIN
                    "Receiving Bank Name" := GblVenBankAcc.Name;
                    MODIFY;
                  END;
                END ELSE IF ("Transaction Type" = "Transaction Type"::Sale) THEN BEGIN
                  GblBankAcc.RESET;
                  GblBankAcc.SETRANGE("No.","Receiving Bank");
                  IF GblBankAcc.FIND('-') THEN BEGIN
                    "Receiving Bank Name" := GblBankAcc.Name;
                    MODIFY;
                  END;
                END;
                
                /*
                IF "Date of Issue" <> 0D THEN
                  IF "Date of Issue" > "Expiry Date" THEN
                    ERROR(Text33020012);
                */

            end;
        }
        field(9;"Expiry Date";Date)
        {
            Description = 'LC expiry date';

            trigger OnValidate()
            begin
                /*
                IF "Expiry Date" <> 0D THEN
                  IF "Date of Issue" > "Expiry Date" THEN
                    ERROR(Text33020012);
                */

            end;
        }
        field(10;"Type of LC";Option)
        {
            OptionCaption = 'Foreign,Inland';
            OptionMembers = Foreign,Inland;

            trigger OnValidate()
            begin
                /*
                IF "Type of LC" = "Type of LC"::Foreign THEN BEGIN
                  "Currency Code" := '';
                  "Exchange Rate" := 0;
                END;
                */

            end;
        }
        field(11;"Type of Credit Limit";Option)
        {
            OptionCaption = 'Fixed,Revolving';
            OptionMembers = "Fixed",Revolving;
        }
        field(12;"Currency Code";Code[10])
        {
            Description = 'For multiple currency transaction. Link to currency table.';
            TableRelation = IF (Type of LC=CONST(Foreign)) Currency.Code;

            trigger OnValidate()
            begin
                IF "Currency Code" <> '' THEN BEGIN
                  CurrExchRate.SETRANGE("Currency Code","Currency Code");
                  CurrExchRate.SETRANGE("Starting Date",0D,"Date of Issue");
                  CurrExchRate.FIND('+');
                  "Exchange Rate" := CurrExchRate."Relational Exch. Rate Amount" / CurrExchRate."Exchange Rate Amount";
                END;
            end;
        }
        field(13;"Exchange Rate";Decimal)
        {
            DecimalPlaces = 0:4;

            trigger OnValidate()
            begin
                VALIDATE("LC Value");
            end;
        }
        field(14;"LC Value";Decimal)
        {

            trigger OnValidate()
            var
                TotalAmount: Decimal;
                Currency: Record "4";
            begin
                IF "Currency Code" <> '' THEN BEGIN
                  Currency.GET("Currency Code");
                  "LC Value (LCY)" := ROUND("LC Value" * "Exchange Rate",Currency."Amount Rounding Precision");
                END ELSE
                  "LC Value (LCY)" := "LC Value";
                
                /*
                CLEAR(TotalAmount);
                IF "Currency Code" <> '' THEN BEGIN
                  Currency.GET("Currency Code");
                  "LC Value (LCY)" := ROUND("LC Value" * "Exchange Rate",Currency."Amount Rounding Precision");
                END ELSE
                  "LC Value (LCY)" := "LC Value";
                IF "Transaction Type" = "Transaction Type"::Purchase THEN BEGIN
                  BankCrLimit.SETRANGE("Bank No.","Issuing Bank");
                  BankCrLimit.SETFILTER("From Date",'<= %1',"Date of Issue");
                  IF BankCrLimit.FIND('+') THEN BEGIN
                    VMDetails.RESET;
                    VMDetails.SETRANGE("Transaction Type","Transaction Type");
                    VMDetails.SETRANGE("Issuing Bank",BankCrLimit."Bank No.");
                    VMDetails.SETFILTER("Date of Issue",'%1..%2',BankCrLimit."From Date",BankCrLimit."To Date");
                    VMDetails.SETFILTER("No.",'<>%1',"No.");
                    IF VMDetails.FIND('-') THEN
                      REPEAT
                        IF VMDetails."Latest Amended Value" = 0 THEN
                          TotalAmount :=  TotalAmount + VMDetails."LC Value (LCY)"
                        ELSE
                          TotalAmount :=  TotalAmount + VMDetails."Latest Amended Value";
                      UNTIL VMDetails.NEXT = 0;
                    IF TotalAmount + "LC Value (LCY)" > BankCrLimit.Amount THEN
                      ERROR(Text002);
                  END ELSE
                    ERROR(Text003);
                END;
                CALCFIELDS("Utilized Value");
                "Remaining Value" := "LC Value (LCY)" - "Utilized Value";
                "Latest Amended Value" := "LC Value (LCY)";
                */

            end;
        }
        field(15;"LC Value (LCY)";Decimal)
        {
            Editable = false;
        }
        field(16;"Utilized Value";Decimal)
        {
            Editable = false;
        }
        field(17;"Remaining Value";Decimal)
        {
            Editable = false;
        }
        field(18;"Revolving Cr. Limit Type";Option)
        {
            OptionCaption = ' ,Automatic,Manual';
            OptionMembers = " ",Automatic,Manual;
        }
        field(19;"Latest Amended Value";Decimal)
        {
            Description = 'Link to Amendment details, link with Version No. and No.';
            Editable = false;
        }
        field(20;"Renewed Value";Decimal)
        {
            Editable = false;
        }
        field(21;Closed;Boolean)
        {
            Editable = false;
        }
        field(22;Released;Boolean)
        {
            Editable = true;
        }
        field(23;"No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(24;"Vehicle Category";Code[20])
        {
            Description = 'Link to Dimension';
            TableRelation = "Vehicle Type".Code;
        }
        field(25;Remarks;Text[250])
        {
        }
        field(26;"Has Amendment";Boolean)
        {
        }
        field(27;"Tolerance Percentage";Decimal)
        {
        }
        field(28;"Last Used Amendment No.";Code[20])
        {
        }
        field(29;"Issued To/Received From Name";Text[50])
        {
        }
        field(30;"Issue Bank Name";Text[50])
        {
        }
        field(31;"Receiving Bank Name";Text[50])
        {
        }
        field(32;"Vehicle Division";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(33;"Shipment Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Date of Issue","Issuing Bank","Transaction Type")
        {
            SumIndexFields = "LC Value","Latest Amended Value";
        }
        key(Key3;Description)
        {
        }
        key(Key4;"Guarantee No.")
        {
        }
        key(Key5;"Issued To/Received From")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.","Guarantee No.",Description,"Issuing Bank","Issued To/Received From","Date of Issue")
        {
        }
    }

    trigger OnDelete()
    begin
        IF Released THEN
          ERROR(Text33020015);
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          VMSetup.GET;
          VMSetup.TESTFIELD("Guarantee Nos.");
          NoSeriesMngt.InitSeries(VMSetup."LC Details Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        "Date of Issue" := WORKDATE;
    end;

    trigger OnModify()
    begin
        IF Closed THEN
          ERROR(Text33020015);
    end;

    var
        NoSeriesMngt: Codeunit "396";
        VMSetup: Record "33020011";
        VMDetails: Record "33020022";
        Text33020011: Label 'Issue Date cannot be after Expiry Date.';
        Text33020012: Label 'Expiry Date cannot be before Issue Date.';
        CurrExchRate: Record "330";
        Text33020013: Label 'LC(s) value exceeds the credit limit available for this bank.';
        Text33020014: Label 'Bank''''s credit limit is zero.';
        BankCrLimit: Record "33020019";
        Text33020015: Label 'You cannot modify closed LC.';
        Text33020016: Label 'You cannot delete released LC.';
        GblVendor: Record "23";
        GblCustomer: Record "18";
        GblBankAcc: Record "270";
        GblCustBankAcc: Record "287";
        GblVenBankAcc: Record "288";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WITH VMDetails DO BEGIN
          VMDetails := Rec;
          VMSetup.GET;
          VMSetup.TESTFIELD("LC Details Nos.");
          IF NoSeriesMngt.SelectSeries(VMSetup."LC Details Nos.",xRec."No. Series","No. Series") THEN BEGIN
            VMSetup.GET;
            VMSetup.TESTFIELD("LC Details Nos.");
            NoSeriesMngt.SetSeries("No.");
            Rec := VMDetails;
            EXIT(TRUE);
          END;
        END;
    end;
}

