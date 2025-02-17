table 33020561 "Base Calendar Change PRm"
{
    Caption = 'Base Calendar Change';
    DataCaptionFields = "Base Calendar Code";
    DataPerCompany = false;

    fields
    {
        field(1; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar PRM";
        }
        field(2; "Recurring System"; Option)
        {
            Caption = 'Recurring System';
            OptionCaption = ' ,Annual Recurring,Weekly Recurring';
            OptionMembers = " ","Annual Recurring","Weekly Recurring";

            trigger OnValidate()
            begin
                IF "Recurring System" <> xRec."Recurring System" THEN
                    CASE "Recurring System" OF
                        "Recurring System"::"Annual Recurring":
                            Day := Day::" ";
                        "Recurring System"::"Weekly Recurring":
                            Date := 0D;
                    END;
            end;
        }
        field(3; Date; Date)
        {
            Caption = 'Date';

            trigger OnValidate()
            begin
                IF ("Recurring System" = "Recurring System"::" ") OR
                   ("Recurring System" = "Recurring System"::"Annual Recurring")
                THEN
                    TESTFIELD(Date)
                ELSE
                    TESTFIELD(Date, 0D);
                UpdateDayName;
            end;
        }
        field(4; Day; Option)
        {
            Caption = 'Day';
            OptionCaption = ' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;

            trigger OnValidate()
            begin
                IF "Recurring System" = "Recurring System"::"Weekly Recurring" THEN
                    TESTFIELD(Day);
                UpdateDayName;
            end;
        }
        field(5; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(6; Nonworking; Boolean)
        {
            Caption = 'Nonworking';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Base Calendar Code", "Recurring System", Date, Day)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CheckEntryLine;
    end;

    trigger OnModify()
    begin
        CheckEntryLine;
    end;

    trigger OnRename()
    begin
        CheckEntryLine;
    end;

    [Scope('Internal')]
    procedure UpdateDayName()
    var
        DateTable: Record "2000000007";
    begin
        IF (Date > 0D) AND
           ("Recurring System" = "Recurring System"::"Annual Recurring") THEN
            Day := Day::" "
        ELSE BEGIN
            DateTable.SETRANGE("Period Type", DateTable."Period Type"::Date);
            DateTable.SETRANGE("Period Start", Date);
            IF DateTable.FIND('-') THEN
                Day := DateTable."Period No.";
        END;
        IF (Date = 0D) AND (Day = Day::" ") THEN BEGIN
            Day := xRec.Day;
            Date := xRec.Date;
        END;
        IF "Recurring System" = "Recurring System"::"Annual Recurring" THEN
            TESTFIELD(Day, Day::" ");
    end;

    [Scope('Internal')]
    procedure CheckEntryLine()
    begin
        /*CASE "Recurring System" OF
        "Recurring System"::" ":
        BEGIN
          TESTFIELD(Date);
          TESTFIELD(Day);
        END;
        "Recurring System"::"Annual Recurring":
        BEGIN
          TESTFIELD(Date);
          TESTFIELD(Day,Day::" ");
        END;
        
        "Recurring System"::"Weekly Recurring":
        BEGIN
          TESTFIELD(Date,0D);
          TESTFIELD(Day);
        END;
        END;*/

    end;
}

