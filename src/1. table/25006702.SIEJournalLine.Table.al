table 25006702 "SIE Journal Line"
{
    // "Code10 1" supposed to be external system item id
    // "Code20 2" supposed to be NAV item id

    Caption = 'SIE Journal Line';

    fields
    {
        field(3; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Item Journal Template";
        }
        field(6; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Item Journal Batch".Name;
        }
        field(10; "Line No."; Integer)
        {
            AutoIncrement = false;
            Caption = 'Line No.';
            NotBlank = true;
        }
        field(20; "SIE No."; Code[10])
        {
            Caption = 'SIE No.';
            TableRelation = "Special Inventory Equipment";

            trigger OnValidate()
            begin
                IF "SIE No." = '' THEN BEGIN
                    CreateDim(DATABASE::"Special Inventory Equipment", "SIE No.");
                    EXIT;
                END;

                CreateDim(DATABASE::"Special Inventory Equipment", "SIE No.");
            end;
        }
        field(25; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(30; "Int 1"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 1"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Int 1"))
            end;
        }
        field(40; "Int 2"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 2"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Int 2"))
            end;
        }
        field(50; "Int 3"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 3"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Int 3"))
            end;
        }
        field(60; "Int 4"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 4"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Int 4"))
            end;
        }
        field(70; "Int 5"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 5"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Int 5"))
            end;
        }
        field(80; "Int 6"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 6"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Int 6"))
            end;
        }
        field(90; "Int 7"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 7"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Int 7"))
            end;
        }
        field(100; "Int 8"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 8"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Int 8"))
            end;
        }
        field(110; "Decimal 1"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 1"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Decimal 1"))
            end;
        }
        field(120; "Decimal 2"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 2"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Decimal 2"))
            end;
        }
        field(130; "Decimal 3"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 3"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Decimal 3"))
            end;
        }
        field(140; "Decimal 4"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 4"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Decimal 4"))
            end;
        }
        field(150; "Decimal 5"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 5"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Decimal 5"))
            end;
        }
        field(160; "Decimal 6"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 6"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Decimal 6"))
            end;
        }
        field(170; "Decimal 7"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 7"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Decimal 7"))
            end;
        }
        field(180; "Decimal 8"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 8"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Decimal 8"))
            end;
        }
        field(190; "Date 1"; Date)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Date 1"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Date 1"))
            end;
        }
        field(200; "Date 2"; Date)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Date 2"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Date 2"))
            end;
        }
        field(210; "Date 3"; Date)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Date 3"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Date 3"))
            end;
        }
        field(220; "Date 4"; Date)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Date 4"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Date 4"))
            end;
        }
        field(230; "Time 1"; Time)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Time 1"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Time 1"))
            end;
        }
        field(240; "Time 2"; Time)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Time 2"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Time 2"))
            end;
        }
        field(250; "Text50 1"; Text[50])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text50 1"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Text50 1"))
            end;
        }
        field(260; "Text50 2"; Text[50])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text50 2"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Text50 2"))
            end;
        }
        field(270; "Text100 1"; Text[100])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text100 1"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec, FIELDNO("Text100 1"))
            end;
        }
        field(280; "Code10 1"; Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code10 1"));
            TableRelation = "SIE Item"."Code20 1" WHERE(SIE No.=FIELD(SIE No.));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec,FIELDNO("Code10 1"))
            end;
        }
        field(290;"Code10 2";Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code10 2"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec,FIELDNO("Code10 2"))
            end;
        }
        field(300;"Code10 3";Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code10 3"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec,FIELDNO("Code10 3"))
            end;
        }
        field(310;"Code20 1";Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 1"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec,FIELDNO("Code20 1"))
            end;
        }
        field(320;"Code20 2";Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 2"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec,FIELDNO("Code20 2"))
            end;
        }
        field(330;"Code20 3";Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 3"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec,FIELDNO("Code20 3"))
            end;
        }
        field(340;"Text10 1";Text[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text10 1"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec,FIELDNO("Text10 1"))
            end;
        }
        field(350;"Text10 2";Text[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text10 2"));

            trigger OnValidate()
            begin
                SIEMgt.SIEValidateField(Rec,FIELDNO("Text10 2"))
            end;
        }
        field(360;Posted;Boolean)
        {
            Caption = 'Posted';
            FieldClass = Normal;
        }
        field(370;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(380;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(390;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(400;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(410;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(420;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(430;"Posting Date";Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                VALIDATE("Document Date","Posting Date");
            end;
        }
        field(440;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(450;"Recurring Method";Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(460;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(470;"To Validate Field";Integer)
        {
            Caption = 'To Validate Field';
        }
        field(480;"Not Passed Auto Check";Boolean)
        {
            Caption = 'Not Passed Auto Check';
        }
        field(481;"Dimension Set ID";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"SIE No.","Date 1","Time 1")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // 26.10.2012 EDMS >>
        /*
        DimMgt.UpdateJobTaskDim(
          DATABASE::"SIE Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0);
        */
        // 26.10.2012 EDMS <<

    end;

    trigger OnInsert()
    var
        SIEJnlTemplate: Record "82";
        SIEJnlBatch: Record "233";
    begin
        //JnlLineDim.LOCKTABLE;
        LOCKTABLE;
        
        IF SIEJnlTemplate.GET("Journal Template Name") THEN
          "Source Code" := SIEJnlTemplate."Source Code";
        IF SIEJnlBatch.GET("Journal Template Name","Journal Batch Name") THEN BEGIN
          "Reason Code" := SIEJnlBatch."Reason Code";
          IF "Location Code" = '' THEN
            "Location Code" := SIEJnlBatch."Location Code";
        END;
        
        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        
        // 26.10.2012 EDMS >>
        /*
        DimMgt.InsertJnlLineDim(
          DATABASE::"SIE Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */
        // 26.10.2012 EDMS <<

    end;

    var
        VFMgt: Codeunit "25006004";
        DimMgt: Codeunit "408";
        SIEMgt: Codeunit "25006700";
        SIEJnlLine: Record "25006702";

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.GetVFCaptionEx(DATABASE::"SIE Journal Line",FieldNumber,"SIE No."));
    end;

    [Scope('Internal')]
    procedure IsVFActive(FieldNumber: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActiveEx(DATABASE::"SIE Journal Line",FieldNumber,"SIE No."));
    end;

    [Scope('Internal')]
    procedure CreateDim(Type1: Integer;No1: Code[20])
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.GetDefaultDimID(
          TableID,No,"Source Code",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    end;

    [Scope('Internal')]
    procedure GetCaption(FldNum: Integer): Text[80]
    begin
        EXIT(GetCaptionClass(FldNum))
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
}

