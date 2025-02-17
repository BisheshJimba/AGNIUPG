table 25006056 "Segment SubLine"
{
    Caption = 'Segment SubLine';
    DrillDownPageID = 25006070;
    LookupPageID = 25006070;

    fields
    {
        field(1; "Segment No."; Code[20])
        {
            Caption = 'Segment No.';
            TableRelation = "Segment Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Contact No."; Code[20])
        {
            CalcFormula = Lookup("Segment Line"."Contact No." WHERE(Segment No.=FIELD(Segment No.),
                                                                     Line No.=FIELD(Line No.)));
            Caption = 'Contact No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Vehicle Contact"."Contact No.";

            trigger OnValidate()
            var
                SegInteractLanguage: Record "5104";
                Attachment: Record "5062";
                InteractTmpl: Record "5064";
            begin
            end;
        }
        field(4;"SubLine No.";Integer)
        {
        }
        field(10;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = "Vehicle Contact"."Vehicle Serial No." WHERE (Contact No.=FIELD(Contact No.));

            trigger OnLookup()
            var
                SegmentLine: Record "5077";
                VehicleContact: Record "25006013";
            begin
                IF SegmentLine.GET("Segment No.", "Line No.") THEN BEGIN
                  VehicleContact.RESET;
                  VehicleContact.SETRANGE("Contact No.", SegmentLine."Contact No.");
                  IF PAGE.RUNMODAL(0, VehicleContact) = ACTION::LookupOK THEN
                    VALIDATE("Vehicle Serial No.", VehicleContact."Vehicle Serial No.");
                END;
            end;
        }
        field(20;"Make Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Make Code" WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Make Code';
            FieldClass = FlowField;
            NotBlank = true;
            TableRelation = Make;
        }
        field(30;"Model Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Code" WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Model Code';
            FieldClass = FlowField;
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(40;"Model Version No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Version No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Model Version No.';
            FieldClass = FlowField;

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
            end;
        }
        field(50;"Model Commercial Name";Text[50])
        {
            CalcFormula = Lookup(Model."Commercial Name" WHERE (Make Code=FIELD(Make Code),
                                                                Code=FIELD(Model Code)));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Segment No.","Line No.","SubLine No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

