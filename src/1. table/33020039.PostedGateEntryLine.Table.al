table 33020039 "Posted Gate Entry Line"
{
    Caption = 'Posted Gate Entry Line';
    LookupPageID = 16480;

    fields
    {
        field(1; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Inward,Outward';
            OptionMembers = Inward,Outward;
        }
        field(2; "Gate Entry No."; Code[20])
        {
            Caption = 'Gate Entry No.';
            TableRelation = "Posted Gate Entry Header".No. WHERE(Entry Type=FIELD(Entry Type));
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(4;"Source Type";Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Sales Shipment,Sales Return Order,Purchase Order,Purchase Return Shipment,Transfer Receipt,Transfer Shipment,Service';
            OptionMembers = " ","Sales Shipment","Sales Return Order","Purchase Order","Purchase Return Shipment","Transfer Receipt","Transfer Shipment",Service;
        }
        field(5;"Source No.";Code[20])
        {
            Caption = 'Source No.';
        }
        field(6;"Source Name";Text[30])
        {
            Caption = 'Source Name';
            Editable = false;
        }
        field(7;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Close';
            OptionMembers = Open,Close;
        }
        field(8;Description;Text[80])
        {
            Caption = 'Description';
        }
        field(9;"Challan No.";Code[20])
        {
            Caption = 'Challan No.';
        }
        field(10;"Challan Date";Date)
        {
            Caption = 'Challan Date';
        }
    }

    keys
    {
        key(Key1;"Entry Type","Gate Entry No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Entry Type","Source Type","Source No.",Status)
        {
        }
    }

    fieldgroups
    {
    }
}

