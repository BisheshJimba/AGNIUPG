table 33020199 "Deal Finalization"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
        }
        field(2; Date; Date)
        {
        }
        field(3; Make; Code[20])
        {
            TableRelation = Make;
        }
        field(4; "Model No."; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make));

            trigger OnValidate()
            begin
                CALCFIELDS("Model Name");
            end;
        }
        field(5;"Model Name";Text[50])
        {
            CalcFormula = Lookup(Model."Commercial Name" WHERE (Code=FIELD(Model No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Model Version No.";Code[20])
        {

            trigger OnLookup()
            begin
                //Lookup Model Version.
                GblItem.RESET;
                IF GblLookupMgt.LookUpModelVersion(GblItem,"Model Version No.",Make,"Model No.") THEN
                 VALIDATE("Model Version No.",GblItem."No.");
            end;

            trigger OnValidate()
            begin
                //Code to bring model version name.
                GblItem.RESET;
                GblItem.SETRANGE("No.","Model Version No.");
                IF GblItem.FIND('-') THEN
                  "Model Version Name" := GblItem.Description;
            end;
        }
        field(7;"Model Version Name";Text[50])
        {
        }
        field(8;"Price (LCY)";Decimal)
        {

            trigger OnValidate()
            begin
                //Calculating Additional currency amount.
                gblGLSetup.GET;

                gblCurrExchRate.RESET;
                gblCurrExchRate.SETRANGE("Currency Code",gblGLSetup."Additional Reporting Currency");
                gblCurrExchRate.SETFILTER("Starting Date",'%1..%2',0D,Date);
                IF gblCurrExchRate.FIND('-') THEN BEGIN
                  IF (gblCurrExchRate."Relational Exch. Rate Amount" <> 0) THEN BEGIN
                    "Price Add. Currency" := "Price (LCY)"/gblCurrExchRate."Relational Exch. Rate Amount";
                    MODIFY;
                  END;
                END;
            end;
        }
        field(9;"Price Add. Currency";Decimal)
        {
            Editable = false;
        }
        field(10;Color;Code[20])
        {
        }
        field(11;"Deal Type";Option)
        {
            OptionCaption = ' ,Retail,Exchange,Bulk';
            OptionMembers = " ",Retail,Exchange,Bulk;
        }
        field(12;"Vehicle Details";Text[150])
        {
        }
        field(13;"Year of Make";Code[10])
        {
        }
        field(14;"Chasis No.";Code[30])
        {
        }
        field(15;"Value of Exchange (LCY)";Decimal)
        {

            trigger OnValidate()
            begin
                //Calculating Additional currency amount.
                gblGLSetup.GET;

                gblCurrExchRate.RESET;
                gblCurrExchRate.SETRANGE("Currency Code",gblGLSetup."Additional Reporting Currency");
                gblCurrExchRate.SETFILTER("Starting Date",'%1..%2',0D,Date);
                IF gblCurrExchRate.FIND('-') THEN BEGIN
                  IF (gblCurrExchRate."Relational Exch. Rate Amount" <> 0) THEN BEGIN
                    "VE Add. Currency" := "Value of Exchange (LCY)"/gblCurrExchRate."Relational Exch. Rate Amount";
                    MODIFY;
                  END;
                END;
            end;
        }
        field(16;"VE Add. Currency";Decimal)
        {
            Description = 'Value of Exchange additional currency';
            Editable = false;
        }
        field(17;"Discount Offered";Decimal)
        {
        }
        field(18;"Signing Amount Provided (LCY)";Decimal)
        {

            trigger OnValidate()
            begin
                //Calculating Additional currency amount.
                gblGLSetup.GET;

                gblCurrExchRate.RESET;
                gblCurrExchRate.SETRANGE("Currency Code",gblGLSetup."Additional Reporting Currency");
                gblCurrExchRate.SETFILTER("Starting Date",'%1..%2',0D,Date);
                IF gblCurrExchRate.FIND('-') THEN BEGIN
                  IF (gblCurrExchRate."Relational Exch. Rate Amount" <> 0) THEN BEGIN
                    "SAP Add. Currency" := "Signing Amount Provided (LCY)"/gblCurrExchRate."Relational Exch. Rate Amount";
                    MODIFY;
                  END;
                END;
            end;
        }
        field(19;"SAP Add. Currency";Decimal)
        {
            Description = 'Signing Amount Provided additional currency';
            Editable = false;
        }
        field(20;"Promised Date of Delivery";Date)
        {
        }
        field(21;"Terms of Payment";Text[250])
        {
        }
        field(22;"Facilities Provided";Text[250])
        {
        }
        field(23;"Sales Progress Code";Code[10])
        {
        }
        field(24;"Quotation No.";Code[20])
        {
        }
        field(25;"Quotation Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Prospect No.","Sales Progress Code",Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GblLookupMgt: Codeunit "25006003";
        GblItem: Record "27";
        gblGLSetup: Record "98";
        gblCurrExchRate: Record "330";
}

