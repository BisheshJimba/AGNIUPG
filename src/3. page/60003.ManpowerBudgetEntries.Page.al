page 60003 "Manpower Budget Entries"
{
    PageType = List;
    SourceTable = Table60002;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fiscal Year"; "Fiscal Year")
                {
                    Editable = false;
                }
                field("Department Code"; "Department Code")
                {
                    Editable = false;
                }
                field("Department Name"; "Department Name")
                {
                    Editable = false;
                }
                field(Date; Date)
                {
                }
                field(Description; Description)
                {
                }
                field(Location; Location)
                {
                }
                field("No. of Person"; "No. of Person")
                {
                }
                field("Entry No."; "Entry No.")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        //Deleting empty records while exiting page.
        GblMnprBdgtEntry.RESET;
        GblMnprBdgtEntry.SETFILTER("No. of Person", '=0');
        GblMnprBdgtEntry.SETFILTER(Location, '');
        IF GblMnprBdgtEntry.FIND('-') THEN
            GblMnprBdgtEntry.DELETEALL;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //Inserting details in new record.
        "Fiscal Year" := xRec."Fiscal Year";
        "Department Code" := xRec."Department Code";
        "Department Name" := xRec."Department Name";
        Date := xRec.Date;
        Position := xRec.Position;
        "Entry No." := getLastEntryNo + 1;
    end;

    var
        GblMnprBdgtEntry: Record "60002";

    [Scope('Internal')]
    procedure getLastEntryNo(): Integer
    var
        LclMnprBdgtEntry: Record "60002";
    begin
        LclMnprBdgtEntry.RESET;
        IF LclMnprBdgtEntry.FIND('+') THEN
            EXIT(LclMnprBdgtEntry."Entry No.");
    end;
}

