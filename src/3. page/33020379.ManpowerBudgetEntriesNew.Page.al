page 33020379 "Manpower Budget Entries New"
{
    PageType = List;
    SourceTable = Table33020378;

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
                field(xRec.TestYear;
                    xRec.TestYear)
                {
                    Caption = 'Last Year';
                    Editable = false;
                }
                field(xRec.TestYear1;
                    xRec.TestYear1)
                {
                    Caption = 'Begin Year';
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
        TestYear := xRec.TestYear;
        TestYear1 := xRec.TestYear1;
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

