table 25006143 "External Serv. Journal Line"
{
    Caption = 'External Serv. Journal Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Ext. Service Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "External Serv. Journal Batch".Name WHERE(Journal Template Name=FIELD(Journal Template Name));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Ext. Service No."; Code[20])
        {
            Caption = 'Ext. Service No.';
            TableRelation = "External Service";

            trigger OnValidate()
            begin
                IF "Ext. Service No." = '' THEN BEGIN
                    CreateDim(
                      DATABASE::"External Service", "Ext. Service No.");
                    EXIT;
                END;

                ExtService.GET("Ext. Service No.");
                ExtService.TESTFIELD(Blocked, FALSE);
                Description := ExtService.Description;

                CreateDim(
                  DATABASE::"External Service", "Ext. Service No.");
            end;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(9; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(11; "Ext. Service Tracking No."; Code[20])
        {
            Caption = 'Ext. Service Tracking No.';
            TableRelation = "External Serv. Tracking No."."External Serv. Tracking No." WHERE(External Service No.=FIELD(Ext. Service No.));
        }
        field(13;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(18;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code"); 26.10.2012 EDMS
            end;
        }
        field(19;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");  26.10.2012 EDMS
            end;
        }
        field(21;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(24;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(31;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
        }
        field(32;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(33;"Source Type";Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(34;"Source No.";Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source Type=CONST(Customer)) Customer.No.
                            ELSE IF (Source Type=CONST(Vendor)) Vendor.No.;
        }
        field(60;Amount;Decimal)
        {
            Caption = 'Amount';
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(33020235;"Service Order No.";Code[20])
        {
            TableRelation = "Service Header EDMS".No.;
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // 26.10.2012 EDMS >>
        /*
        DimMgt.DeleteJnlLineDim(
          DATABASE::"External Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0);
        */
        // 26.10.2012 EDMS <<

    end;

    trigger OnInsert()
    begin
        LOCKTABLE;
        ExtServiceJnlTemplate.GET("Journal Template Name");
        ExtServiceJnlBatch.GET("Journal Template Name","Journal Batch Name");
        
        
        // 26.10.2012 EDMS >>
        /*
        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        
        DimMgt.InsertJnlLineDim(
          DATABASE::"External Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */
        // 26.10.2012 EDMS <<

    end;

    var
        ExtServiceJnlTemplate: Record "25006142";
        ExtServiceJnlBatch: Record "25006144";
        ExtServiceJnlLine: Record "25006143";
        ExtService: Record "25006133";
        DimMgt: Codeunit "408";
        NoSeriesMgt: Codeunit "396";

    [Scope('Internal')]
    procedure EmptyLine(): Boolean
    begin
        EXIT(("Ext. Service No." = '') AND (Quantity = 0));
    end;

    [Scope('Internal')]
    procedure SetUpNewLine(LastExtServiceJnlLine: Record "25006143")
    begin
        ExtServiceJnlTemplate.GET("Journal Template Name");
        ExtServiceJnlBatch.GET("Journal Template Name","Journal Batch Name");
        ExtServiceJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        ExtServiceJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        IF ExtServiceJnlLine.FINDFIRST THEN BEGIN
          "Posting Date" := LastExtServiceJnlLine."Posting Date";
          "Document No." := LastExtServiceJnlLine."Document No.";
        END ELSE BEGIN
          "Posting Date" := WORKDATE;
          IF ExtServiceJnlBatch."No. Series" <> '' THEN BEGIN
            CLEAR(NoSeriesMgt);
            "Document No." := NoSeriesMgt.TryGetNextNo(ExtServiceJnlBatch."No. Series","Posting Date");
          END;
        END;
        "Source Code" := ExtServiceJnlTemplate."Source Code";
        "Reason Code" := ExtServiceJnlBatch."Reason Code";
        "Posting No. Series" := ExtServiceJnlBatch."Posting No. Series";
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
    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
}

