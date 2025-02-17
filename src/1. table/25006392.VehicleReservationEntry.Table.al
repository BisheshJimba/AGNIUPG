table 25006392 "Vehicle Reservation Entry"
{
    Caption = 'Vehicle Reservation Entry';
    DrillDownPageID = 25006503;
    LookupPageID = 25006503;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item;
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(10; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(11; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(12; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(13; "Source Batch Name"; Code[10])
        {
            Caption = 'Source Batch Name';
        }
        field(15; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(24; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = "Vehicle Serial No. Buffer";
        }
        field(25; "Created By"; Code[50])
        {
            Caption = 'Created By';

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
                LoginMgt.LookupUserID("Created By");
            end;
        }
        field(27; "Changed By"; Code[50])
        {
            Caption = 'Changed By';

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
                LoginMgt.LookupUserID("Changed By");
            end;
        }
        field(28; Positive; Boolean)
        {
            Caption = 'Positive';
            Editable = false;
        }
        field(30; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(41; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            Editable = false;
        }
        field(60; "Make Code"; Code[20])
        {
            CalcFormula = Lookup(Item."Make Code" WHERE(No.=FIELD(Model Version No.)));
                Caption = 'Make Code';
                Editable = false;
                FieldClass = FlowField;
        }
        field(70; "Model Code"; Code[20])
        {
            CalcFormula = Lookup(Item."Model Code" WHERE(No.=FIELD(Model Version No.)));
                Caption = 'Model Code';
                Editable = false;
                FieldClass = FlowField;
        }
        field(5817; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(50000; "Customer No."; Code[20])
        {
            CalcFormula = Lookup("Sales Header"."Sell-to Customer No." WHERE(No.=FIELD(Source ID)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001;"Customer Name";Text[50])
        {
            CalcFormula = Lookup("Sales Header"."Sell-to Customer Name" WHERE (No.=FIELD(Source ID)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002;"Booked Date";Date)
        {
            CalcFormula = Lookup("Sales Header"."Booked Date" WHERE (No.=FIELD(Source ID)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003;"Engine No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Engine No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.",Positive)
        {
            Clustered = true;
        }
        key(Key2;"Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name")
        {
        }
        key(Key3;"Model Version No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Line';

    [Scope('Internal')]
    procedure TextCaption(): Text[255]
    var
        ItemLedgEntry: Record "32";
        SalesLine: Record "37";
        ReqLine: Record "246";
        PurchLine: Record "39";
        ItemJnlLine: Record "83";
        ProdOrderLine: Record "5406";
        ProdOrderComp: Record "5407";
        TransLine: Record "5741";
        ServInvLine: Record "5902";
    begin
        CASE "Source Type" OF
          DATABASE::"Item Ledger Entry":
            EXIT(ItemLedgEntry.TABLECAPTION);
          DATABASE::"Sales Line":
            EXIT(SalesLine.TABLECAPTION);
          DATABASE::"Requisition Line":
            EXIT(ReqLine.TABLECAPTION);
          DATABASE::"Purchase Line":
            EXIT(PurchLine.TABLECAPTION);
          DATABASE::"Item Journal Line":
            EXIT(ItemJnlLine.TABLECAPTION);
          DATABASE::"Transfer Line":
            EXIT(TransLine.TABLECAPTION);
          ELSE
            EXIT(Text001);
        END;
    end;

    [Scope('Internal')]
    procedure Lock()
    var
        Rec2: Record "25006392";
    begin
        IF RECORDLEVELLOCKING THEN BEGIN
          Rec2.SETCURRENTKEY("Model Version No.");
          IF "Model Version No." <> '' THEN
            Rec2.SETRANGE("Model Version No.","Model Version No.");
          Rec2.LOCKTABLE;
          IF Rec2.FINDLAST THEN;
        END ELSE
          LOCKTABLE;
    end;
}

