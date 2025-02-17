table 25006372 "Own Option"
{
    Caption = 'Own Option';
    LookupPageID = 25006499;

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(40;"Option Code";Code[50])
        {
            Caption = 'Option Code';
            NotBlank = true;
        }
        field(50;Description;Text[250])
        {
            Caption = 'Description';
        }
        field(60;"Description 2";Text[250])
        {
            Caption = 'Description 2';
        }
        field(70;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            TableRelation = "Service Package";
        }
        field(50000;"Unit Cost";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Make Code","Model Code","Option Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure GetCurrentPrice() CurrPrice: Decimal
    var
        OptionSalesPrice: Record "25006382";
    begin
        OptionSalesPrice.RESET;
        OptionSalesPrice.SETRANGE("Option Code","Option Code");
        OptionSalesPrice.SETRANGE("Sales Type",OptionSalesPrice."Sales Type"::"All Customers");
        OptionSalesPrice.SETFILTER("Starting Date", '<=%1', WORKDATE);
        OptionSalesPrice.SETFILTER("Ending Date", '''''|>=%1', WORKDATE);
        IF OptionSalesPrice.FINDLAST THEN
          CurrPrice := OptionSalesPrice."Unit Price";
    end;
}

