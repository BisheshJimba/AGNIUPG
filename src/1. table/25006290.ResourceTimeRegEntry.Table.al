table 25006290 "Resource Time Reg. Entry"
{
    DrillDownPageID = 25006295;
    LookupPageID = 25006295;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Allocation Entry No."; Integer)
        {
            Caption = 'Allocation Entry No.';
            TableRelation = "Serv. Labor Allocation Entry";
        }
        field(30; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            NotBlank = true;
            TableRelation = Resource;

            trigger OnValidate()
            var
                Resource: Record "156";
            begin
            end;
        }
        field(40; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = Pending,"In Progress",Finished,"On Hold";
        }
        field(60; "Time Spent"; Decimal)
        {
            Caption = 'Time Spent';
        }
        field(70; Date; Date)
        {
            Caption = 'Date';

            trigger OnValidate()
            var
                ResourceTimeRegEntryPrev: Record "25006290";
                ActualWorkSpentTime: Decimal;
            begin
                ResourceTimeRegEntryPrev.RESET;
                ResourceTimeRegEntryPrev.SETRANGE("Allocation Entry No.", "Allocation Entry No.");
                ResourceTimeRegEntryPrev.SETRANGE("Entry Type", ResourceTimeRegEntryPrev."Entry Type"::"In Progress");
                ResourceTimeRegEntryPrev.SETFILTER("Entry No.", '<%1', Rec."Entry No.");
                ResourceTimeRegEntryPrev.SETRANGE(Canceled, FALSE);

                IF ResourceTimeRegEntryPrev.FINDLAST AND ("Entry Type" <> "Entry Type"::"In Progress") THEN BEGIN
                    ActualWorkSpentTime := CREATEDATETIME(Date, Time) - CREATEDATETIME(ResourceTimeRegEntryPrev.Date, ResourceTimeRegEntryPrev.Time);
                    ActualWorkSpentTime := ROUND(ActualWorkSpentTime / 3600000, 0.0001);
                END;

                "Time Spent" := ActualWorkSpentTime;
            end;
        }
        field(80; Time; Time)
        {
            Caption = 'Time';

            trigger OnValidate()
            var
                ResourceTimeRegEntryPrev: Record "25006290";
                ActualWorkSpentTime: Decimal;
            begin
                ResourceTimeRegEntryPrev.RESET;
                ResourceTimeRegEntryPrev.SETRANGE("Allocation Entry No.", "Allocation Entry No.");
                ResourceTimeRegEntryPrev.SETRANGE("Entry Type", ResourceTimeRegEntryPrev."Entry Type"::"In Progress");
                ResourceTimeRegEntryPrev.SETFILTER("Entry No.", '<%1', Rec."Entry No.");
                ResourceTimeRegEntryPrev.SETRANGE(Canceled, FALSE);

                IF ResourceTimeRegEntryPrev.FINDLAST AND ("Entry Type" <> "Entry Type"::"In Progress") THEN BEGIN
                    ActualWorkSpentTime := CREATEDATETIME(Date, Time) - CREATEDATETIME(ResourceTimeRegEntryPrev.Date, ResourceTimeRegEntryPrev.Time);
                    ActualWorkSpentTime := ROUND(ActualWorkSpentTime / 3600000, 0.0001);
                END;

                "Time Spent" := ActualWorkSpentTime;
            end;
        }
        field(100; Canceled; Boolean)
        {
            Caption = 'Canceled';
        }
        field(110; "Worktime Entry"; Boolean)
        {
            Caption = 'Worktime Entry';
        }
        field(120; "Resource Name"; Text[50])
        {
            CalcFormula = Lookup(Resource.Name WHERE(No.=FIELD(Resource No.)));
            Caption = 'Resource Name';
            FieldClass = FlowField;
        }
        field(130;"Start Entry Date";Date)
        {
            Caption = 'Start Entry Date';
        }
        field(140;Idle;Boolean)
        {
            Caption = 'Idle';
        }
        field(150;Travel;Boolean)
        {
            Caption = 'Travel';
        }
        field(160;"Source Type";Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Service Document,Standard Event';
            OptionMembers = ,"Service Document","Standard Event";
        }
        field(170;"Source Subtype";Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(180;"Source ID";Code[20])
        {
            Caption = 'Source ID';
            TableRelation = IF (Source Type=CONST(Service Document)) "Service Header EDMS".No. WHERE (Document Type=FIELD(Source Subtype))
                            ELSE IF (Source Type=CONST(Standard Event)) "Serv. Standard Event".Code;
            //This property is currently not supported
            //TestTableRelation = false;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        ServLaborAllocationEntry: Record "25006271";
    begin
        IF ServLaborAllocationEntry.GET("Allocation Entry No.") THEN BEGIN
          "Source Type" := ServLaborAllocationEntry."Source Type";
          "Source Subtype" := ServLaborAllocationEntry."Source Subtype";
          "Source ID" := ServLaborAllocationEntry."Source ID";
        END;
    end;
}

