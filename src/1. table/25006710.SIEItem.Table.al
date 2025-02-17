table 25006710 "SIE Item"
{
    DrillDownPageID = 25006761;
    LookupPageID = 25006761;

    fields
    {
        field(10; "SIE No."; Code[10])
        {
            Caption = 'SIE No.';
            NotBlank = true;
            TableRelation = "Special Inventory Equipment".No.;
        }
        field(20; "Object No."; Code[20])
        {
            Caption = 'Object No.';
            TableRelation = "SIE Object".No. WHERE(SIE No.=FIELD(SIE No.),
                                                    Category=FIELD(Category));
        }
        field(30;Category;Code[10])
        {
            Caption = 'Category';
            TableRelation = "SIE Object Category".No. WHERE (SIE No.=FIELD(SIE No.));
        }
        field(40;"Code20 1";Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 1"));
            Description = 'REELNO comes from "SIE Journal Line"."Code10 1"';
            NotBlank = true;
        }
        field(100;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
    }

    keys
    {
        key(Key1;"SIE No.",Category,"Object No.","Code20 1")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        VFMgt: Codeunit "25006004";

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.GetVFCaptionEx(DATABASE::"SIE Item",FieldNumber,"SIE No."));
    end;

    [Scope('Internal')]
    procedure IsVFActive(FieldNumber: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActiveEx(DATABASE::"SIE Item",FieldNumber,"SIE No."));
    end;

    [Scope('Internal')]
    procedure GetCaption(FldNum: Integer): Text[80]
    begin
        EXIT(GetCaptionClass(FldNum))
    end;
}

