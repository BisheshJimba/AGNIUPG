table 33019974 "QR Specification"
{

    fields
    {
        field(1; "Source Type"; Integer)
        {
            Editable = false;
        }
        field(2; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(3; "Source ID"; Code[20])
        {
            Editable = false;
        }
        field(4; "Source Ref No."; Integer)
        {
            Editable = false;
        }
        field(5; "Line No."; Integer)
        {
        }
        field(20; "Item No."; Code[20])
        {
            Editable = false;
            TableRelation = Item;
        }
        field(30; "Supplier Code"; Code[10])
        {
            Editable = false;
        }
        field(40; "Lot No."; Code[20])
        {
            Editable = false;
        }
        field(41; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(42; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(43; "Expected Receipt Date"; Date)
        {
        }
        field(44; "Qty. per Unit Of Measure"; Decimal)
        {
        }
        field(50; "No. of Stickers"; Integer)
        {
            MinValue = 0;

            trigger OnLookup()
            var
                QRMgt: Integer;
            begin
                //QRMgt.ShowAllListOfQR(Rec); to uncomment
            end;

            trigger OnValidate()
            begin
                GetTotalConsumed;
            end;
        }
        field(51; "Per Sticker Qty"; Decimal)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                GetTotalConsumed;
            end;
        }
        field(52; "Qty. Consumed"; Decimal)
        {
            Editable = false;
        }
        field(100; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(300; Supplier; Code[10])
        {
            Description = 'Filters';
            TableRelation = Table70000;
        }
        field(301; "Part No."; Code[20])
        {
            Description = 'Filters';
            TableRelation = Item WHERE(Supplier Code=FIELD(Supplier));
        }
        field(302;"Parent Lot No.";Code[100])
        {
            Description = 'Filters';
        }
        field(303;"Purchase Receipt No.";Code[20])
        {
            Description = 'Filters';
            TableRelation = "Purch. Rcpt. Line" WHERE (No.=FIELD(Part No.));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(304;"Remaining Stock Qty";Decimal)
        {
        }
        field(305;"No. of Sticker Required";Integer)
        {
        }
        field(306;"QR Text";Text[250])
        {
        }
        field(307;"No. Of Sticker Available";Integer)
        {
        }
        field(308;"Issue From Old Lot";Integer)
        {
        }
        field(400;"Qty. On Packet";Decimal)
        {
        }
        field(401;"Item Ledger Entry No.";Integer)
        {
        }
        field(402;"Per Sticker Qty for Old Lot";Decimal)
        {
        }
        field(403;"Package No.";Code[20])
        {
        }
        field(404;"Purchase Quantity";Decimal)
        {
        }
        field(405;"Item Name";Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE (No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(406;"Add Item";Boolean)
        {
        }
        field(407;"No. of Stickers Printed";Integer)
        {
            CalcFormula = Count("Item Ledger Entry" WHERE (Item No.=FIELD(Item No.),
                                                           Document No.=FIELD(Purchase Receipt No.),
                                                           Entry Type=CONST(Transfer),
                                                           Document Type=CONST(" "),
                                                           Location Code=FIELD(Location Code),
                                                           Open=CONST(Yes),
                                                           Remaining Quantity=FILTER(>0),
                                                           Package No.=FIELD(Package No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(500;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(501;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(502;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50000;"Code 1";Code[100])
        {
        }
        field(50001;"Available Qty";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Source Type","Source Subtype","Source ID","Source Ref No.","Item No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        QRMgt: Codeunit "50006";

    local procedure GetTotalConsumed()
    begin
        "Qty. Consumed" := "Per Sticker Qty" * "No. of Stickers";
    end;
}

