page 25006080 "Serv. Allocation Descriptions"
{
    Caption = 'Serv. Allocation Descriptions';
    PageType = List;
    SourceTable = Table25006268;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Allocation Entries")
            {
                Caption = 'Allocation Entries';
                Image = CalendarMachine;

                trigger OnAction()
                var
                    AllocEntry: Record "25006271";
                    DatetimeMgt: Codeunit "25006012";
                    ResourceNoFilter: Code[1000];
                    ResourceGrpSec: Record "25006275";
                begin
                    AllocEntry.RESET;
                    AllocEntry.SETRANGE("Detail Entry No.", "Entry No.");
                    IF PAGE.RUNMODAL(PAGE::"Serv. Labor Allocation Entries", AllocEntry) = ACTION::LookupOK THEN;
                end;
            }
        }
    }
}

