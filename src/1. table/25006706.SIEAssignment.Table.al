table 25006706 "SIE Assignment"
{
    Caption = 'SIE Assignment';
    DrillDownPageID = 25006758;
    LookupPageID = 25006758;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(25; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Main,Detail';
            OptionMembers = Main,Detail;
        }
        field(30; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                //SIEItem.SETCURRENTKEY("Item No.");
                //SIEItem.SETRANGE("Item No.",Rec."Item No.");
                //SIEItem.FINDFIRST
            end;
        }
        field(40; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(50; "Qty. to Assign"; Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Assign';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                SIELedgEntry: Record "25006703";
                PossToAss: Decimal;
            begin
                IF "Qty. to Assign" <> xRec."Qty. to Assign" THEN BEGIN
                    SIELedgEntry.GET("Entry No.");
                    SIELedgEntry.CALCFIELDS("Qty. to Assign", "Qty. Assigned");
                    PossToAss := SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned";

                    IF "Qty. to Assign" <= PossToAss THEN BEGIN
                        IF "Qty. to Assign" > PossToAss - (SIELedgEntry."Qty. to Assign" - xRec."Qty. to Assign") THEN
                            IF NOT CONFIRM(Text001, FALSE, FIELDCAPTION("Qty. to Assign"), FIELDCAPTION("Qty. Assigned")) THEN
                                ERROR(Text002)
                    END ELSE
                        ERROR(Text003, FIELDCAPTION("Qty. to Assign"))
                END
            end;
        }
        field(60; "Qty. Assigned Det."; Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. Assigned Det.';
            DecimalPlaces = 0 : 5;
            Editable = true;
        }
        field(65; "Qty. Assigned"; Decimal)
        {
            CalcFormula = Sum("SIE Assignment"."Qty. Assigned Det." WHERE(Type = CONST(Detail),
                                                                           Appl. To Entry=FIELD(Entry No.)));
            Caption = 'Qty. Assigned';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';

            trigger OnValidate()
            begin
                //VALIDATE("Amount to Assign");
            end;
        }
        field(80;"Amount to Assign";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount to Assign';
        }
        field(85;"Applies-to Type";Integer)
        {
            Caption = 'Applies-to Type';
        }
        field(90;"Applies-to Doc. Type";Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = 'Quote,Order,Invoice';
            OptionMembers = Quote,"Order",Invoice;
        }
        field(100;"Applies-to Doc. No.";Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            TableRelation = "Service Header EDMS".No. WHERE (Document Type=FIELD(Applies-to Doc. Type));
        }
        field(110;"Applies-to Doc. Line No.";Integer)
        {
            Caption = 'Applies-to Doc. Line No.';
            TableRelation = "Service Line EDMS"."Line No." WHERE (Document No.=FIELD(Applies-to Doc. No.),
                                                                  Document Type=FIELD(Applies-to Doc. Type));
        }
        field(120;"Applies-to Doc. Line Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Applies-to Doc. Line Amount';
        }
        field(130;Corrected;Boolean)
        {
            Caption = 'Corrected';
        }
        field(140;"Qty. to Transfer";Decimal)
        {
            Caption = 'Qty. to Transfer';
            Editable = false;
        }
        field(150;"Appl. To Entry";Integer)
        {
            Caption = 'Appl. To Entry';
        }
        field(160;"Appl. To Line No.";Integer)
        {
            Caption = 'Appl. To Line No.';
        }
        field(170;"Doc. Qty. Assigned";Decimal)
        {
            CalcFormula = Sum("SIE Assignment"."Qty. Assigned Det." WHERE (Type=CONST(Detail),
                                                                           Appl. To Entry=FIELD(Entry No.),
                                                                           Applies-to Doc. No.=FIELD(Applies-to Doc. No.),
                                                                           Applies-to Type=FIELD(Applies-to Type),
                                                                           Applies-to Doc. Type=FIELD(Applies-to Doc. Type)));
            Caption = 'Doc. Qty. Assigned';
            Editable = false;
            FieldClass = FlowField;
        }
        field(180;"Assignment Date";Date)
        {
            Caption = 'Assignment Date';
        }
        field(190;"Transaction Date";Date)
        {
            CalcFormula = Max("SIE Ledger Entry"."Date 1" WHERE (Entry No.=FIELD(Entry No.)));
            Caption = 'Transaction Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(200;"Transaction Time";Time)
        {
            CalcFormula = Max("SIE Ledger Entry"."Time 1" WHERE (Entry No.=FIELD(Entry No.)));
            Caption = 'Transaction Time';
            Editable = false;
            FieldClass = FlowField;
        }
        field(210;Resource;Text[50])
        {
            CalcFormula = Max("SIE Ledger Entry"."Text50 1" WHERE (Entry No.=FIELD(Entry No.)));
            Caption = 'Resource';
            Editable = false;
            FieldClass = FlowField;
        }
        field(220;Company;Integer)
        {
            CalcFormula = Max("SIE Ledger Entry"."Int 6" WHERE (Entry No.=FIELD(Entry No.)));
            Caption = 'Company';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Applies-to Type","Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.","Line No.",Type)
        {
            SumIndexFields = "Qty. to Assign","Qty. Assigned Det.","Amount to Assign";
        }
        key(Key3;"Applies-to Type","Applies-to Doc. Type","Applies-to Doc. No.","Line No.")
        {
        }
        key(Key4;"Appl. To Entry",Type)
        {
            SumIndexFields = "Qty. Assigned Det.";
        }
        key(Key5;"Applies-to Type","Applies-to Doc. Type","Applies-to Doc. No.","Appl. To Entry",Type)
        {
            SumIndexFields = "Qty. Assigned Det.";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CALCFIELDS("Qty. Assigned");
        TESTFIELD("Qty. Assigned",0);
    end;

    var
        Text002: Label 'Cancelled by user after warning';
        Text001: Label '%1 is larger than %2. It is possible another user wants to assign this transaction. Anyway to assign?';
        Text003: Label '%1 is bigger than assignable qty.';
}

