page 33020557 "Attendance Journal Details"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = Table33020554;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Attendance Date"; "Attendance Date")
                {
                }
                field("Day Type"; "Day Type")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Entry Subtype"; "Entry Subtype")
                {
                }
                field(Days; Days)
                {
                }
                field("Login frequency"; "Login frequency")
                {
                }
                field("Logout frequency"; "Logout frequency")
                {
                }
                field("Presence Minutes"; "Presence Minutes")
                {
                }
                field("Absense Minutes"; "Absense Minutes")
                {
                }
                field("Adjustment Type"; "Adjustment Type")
                {

                    trigger OnValidate()
                    begin
                        IF xRec."Adjustment Type" <> Rec."Adjustment Type" THEN
                            CheckReason;
                    end;
                }
                field("Adjustment Minutes"; "Adjustment Minutes")
                {
                }
                field("System Remarks"; "System Remarks")
                {
                }
                field("Conflict Exists"; "Conflict Exists")
                {
                }
                field("Conflict Description"; "Conflict Description")
                {
                }
                field(Correction; Correction)
                {
                }
                field("Corrected By"; "Corrected By")
                {
                }
                field("Correction Reason"; "Correction Reason")
                {
                }
            }
        }
    }

    actions
    {
    }

    [Scope('Internal')]
    procedure CheckReason()
    var
        Text000: Label 'You must first specify correction reason before modifying record.';
    begin
        IF "Correction Reason" = '' THEN
            ERROR(Text000);
    end;
}

