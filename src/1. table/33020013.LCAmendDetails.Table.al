table 33020013 "LC Amend. Details"
{
    DrillDownPageID = 33020017;
    LookupPageID = 33020017;

    fields
    {
        field(1; "Version No."; Code[10])
        {
            Description = 'Automatic generated No.';
            Editable = false;

            trigger OnValidate()
            begin
                /*
                IF "Version No." <> xRec."Version No." THEN BEGIN
                  LCSetup.GET;
                  NoSeriesMngt.TestManual(LCSetup."LC Ammended Nos.");
                  "No. Series" := '';
                END;
                */

            end;
        }
        field(2; "No."; Code[20])
        {
            Description = 'LC Details No., for system tracking';
            Editable = false;
            TableRelation = "LC Details".No.;
        }
        field(3; "LC No."; Code[20])
        {
            Description = 'LC No. from LC Details';
            Editable = false;
        }
        field(4; Description; Text[50])
        {
            Editable = false;
        }
        field(5; "Transaction Type"; Option)
        {
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(6; "Issued To/Received From"; Code[20])
        {
            Description = 'Linked with Customer/Vendor with condition';
            TableRelation = IF (Transaction Type=CONST(Sale)) Customer.No. WHERE (Blocked=FILTER(<>All))
                            ELSE IF (Transaction Type=CONST(Purchase)) Vendor.No. WHERE (Blocked=FILTER(<>All));
        }
        field(7;"Issuing Bank";Code[20])
        {
            Description = 'Linked to bank, with condition';
            Editable = false;
            TableRelation = IF (Transaction Type=CONST(Sale)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Issued To/Received From))
                            ELSE IF (Transaction Type=CONST(Purchase)) "Bank Account".No.;
        }
        field(8;"Date of Issue";Date)
        {
            Editable = false;
        }
        field(9;"Receiving Bank";Code[20])
        {
            Caption = 'Negotiating Bank';
            Description = 'Linked to bank with condition,Customer or Vendor bank.';
            Editable = false;
            TableRelation = IF (Transaction Type=CONST(Purchase)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Issued To/Received From))
                            ELSE IF (Transaction Type=CONST(Sale)) "Bank Account".No. WHERE (Blocked=CONST(No));
        }
        field(10;"Starting Date";Date)
        {
        }
        field(11;"Type of LC";Option)
        {
            Editable = false;
            OptionCaption = 'Foreign,Inland';
            OptionMembers = Foreign,Inland;
        }
        field(12;"Type of Credit Limit";Option)
        {
            OptionCaption = 'Fixed,Revolving';
            OptionMembers = "Fixed",Revolving;
        }
        field(13;"Currency Code";Code[20])
        {
            Description = 'Linked to Currency.';
            Editable = false;
            TableRelation = IF (Type of LC=CONST(Foreign)) Currency;

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
        field(14;"Exchange Rate";Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                VALIDATE("LC Value");
            end;
        }
        field(15;"LC Value";Decimal)
        {

            trigger OnValidate()
            begin
                IF "Currency Code" <> '' THEN BEGIN
                  Currency.GET("Currency Code");
                  "LC Value (LCY)" := ROUND("LC Value" * "Exchange Rate",Currency."Amount Rounding Precision");
                END ELSE
                  "LC Value (LCY)" := "LC Value";

                "Amended Value" := "LC Value" - "Previous LC Value";

                //Sameer Feb 17
                LCDetails.RESET;
                LCDetails.SETRANGE("No.","No.");
                IF LCDetails.FINDFIRST THEN BEGIN
                  LCDetails.VALIDATE("LC\BG Value","LC Value");
                  LCDetails.MODIFY;
                END;
                //
            end;
        }
        field(16;"LC Value (LCY)";Decimal)
        {
            Editable = false;
        }
        field(17;"Utilized Value";Decimal)
        {
            Editable = false;
        }
        field(18;"Remaining Value";Decimal)
        {
            Editable = false;
        }
        field(19;"Amended Value";Decimal)
        {
            Editable = false;
        }
        field(20;Released;Boolean)
        {
            Editable = false;
        }
        field(21;Closed;Boolean)
        {
            Editable = false;
        }
        field(22;"Bank Amended No.";Code[20])
        {
        }
        field(23;"Revolving Cr. Limit Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,Automatic,Manual';
            OptionMembers = " ",Automatic,Manual;
        }
        field(24;"Previous LC Value";Decimal)
        {
            Editable = false;
        }
        field(25;"Expiry Date";Date)
        {
        }
        field(26;"No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(27;"Amended Date";Date)
        {
        }
        field(28;Remarks;Text[250])
        {
        }
        field(29;"Vehicle Category";Code[20])
        {
            Editable = false;
            TableRelation = "Vehicle Type".Code;
        }
        field(30;"Tolerance Percentage";Decimal)
        {
        }
        field(31;"Issued To/Received From Name";Text[50])
        {
        }
        field(32;"Issue Bank Name1";Text[50])
        {
        }
        field(33;"Receiving Bank Name";Text[50])
        {
        }
        field(34;"Vehicle Division";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(35;"Shipment Date";Date)
        {
        }
        field(36;"Issue Bank Name2";Text[50])
        {
            Description = '**SM 08/08/2013 to bring name2 of lc issuing bank';
        }
        field(37;"Bank Amended Refresh No.";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Version No.","No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Released THEN
          ERROR(Text33020016);
    end;

    trigger OnInsert()
    begin
        /*
        IF "Version No." = '' THEN BEGIN
          LCSetup.GET;
          LCSetup.TESTFIELD("LC Ammended Nos.");
          NoSeriesMngt.InitSeries(LCSetup."LC Ammended Nos.",xRec."No. Series",0D,"Version No.","No. Series");
        END;
        */
        
        
        //Setting Amend flag in LC Detail.
        LCDetails.RESET;
        LCDetails.SETRANGE("No.","No.");
        IF LCDetails.FIND('-') THEN BEGIN
          IF NOT LCDetails."Has Amendment" THEN BEGIN
            LCDetails."Has Amendment" := TRUE;
            LCDetails.MODIFY;
          END;
        END;

    end;

    trigger OnModify()
    begin
        IF Closed THEN
          ERROR(Text33020015);
    end;

    var
        LCSetup: Record "33020011";
        NoSeriesMngt: Codeunit "396";
        LCADetails: Record "33020013";
        Currency: Record "4";
        Text33020011: Label 'Issue Date cannot be after Expiry Date.';
        Text33020012: Label 'Expiry Date cannot be before Issue Date.';
        Text33020013: Label 'LC(s) value exceeds the credit limit available for this bank.';
        Text33020014: Label 'Bank''''s credit limit is zero.';
        Text33020015: Label 'You cannot modify closed LC.';
        Text33020016: Label 'You cannot delete released LC.';
        LCDetails: Record "33020012";
        CurrExchRate: Record "330";
        LCAmendDetail: Record "33020013";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        /*
        WITH LCADetails DO BEGIN
          LCADetails := Rec;
          LCSetup.GET;
          LCSetup.TESTFIELD(LCSetup."LC Ammended Nos.");
          IF NoSeriesMngt.SelectSeries(LCSetup."LC Ammended Nos.",xRec."No. Series","No. Series") THEN BEGIN
            LCSetup.GET;
            LCSetup.TESTFIELD("LC Ammended Nos.");
            NoSeriesMngt.SetSeries("Version No.");
            Rec := LCADetails;
            EXIT(TRUE);
          END;
        END;
        */

    end;
}

