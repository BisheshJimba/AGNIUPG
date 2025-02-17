table 33019982 "QR Print Details"
{
    Caption = 'QR Print Details';

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Contact No."; Code[10])
        {
            TableRelation = Contact;
        }
        field(3; Category; Code[20])
        {
            TableRelation = Make.Code;
        }
        field(4; "Model Code"; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Category));
        }
        field(5;"Model Version No.";Code[20])
        {
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version));

            trigger OnLookup()
            begin
                recItem.RESET;
                IF DMSMgt.LookUpModelVersionWithFilter(recItem,"Model Version No.",Category,"Model Code") THEN
                 VALIDATE("Model Version No.",recItem."No.");
            end;
        }
        field(6;"Color Code";Code[10])
        {
            TableRelation = "Item Variant".Code WHERE (Item No.=FIELD(Model Version No.));
        }
        field(59001;"QR Code Text";Code[250])
        {
        }
        field(59002;"QR Code Blob";BLOB)
        {
            SubType = Bitmap;
        }
        field(59003;"QR Code Printed";Boolean)
        {
        }
        field(59004;"QR No. of Times Printed";Integer)
        {
        }
        field(59005;"QR Status";Option)
        {
            OptionCaption = ' ,Verified,Lost';
            OptionMembers = " ",Verified,Lost;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recItem: Record "27";
        DMSMgt: Codeunit "50014";
}

