table 25006754 "Item Price Group"
{
    Caption = 'Item Price Group';
    LookupPageID = 25006824;

    fields
    {
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF (Sales Type=CONST(Customer Price Group)) "Customer Price Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign
                            ELSE IF (Sales Type=CONST(Location)) Location;
        }
        field(10;"Code";Code[10])
        {
            Caption = 'Code';
        }
        field(13;"Sales Type";Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,Location,Markup,Assembly,Contract,Serv. Pack,Labor Price Group';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign,Location,Markup,Assembly,Contract,SPackage,"Labor Price Group";

            trigger OnValidate()
            begin
                IF "Sales Type" <> xRec."Sales Type" THEN
                  VALIDATE("Sales Code",'');
            end;
        }
        field(20;"Sales Price Factor";Decimal)
        {
            Caption = 'Sales Price Factor';
            DecimalPlaces = 2:5;
        }
        field(30;"Purchase Discount Percent";Decimal)
        {
            Caption = 'Purchase Discount Percent';
        }
    }

    keys
    {
        key(Key1;"Code","Sales Type","Sales Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

