table 33019890 "FA Transfer"
{

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "FA No."; Code[20])
        {

            trigger OnValidate()
            begin
                FixedAsset.GET("FA No.");
                FALocation := FixedAsset."FA Location Code";
                "From Location Code" := FALocation;
                "From Resposible Emp" := FixedAsset."Responsible Employee";
                "FA Description" := FixedAsset.Description;
                "FA Description2" := FixedAsset."Description 2";
                //Date := TODAY;
                Date := CURRENTDATETIME;
                //Bishesh Jimba 12/30/24
                "From Location" := FixedAsset."Location Code";
            end;
        }
        field(3; Date; DateTime)
        {
        }
        field(4; "From Location Code"; Code[10])
        {
            TableRelation = "FA Location".Code;
        }
        field(5; "To Location Code"; Code[10])
        {
            TableRelation = "FA Location";

            trigger OnValidate()
            begin
                /*
                FixedAsset.SETRANGE(FixedAsset."No.","FA No.");
                IF FixedAsset.FINDFIRST THEN BEGIN
                   FixedAsset."FA Location Code" := "From Location Code";
                   FixedAsset.MODIFY;
                END;
                */

            end;
        }
        field(6; Reason; Text[100])
        {
        }
        field(7; Remarks; Text[100])
        {
        }
        field(8; "From Resposible Emp"; Code[20])
        {
            TableRelation = Employee;
        }
        field(9; "To Resposible Emp"; Code[20])
        {
            TableRelation = Employee;
        }
        field(10; UserID; Code[50])
        {
        }
        field(11; "FA Description"; Text[100])
        {
        }
        field(12; "FA Description2"; Text[100])
        {
        }
        field(13; "From Branch Code"; Code[20])
        {
            CalcFormula = Lookup("Fixed Asset"."Global Dimension 1 Code" WHERE(No.=FIELD(FA No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"From Cost-Rev Code";Code[20])
        {
            CalcFormula = Lookup("Fixed Asset"."Global Dimension 2 Code" WHERE (No.=FIELD(FA No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15;"To Branch Code";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(50000;"From Location";Code[20])
        {
        }
        field(50001;"To Location";Code[20])
        {
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1;"No.","FA No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        FixedAsset: Record "5600";
        FALocation: Code[10];
}

