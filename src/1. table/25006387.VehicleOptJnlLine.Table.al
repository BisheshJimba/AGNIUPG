table 25006387 "Vehicle Opt. Jnl. Line"
{
    // 11.04.2013 EDMS P8
    //   * Renamed field 'Manuf. Option Type' to 'Option Subtype'
    // 
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Jnl. Line';
    DrillDownPageID = 25006524;
    LookupPageID = 25006524;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Vehicle Opt. Jnl. Template";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "99000815";
            begin
                VALIDATE("Document Date", "Posting Date");
            end;
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Assemble,Disassemble';
            OptionMembers = Assemble,Disassemble;
        }
        field(10; Correction; Boolean)
        {
            Caption = 'Correction';

            trigger OnValidate()
            begin
                VALIDATE("Applies-to Entry", 0);
            end;
        }
        field(41; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Vehicle Opt. Jnl. Batch".Name WHERE(Journal Template Name=FIELD(Journal Template Name));
        }
        field(42; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(43; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
        }
        field(50; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(140; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(145; VIN; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'VIN';
                Editable = false;
                FieldClass = FlowField;
                TableRelation = Vehicle;
        }
        field(150; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Serial No." = '' THEN BEGIN
                    VALIDATE("Make Code", '');
                    VALIDATE("Model Code", '');
                    VALIDATE("Model Version No.", '');
                END
                ELSE BEGIN
                    Vehicle.GET("Vehicle Serial No.");
                    VALIDATE("Make Code", Vehicle."Make Code");
                    VALIDATE("Model Code", Vehicle."Model Code");
                    VALIDATE("Model Version No.", Vehicle."Model Version No.");
                END;
            end;
        }
        field(160; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option,Vehicle Base';
            OptionMembers = "Manufacturer Option","Own Option","Vehicle Base";
        }
        field(170; "Option Code"; Code[50])
        {
            Caption = 'Option Code';

            trigger OnLookup()
            var
                recManOption: Record "25006370";
                recItem: Record "27";
                recOwnOption: Record "25006372";
            begin
                CASE "Option Type" OF
                    "Option Type"::"Vehicle Base":
                        ;
                    "Option Type"::"Manufacturer Option":
                        BEGIN
                            recManOption.RESET;
                            recManOption.SETRANGE("Make Code", "Make Code");
                            recManOption.SETRANGE("Model Code", "Model Code");
                            recManOption.SETRANGE("Model Version No.", "Model Version No.");
                            recManOption.SETRANGE(Type, "Option Subtype");
                            IF PAGE.RUNMODAL(PAGE::"Manufacturer Options", recManOption) = ACTION::LookupOK THEN BEGIN
                                VALIDATE("Option Code", recManOption."Option Code");
                            END;
                        END;
                    "Option Type"::"Own Option":
                        BEGIN
                            recOwnOption.RESET;
                            recOwnOption.SETRANGE("Make Code", "Make Code");
                            recOwnOption.SETRANGE("Model Code", "Model Code");

                            IF PAGE.RUNMODAL(PAGE::"Own Options", recOwnOption) = ACTION::LookupOK THEN BEGIN
                                VALIDATE("Option Code", recOwnOption."Option Code");
                            END;
                        END;
                END;
            end;

            trigger OnValidate()
            var
                recManOption: Record "25006370";
                recItem: Record "27";
                recOwnOption: Record "25006372";
            begin
                IF "Option Code" = '' THEN
                    EXIT;

                CASE "Option Type" OF
                    "Option Type"::"Manufacturer Option":
                        BEGIN
                            recManOption.RESET;
                            recManOption.GET("Make Code", "Model Code", "Model Version No.", "Option Subtype", "Option Code");
                            VALIDATE(Description, recManOption.Description);
                            VALIDATE("Description 2", recManOption."Description 2");
                            VALIDATE("Option Subtype", recManOption.Type);
                            VALIDATE(Standard, recManOption.Standard);
                            VALIDATE("External Code", recManOption."External Code");
                        END;
                    "Option Type"::"Own Option":
                        BEGIN
                            recOwnOption.RESET;
                            recOwnOption.GET("Make Code", "Model Code", "Option Code");
                            VALIDATE(Description, recOwnOption.Description);
                            VALIDATE("Description 2", recOwnOption."Description 2");
                        END;
                END;
            end;
        }
        field(180; "External Code"; Code[50])
        {
            Caption = 'External Code';
        }
        field(190; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(200; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(210;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
                recItem.SETCURRENTKEY("Item Type","Make Code","Model Code");
                recItem.SETRANGE("Item Type",recItem."Item Type"::"Model Version");
                recItem.SETRANGE("Make Code","Make Code");
                recItem.SETRANGE("Model Code","Model Code");
                IF PAGE.RUNMODAL(PAGE::"Item List",recItem) = ACTION::LookupOK THEN //30.10.2012 EDMS
                 BEGIN
                  "Model Version No." := recItem."No.";
                 END;
            end;
        }
        field(230;Standard;Boolean)
        {
            Caption = 'Standard';
            Editable = false;
        }
        field(240;"Option Subtype";Option)
        {
            Caption = 'Option Subtype';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(250;Description;Text[250])
        {
            Caption = 'Description';
        }
        field(260;"Description 2";Text[250])
        {
            Caption = 'Description 2';
        }
        field(270;"Applies-to Entry";Integer)
        {
            Caption = 'Applies-to Entry';
            TableRelation = "Vehicle Opt. Ledger Entry"."Entry No." WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));

            trigger OnValidate()
            var
                recVehOptLedgEntry: Record "25006388";
            begin
                IF "Applies-to Entry" <> 0 THEN
                 BEGIN
                  recVehOptLedgEntry.GET("Applies-to Entry");
                  recVehOptLedgEntry.TESTFIELD(Open,TRUE);
                 END
            end;
        }
        field(280;"Assembly ID";Code[20])
        {
            Caption = 'Assembly ID';
        }
        field(290;"Cost Amount (LCY)";Decimal)
        {
            Caption = 'Cost Amount (LCY)';
        }
        field(300;"Update Sales Amounts";Boolean)
        {
            Caption = 'Update Sales Amounts';
        }
        field(310;"Sales Price (LCY)";Decimal)
        {
            Caption = 'Sales Price (LCY)';
            Editable = false;
        }
        field(320;"Sales Discount %";Decimal)
        {
            Caption = 'Sales Discount %';
            Editable = false;
        }
        field(330;"Sales Discount Amount (LCY)";Decimal)
        {
            Caption = 'Sales Discount Amount (LCY)';
            Editable = false;
        }
        field(340;"Sales Amount (LCY)";Decimal)
        {
            Caption = 'Sales Amount (LCY)';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //JnlLineDim.LOCKTABLE; //26.10.2012 EDMS
        LOCKTABLE;
        recVehOptJnlTemplate.GET("Journal Template Name");
        recVehOptJnlBatch.GET("Journal Template Name","Journal Batch Name");
    end;

    var
        recVehOptJnlTemplate: Record "25006385";
        recVehOptJnlBatch: Record "25006386";
        recVehOptJnlLine: Record "25006387";
        recItem: Record "27";
        cuNoSeriesMgt: Codeunit "396";
        recNonstockItem: Record "5718";

    [Scope('Internal')]
    procedure fSetUpNewLine(recLastVehOptJnlLine: Record "25006387")
    begin

        recVehOptJnlTemplate.GET("Journal Template Name");
        recVehOptJnlBatch.GET("Journal Template Name","Journal Batch Name");
        recVehOptJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        recVehOptJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        IF recVehOptJnlLine.FINDFIRST THEN BEGIN
          "Posting Date" := recLastVehOptJnlLine."Posting Date";
          "Document Date" := recLastVehOptJnlLine."Posting Date";
          "Document No." := recLastVehOptJnlLine."Document No.";
        END ELSE BEGIN
          "Posting Date" := WORKDATE;
          "Document Date" := WORKDATE;
          IF recVehOptJnlBatch."No. Series" <> '' THEN BEGIN
            CLEAR(cuNoSeriesMgt);
            "Document No." := cuNoSeriesMgt.TryGetNextNo(recVehOptJnlBatch."No. Series","Posting Date");
          END;
        END;
        "Source Code" := recVehOptJnlTemplate."Source Code";
    end;
}

