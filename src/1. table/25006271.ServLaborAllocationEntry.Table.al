table 25006271 "Serv. Labor Allocation Entry"
{
    // 14.03.2014 Elva Baltic P8 #S0003 MMG7.00
    //   * Fix: Details Entry No. should be copied into related allocations
    // 
    // 03.01.2008. EDMS P2
    //   * Added new field "Applies-to Entry No"

    Caption = 'Serv. Labor Allocation Entry';
    DrillDownPageID = 25006362;
    LookupPageID = 25006362;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Service Document,Standard Event';
            OptionMembers = ,"Service Document","Standard Event";
        }
        field(30; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(40; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
            TableRelation = IF (Source Type=CONST(Service Document)) "Service Header EDMS".No. WHERE (Document Type=FIELD(Source Subtype))
                            ELSE IF (Source Type=CONST(Standard Event)) "Serv. Standard Event".Code;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(70;"Start Date-Time";Decimal)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'Start Date-Time';
        }
        field(71;"End Date-Time";Decimal)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'End Date-Time';
        }
        field(100;"Quantity (Hours)";Decimal)
        {
            Caption = 'Quantity (Hours)';
            DecimalPlaces = 0:5;
        }
        field(110;"Resource No.";Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(140;"User ID";Code[50])
        {
            Caption = 'User ID';

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(150;"Applies-to Entry No.";Integer)
        {
            Caption = 'Applies-to Entry No.';

            trigger OnValidate()
            begin
                //14.03.2014 Elva Baltic P8 #S0003 MMG7.00 >>
                IF "Applies-to Entry No." <> xRec."Applies-to Entry No." THEN
                  IF LaborAllocEntry.GET("Applies-to Entry No.") THEN
                    VALIDATE("Detail Entry No.", LaborAllocEntry."Detail Entry No.");
                //14.03.2014 Elva Baltic P8 #S0003 MMG7.00 <<
            end;
        }
        field(160;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,In Progress,Finished,On Hold';
            OptionMembers = Pending,"In Progress",Finished,"On Hold";
        }
        field(170;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Serv. Break Reason";
        }
        field(180;"Planning Policy";Option)
        {
            Caption = 'Planning Policy';
            OptionCaption = 'Appointment,Queue';
            OptionMembers = Appointment,Queue;
        }
        field(210;"Parent Alloc. Entry No.";Integer)
        {
            Caption = 'Parent Alloc. Entry No.';
            Description = 'means is related to other entry';
            TableRelation = "Serv. Labor Allocation Entry";
        }
        field(220;"Parent Link Synchronize";Boolean)
        {
            Caption = 'Parent Link Synchronize';
            Description = 'means it should hold begin and length same';
        }
        field(230;"Detail Entry No.";Integer)
        {
            TableRelation = "Serv. Allocation Description";

            trigger OnValidate()
            begin
                //14.03.2014 Elva Baltic P8 #S0003 MMG7.00 >>
                IF xRec."Detail Entry No." <> "Detail Entry No." THEN BEGIN
                  LaborAllocEntry.RESET;
                  LaborAllocEntry.SETRANGE("Applies-to Entry No.", "Entry No.");
                  IF LaborAllocEntry.FINDFIRST THEN
                    REPEAT
                      IF LaborAllocEntry."Detail Entry No." <> "Detail Entry No." THEN BEGIN
                        LaborAllocEntry.VALIDATE("Detail Entry No.", "Detail Entry No.");
                        LaborAllocEntry.MODIFY;
                      END;
                    UNTIL LaborAllocEntry.NEXT = 0;
                END;
                //14.03.2014 Elva Baltic P8 #S0003 MMG7.00 <<
            end;
        }
        field(400;"Allocation Status";Option)
        {
            Caption = 'Allocation Status';
            Description = 'System';
            OptionCaption = 'Allocation,Unavailability';
            OptionMembers = Allocation,Unavailability;
        }
        field(410;"Resource Group Code";Code[10])
        {
            TableRelation = "Schedule Resource Group";
        }
        field(420;"Total Time Spent";Decimal)
        {
            CalcFormula = Sum("Resource Time Reg. Entry"."Time Spent" WHERE (Allocation Entry No.=FIELD(Entry No.),
                                                                             Canceled=CONST(No),
                                                                             Travel=CONST(No)));
            FieldClass = FlowField;
        }
        field(430;"Application Entry Count";Integer)
        {
            CalcFormula = Count("Serv. Labor Alloc. Application" WHERE (Allocation Entry No.=FIELD(Entry No.)));
            FieldClass = FlowField;
        }
        field(440;"Total Cost Amount";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Cost Amount" WHERE (Allocation Entry No.=FIELD(Entry No.)));
            FieldClass = FlowField;
        }
        field(450;"Last Clocked";Date)
        {
            CalcFormula = Max("Resource Time Reg. Entry".Date WHERE (Entry Type=FILTER(Finished|On Hold),
                                                                     Allocation Entry No.=FIELD(Entry No.)));
            FieldClass = FlowField;
        }
        field(460;Travel;Boolean)
        {
        }
        field(470;"Total Time Spent Travel";Decimal)
        {
            CalcFormula = Sum("Resource Time Reg. Entry"."Time Spent" WHERE (Allocation Entry No.=FIELD(Entry No.),
                                                                             Canceled=CONST(No),
                                                                             Travel=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(480;"Start Date Time";DateTime)
        {
        }
        field(490;"End Date Time";DateTime)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Resource No.")
        {
        }
        key(Key3;"Resource No.","Start Date-Time","End Date-Time")
        {
            SumIndexFields = "Quantity (Hours)";
        }
        key(Key4;"Resource No.","End Date-Time")
        {
        }
        key(Key5;"Source Type",Status,"Resource No.")
        {
        }
        key(Key6;"Applies-to Entry No.")
        {
        }
        key(Key7;"Source Type","Source Subtype","Source ID")
        {
        }
        key(Key8;"Source Type","Source Subtype","Source ID","Start Date-Time")
        {
        }
        key(Key9;"Parent Alloc. Entry No.")
        {
        }
        key(Key10;"Detail Entry No.")
        {
        }
        key(Key11;"Source ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ServiceOrderAllocation: Record "25006277";
    begin
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Allocation Entry No.", "Entry No.");
        ServLaborAllocApplication.DELETEALL;

        ResourceTimeRegEntry.RESET;
        ResourceTimeRegEntry.SETRANGE("Allocation Entry No.","Entry No.");
        ResourceTimeRegEntry.DELETEALL;
    end;

    trigger OnInsert()
    var
        recServResAlloc: Record "25006271";
    begin
        IF "Source Type" = "Source Type"::"Service Document" THEN BEGIN
          Resources.RESET;
          Resources.SETRANGE("No.","Resource No.");
          Resources.SETRANGE("Is Bay",FALSE);
          IF Resources.FINDFIRST THEN
            ServiceStepsChecking.CheckSteps("Source ID",Steps::CheckBay);
        END
    end;

    var
        ServLaborAllocApplication: Record "25006277";
        LaborAllocEntry: Record "25006271";
        ResourceTimeRegEntry: Record "25006290";
        ServiceStepsChecking: Codeunit "33020236";
        Steps: Option CheckBay,CheckChecklist,CheckDiagnosis;
        Resources: Record "156";
        DateTimeMgt: Codeunit "25006012";

    [Scope('Internal')]
    procedure GetLookupDetailsText(): Text[250]
    var
        ServLaborAllocationDetailLoc: Record "25006268";
    begin
        IF ServLaborAllocationDetailLoc.GET("Detail Entry No.") THEN;
        IF PAGE.RUNMODAL(0, ServLaborAllocationDetailLoc) = ACTION::LookupOK THEN BEGIN
          VALIDATE("Detail Entry No.", ServLaborAllocationDetailLoc."Entry No.");
          EXIT(ServLaborAllocationDetailLoc.Description);
        END;
        EXIT('');
    end;
}

